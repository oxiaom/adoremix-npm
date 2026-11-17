'use strict';

/**
 * Audio8 本机部署体检（doctor 第 9 节）
 *
 * 检查项（与 v1.0.60+ 部署结构对齐）：
 *   1. systemd 单元存在 + enabled + active
 *   2. venv 解释器存在 + 关键 pip 包（onnxruntime <1.24 / tokenizers）
 *   3. 模型目录 + 核心文件（runtime_manifest.json 等）齐全
 *   4. 默认音色（voices/default/{codes.npy,meta.json}）
 *   5. /api/health 健康探测
 *   6. 内存余量（模型常驻 ~1.8GB，<2GB 可用会 OOM）
 *   7. 磁盘余量（模型 423MB + 源码 venv ~500MB，<1GB 告警）
 *
 * --fix 行为：
 *   - 服务未 active → systemctl restart
 *   - 未开机自启   → systemctl enable
 *   - venv 缺 pip 包 → pip install（onnxruntime 还会自动降到 <1.24）
 *   - 默认音色缺失 → 调 fetch-model 的 seed 逻辑补音色（模型已在，几秒）
 *   - 模型缺失     → **自动下载**（~423MB）。加 --fix-no-model 可跳过
 *   - ffmpeg 缺失   → 装系统包（apt/dnf/apk/pacman）
 */

const { execSync } = require('child_process');
const fs = require('fs');
const os = require('os');
const path = require('path');
const logger = require('./logger');

const RUNTIME_DIR = 'onnx_runtime_0_1b_int8';
const UNIT_NAME = 'audio8-tts';
const UNIT_PATH = `/etc/systemd/system/${UNIT_NAME}.service`;
const HEALTH_URL = 'http://127.0.0.1:8024/api/health';

const MODEL_CORE_FILES = [
  'runtime_manifest.json',
  'config.json',
  'reference_codes.npy',
  'codec_decoder_fp16.onnx',
  'codec_decoder_fp16.onnx.data',
  'slow_ar_int8.onnx',
  'slow_ar_int8.onnx.data',
  'fast_ar_int8.onnx',
  'fast_ar_int8.onnx.data',
  'tokenizer/tokenizer.json'
];

function paths() {
  const home = os.homedir();
  const runtime = path.join(home, 'audio8', RUNTIME_DIR);
  return {
    home,
    runtime,
    venvPy: path.join(runtime, '.venv', 'bin', 'python'),
    model: path.join(runtime, 'model'),
    defaultVoiceMeta: path.join(runtime, 'voices', 'default', 'meta.json')
  };
}

function sh(cmd) {
  try {
    return execSync(cmd, { shell: '/bin/bash', encoding: 'utf8', stdio: ['pipe', 'pipe', 'pipe'] }).trim();
  } catch (e) { return null; }
}

function isInstalled() {
  return fs.existsSync(UNIT_PATH) || fs.existsSync(paths().runtime);
}

// ---------------------------------------------------------------------------
// 自动修复用的动作
//
// 设计原则：**能自动修的就修，修不了的要说清楚下一步跑什么**。
// 之前 --fix 只会重启服务，其余全是"提示用户自己去跑某命令"，
// 装完 audio8 的用户还是得手动敲 3~4 条命令才能用起来。
// ---------------------------------------------------------------------------

// pip 装包（venv 里）
function pipInstall(venvPy, spec) {
  return execSync(`"${venvPy}" -m pip install ${spec}`, {
    shell: '/bin/bash',
    encoding: 'utf8',
    stdio: ['pipe', 'pipe', 'pipe']
  });
}

// 装系统包（ffmpeg 之类）
function detectPkgMgr() {
  for (const [cmd, args] of [['apt-get', 'apt-get install -y'], ['dnf', 'dnf install -y'],
                              ['yum', 'yum install -y'], ['apk', 'apk add --no-cache'],
                              ['pacman', 'pacman -S --noconfirm']]) {
    if (sh(`command -v ${cmd} 2>/dev/null`)) return args;
  }
  return null;
}

function installSystemPkg(pkg) {
  const mgr = detectPkgMgr();
  if (!mgr) return { ok: false, msg: '没找到包管理器（apt/dnf/yum/apk/pacman），请手工装 ' + pkg };
  try {
    execSync(`${mgr} ${pkg}`, { shell: '/bin/bash', encoding: 'utf8', stdio: ['pipe', 'pipe', 'pipe'] });
    return { ok: true };
  } catch (e) {
    return { ok: false, msg: (e.message || '').split('\n')[0] };
  }
}

// ffmpeg 在不在（Audio8 服务端只返 WAV，provider 层要转 mp3）
function hasFfmpeg() {
  return !!sh('command -v ffmpeg 2>/dev/null');
}

// 跑 adoremix audio8-fetch-model（同步）
//
// fetchModel 是 async 的，而 doctor 是同步函数 —— 直接 await 不了，
// 异步调用的结果会在 doctor 退出后丢（下载刚开始进程就退了）。
// 所以用子进程跑 CLI，等它真跑完。
function runFetchModel() {
  const cliJs = path.join(__dirname, '..', 'bin', 'adoremix.js');
  try {
    execSync(`node "${cliJs}" audio8-fetch-model`, {
      shell: '/bin/bash',
      encoding: 'utf8',
      stdio: ['pipe', 'pipe', 'pipe'],
      timeout: 30 * 60 * 1000   // 423MB，给 30 分钟
    });
    return { ok: true };
  } catch (e) {
    const out = `${(e.stdout || '').toString()}\n${(e.stderr || '').toString()}`;
    const line = out.split('\n').filter(l => l.trim()).pop() || (e.message || '').split('\n')[0];
    return { ok: false, msg: String(line).slice(0, 200) };
  }
}

// 内存(MB)：/proc/meminfo MemAvailable
function memAvailableMB() {
  try {
    const m = fs.readFileSync('/proc/meminfo', 'utf8').match(/MemAvailable:\s+(\d+)\s*kB/);
    return m ? Math.round(parseInt(m[1], 10) / 1024) : null;
  } catch (e) { return null; }
}

// 磁盘(MB)：runtime 所在挂载点可用空间
function diskFreeMB(dir) {
  const out = sh(`df -Pm "${dir}" 2>/dev/null | awk 'NR==2 {print $4}'`);
  const n = parseInt(out, 10);
  return isNaN(n) ? null : n;
}

function checkAudio8Deployment(issues, opts) {
  opts = opts || {};
  const p = paths();
  const providerActive = !!opts.providerActive;

  // ---- 1. systemd 单元 ----
  if (!fs.existsSync(UNIT_PATH)) {
    const msg = `Audio8 systemd 单元不存在（${UNIT_PATH}）。本机部署需 adoremix audio8 install；若改用远程 Audio8，请在 config.ini [TTS] audio8_base_url 配远程地址。`;
    issues.push({ type: 'audio8-unit', severity: providerActive ? 'error' : 'warn', msg });
    logger.error(`❌ ${msg}`);
    return; // 单元都没有，后面查了也没意义
  }
  const enabled = sh(`systemctl is-enabled ${UNIT_NAME} 2>/dev/null`) || 'unknown';
  if (enabled === 'enabled') {
    logger.ok(`✓ systemd 单元已注册（开机自启）`);
  } else {
    issues.push({ type: 'audio8-unit', severity: 'warn', msg: `audio8-tts 未 enabled（状态 ${enabled}），重启后不会自动拉起` });
    logger.warn(`⚠  audio8-tts 未开机自启（${enabled}）`);
    if (opts.fix) {
      logger.info(`==> 自动修复：systemctl enable ${UNIT_NAME}`);
      try {
        execSync(`systemctl enable ${UNIT_NAME}`, { stdio: 'inherit' });
        logger.ok('✓ 已设为开机自启');
      } catch (e) {
        logger.error(`开机自启设置失败：${(e.message || '').split('\n')[0]}`);
      }
    } else {
      logger.log(`    修复：systemctl enable ${UNIT_NAME}（或 doctor --fix 自动设置）`);
    }
  }
  const active = sh(`systemctl is-active ${UNIT_NAME} 2>/dev/null`) || 'unknown';
  if (active !== 'active') {
    issues.push({ type: 'audio8-active', severity: providerActive ? 'error' : 'warn', msg: `audio8-tts 未运行（${active}）。常见原因：模型未下载（adoremix audio8-fetch-model）或端口被占用。排查：journalctl -u ${UNIT_NAME} -n 30` });
    logger.error(`❌ audio8-tts 未运行（${active}）`);
    if (opts.fix) {
      logger.info(`==> 自动修复：systemctl restart ${UNIT_NAME}`);
      try {
        execSync(`systemctl restart ${UNIT_NAME}`, { stdio: 'inherit' });
        logger.ok('✓ 已重启（模型冷启动加载约 20-30 秒，稍后再跑 doctor 确认健康）');
      } catch (e) {
        logger.error(`重启失败：${(e.message || '').split('\n')[0]}，手动排查 journalctl -u ${UNIT_NAME} -n 30`);
      }
    } else {
      logger.log(`    修复：systemctl restart ${UNIT_NAME}（或 doctor --fix 自动重启）`);
    }
  } else {
    logger.ok(`✓ audio8-tts 运行中`);
  }

  // ---- 2. venv + 关键 pip 包 ----
  if (!fs.existsSync(p.venvPy)) {
    issues.push({ type: 'audio8-venv', severity: 'error', msg: `venv 解释器缺失：${p.venvPy}（重跑 adoremix audio8 install）` });
    logger.error(`❌ venv 缺失：${p.venvPy}`);
  } else {
    const ortVer = sh(`"${p.venvPy}" -c "import onnxruntime; print(onnxruntime.__version__)" 2>/dev/null`);
    const tokVer = sh(`"${p.venvPy}" -c "import tokenizers; print(tokenizers.__version__)" 2>/dev/null`);
    if (!ortVer) {
      issues.push({ type: 'audio8-venv', severity: 'error', msg: `venv 缺 onnxruntime（重跑 adoremix audio8 install）` });
      logger.error(`❌ venv 缺 onnxruntime`);
      if (opts.fix) {
        logger.info('==> 自动修复：pip install "onnxruntime>=1.22,<1.24"');
        try {
          pipInstall(p.venvPy, '"onnxruntime>=1.22,<1.24"');
          logger.ok('✓ onnxruntime 已安装');
        } catch (e) {
          logger.error(`安装失败：${(e.message || '').split('\n')[0]}`);
        }
      }
    } else if (parseInt(ortVer.split('.')[1] || '0', 10) >= 24) {
      // 0.1B runtime 要求 onnxruntime <1.24
      issues.push({ type: 'audio8-venv', severity: 'error', msg: `onnxruntime ${ortVer} 太新（0.1B runtime 要求 <1.24）。修复：${p.venvPy} -m pip install "onnxruntime>=1.22,<1.24"` });
      logger.error(`❌ onnxruntime ${ortVer}（要求 <1.24）`);
      if (opts.fix) {
        // 自动降级 —— 这个不修的话服务根本起不来
        logger.info('==> 自动修复：降级 onnxruntime 到 <1.24');
        try {
          pipInstall(p.venvPy, '"onnxruntime>=1.22,<1.24"');
          logger.ok('✓ onnxruntime 已降到 <1.24');
        } catch (e) {
          logger.error(`降级失败：${(e.message || '').split('\n')[0]}`);
        }
      }
    } else {
      logger.ok(`✓ venv 就绪（onnxruntime ${ortVer}${tokVer ? `, tokenizers ${tokVer}` : ''}）`);
    }
    if (ortVer && !tokVer) {
      issues.push({ type: 'audio8-venv', severity: 'error', msg: `venv 缺 tokenizers。修复：${p.venvPy} -m pip install "tokenizers>=0.20,<0.23"` });
      logger.error(`❌ venv 缺 tokenizers`);
      if (opts.fix) {
        logger.info('==> 自动修复：pip install "tokenizers>=0.20,<0.23"');
        try {
          pipInstall(p.venvPy, '"tokenizers>=0.20,<0.23"');
          logger.ok('✓ tokenizers 已安装');
        } catch (e) {
          logger.error(`安装失败：${(e.message || '').split('\n')[0]}`);
        }
      }
    }
  }

  // ---- 3. 模型核心文件 ----
  const missingFiles = MODEL_CORE_FILES.filter(f => !fs.existsSync(path.join(p.model, f)));
  let modelReady = false;
  if (missingFiles.length === MODEL_CORE_FILES.length) {
    issues.push({ type: 'audio8-model', severity: 'error', msg: `模型未下载：${p.model}。执行 adoremix audio8-fetch-model（~423MB），或自托管后 adoremix audio8-fetch-model <url>` });
    logger.error(`❌ 模型未下载`);
    if (opts.fix && !opts.fixNoModel) {
      // 模型是最大的一块（~423MB），但自动装 audio8 的场景里，
      // 没模型 = 服务起不来 = 白装。默认直接下。
      logger.info('==> 自动修复：下载模型（~423MB，需要几分钟）');
      const r = runFetchModel();
      if (r.ok) logger.ok('✓ 模型下载完成');
      else logger.error(`模型下载失败：${r.msg}`);
    } else if (opts.fix && opts.fixNoModel) {
      logger.log('    跳过模型下载（--fix-no-model），请手工跑 adoremix audio8-fetch-model');
    } else {
      logger.log('    修复：adoremix audio8-fetch-model（~423MB）或 doctor --fix 自动下载');
    }
  } else if (missingFiles.length > 0) {
    issues.push({ type: 'audio8-model', severity: 'error', msg: `模型不完整，缺 ${missingFiles.length} 个文件：${missingFiles.slice(0, 3).join(', ')}${missingFiles.length > 3 ? ' 等' : ''}。重跑 adoremix audio8-fetch-model` });
    logger.error(`❌ 模型不完整（缺 ${missingFiles.length} 个文件）`);
    if (opts.fix && !opts.fixNoModel) {
      logger.info('==> 自动修复：补齐缺失的模型文件');
      const r = runFetchModel();
      if (r.ok) logger.ok('✓ 模型已补齐');
      else logger.error(`模型下载失败：${r.msg}`);
    } else {
      logger.log('    修复：adoremix audio8-fetch-model');
    }
  } else {
    modelReady = true;
    let modelMB = null;
    try { modelMB = Math.round(parseInt(sh(`du -sm "${p.model}" | cut -f1`), 10)); } catch (e) {}
    logger.ok(`✓ 模型完整（${p.model}${modelMB ? `, ~${modelMB}MB` : ''}）`);
  }

  // ---- 4. 默认音色 ----
  if (fs.existsSync(p.defaultVoiceMeta)) {
    logger.ok(`✓ 默认音色 default`);
  } else if (modelReady) {
    // 模型在但音色缺（旧版本 fetch-model 不会自动 seed）
    issues.push({ type: 'audio8-voice', severity: 'warn', msg: `默认音色缺失：${p.defaultVoiceMeta}。重跑 adoremix audio8-fetch-model（已有模型文件会秒过，仅补 seed）` });
    logger.warn(`⚠  默认音色 default 缺失`);
    if (opts.fix) {
      // 模型已在，重新跑 fetch-model 会秒过（只补音色，不重复下 423MB）
      logger.info('==> 自动修复：补默认音色（模型已在，很快）');
      const r = runFetchModel();
      if (r.ok) logger.ok('✓ 默认音色已补齐');
      else logger.error(`补音色失败：${r.msg}`);
    } else {
      logger.log('    修复：adoremix audio8-fetch-model（自动补）');
    }
  }

  // ---- 5. 健康探测（服务 active 时才查）----
  if (active === 'active') {
    const code = sh(`curl -s -o /dev/null -w "%{http_code}" --max-time 5 "${HEALTH_URL}"`);
    if (code === '200') {
      logger.ok(`✓ /api/health 200`);
    } else if (code === '000') {
      logger.warn(`⚠  /api/health 无响应（模型冷启动中约 20-30 秒属正常，稍后重试）`);
    } else {
      issues.push({ type: 'audio8-health', severity: 'warn', msg: `/api/health 返回 HTTP ${code}` });
      logger.warn(`⚠  /api/health HTTP ${code}`);
    }
  }

  // ---- 6. 内存余量 ----
  const memMB = memAvailableMB();
  if (memMB !== null) {
    if (memMB < 1000) {
      issues.push({ type: 'audio8-mem', severity: 'error', msg: `可用内存 ${memMB}MB 不足（Audio8 模型常驻 ~1.8GB），加载会 OOM。建议换 ≥3GB 内存机器,或改用云端 TTS（xf/edge）` });
      logger.error(`❌ 可用内存 ${memMB}MB < 1GB（模型加载需 ~1.8GB）`);
    } else if (memMB < 2000) {
      logger.warn(`⚠  可用内存 ${memMB}MB 偏紧（模型常驻 ~1.8GB，建议 ≥3GB 总内存）`);
    } else {
      logger.ok(`✓ 可用内存 ${memMB}MB`);
    }
  }

  // ---- 7. ffmpeg（provider 层 WAV→MP3 转码用）----
  // Audio8 服务端只返回 WAV，AdoreMix 必须靠 ffmpeg 转成 mp3 才能推给设备。
  // 缺 ffmpeg 的话合成会失败，但报错在 TTS 层，现场很难联想到是这个。
  if (!hasFfmpeg()) {
    issues.push({ type: 'audio8-ffmpeg', severity: 'error', msg: `缺 ffmpeg（Audio8 返回 WAV，AdoreMix 需要它转 mp3）。修复：装 ffmpeg` });
    logger.error('❌ 缺 ffmpeg（Audio8 需要它做 WAV→MP3 转码）');
    if (opts.fix) {
      logger.info('==> 自动修复：安装 ffmpeg');
      const r = installSystemPkg('ffmpeg');
      if (r.ok) logger.ok('✓ ffmpeg 已安装');
      else logger.error(`安装失败：${r.msg}`);
    } else {
      logger.log('    修复：apt install ffmpeg（或 doctor --fix 自动装）');
    }
  } else {
    logger.ok('✓ ffmpeg 就绪');
  }

  // ---- 8. 磁盘余量 ----
  const diskMB = fs.existsSync(p.runtime) ? diskFreeMB(p.runtime) : null;
  if (diskMB !== null && diskMB < 1024) {
    issues.push({ type: 'audio8-disk', severity: 'warn', msg: `磁盘可用 ${diskMB}MB 不足 1GB（模型 423MB + venv ~500MB）` });
    logger.warn(`⚠  磁盘可用 ${diskMB}MB < 1GB`);
  } else if (diskMB !== null) {
    logger.ok(`✓ 磁盘可用 ${diskMB}MB`);
  }
}

module.exports = { checkAudio8Deployment, isInstalled, RUNTIME_DIR };
