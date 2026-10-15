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
 * --fix 行为：服务未 active → restart；模型缺失 → 提示跑 audio8-fetch-model（不自动下 423MB）。
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
    logger.warn(`⚠  audio8-tts 未开机自启（${enabled}）：systemctl enable ${UNIT_NAME}`);
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
    } else if (parseInt(ortVer.split('.')[1] || '0', 10) >= 24) {
      // 0.1B runtime 要求 onnxruntime <1.24
      issues.push({ type: 'audio8-venv', severity: 'error', msg: `onnxruntime ${ortVer} 太新（0.1B runtime 要求 <1.24）。修复：${p.venvPy} -m pip install "onnxruntime>=1.22,<1.24"` });
      logger.error(`❌ onnxruntime ${ortVer}（要求 <1.24）`);
    } else {
      logger.ok(`✓ venv 就绪（onnxruntime ${ortVer}${tokVer ? `, tokenizers ${tokVer}` : ''}）`);
    }
    if (ortVer && !tokVer) {
      issues.push({ type: 'audio8-venv', severity: 'error', msg: `venv 缺 tokenizers。修复：${p.venvPy} -m pip install "tokenizers>=0.20,<0.23"` });
      logger.error(`❌ venv 缺 tokenizers`);
    }
  }

  // ---- 3. 模型核心文件 ----
  const missingFiles = MODEL_CORE_FILES.filter(f => !fs.existsSync(path.join(p.model, f)));
  if (missingFiles.length === MODEL_CORE_FILES.length) {
    issues.push({ type: 'audio8-model', severity: 'error', msg: `模型未下载：${p.model}。执行 adoremix audio8-fetch-model（~423MB），或自托管后 adoremix audio8-fetch-model <url>` });
    logger.error(`❌ 模型未下载：adoremix audio8-fetch-model`);
  } else if (missingFiles.length > 0) {
    issues.push({ type: 'audio8-model', severity: 'error', msg: `模型不完整，缺 ${missingFiles.length} 个文件：${missingFiles.slice(0, 3).join(', ')}${missingFiles.length > 3 ? ' 等' : ''}。重跑 adoremix audio8-fetch-model` });
    logger.error(`❌ 模型不完整（缺 ${missingFiles.length} 个文件），重跑 adoremix audio8-fetch-model`);
  } else {
    let modelMB = null;
    try { modelMB = Math.round(parseInt(sh(`du -sm "${p.model}" | cut -f1`), 10)); } catch (e) {}
    logger.ok(`✓ 模型完整（${p.model}${modelMB ? `, ~${modelMB}MB` : ''}）`);
  }

  // ---- 4. 默认音色 ----
  if (fs.existsSync(p.defaultVoiceMeta)) {
    logger.ok(`✓ 默认音色 default`);
  } else if (missingFiles.length === 0) {
    // 模型在但音色缺（旧版本 fetch-model 不会自动 seed）
    issues.push({ type: 'audio8-voice', severity: 'warn', msg: `默认音色缺失：${p.defaultVoiceMeta}。重跑 adoremix audio8-fetch-model（已有模型文件会秒过，仅补 seed）` });
    logger.warn(`⚠  默认音色 default 缺失，重跑 adoremix audio8-fetch-model 自动补`);
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

  // ---- 7. 磁盘余量 ----
  const diskMB = fs.existsSync(p.runtime) ? diskFreeMB(p.runtime) : null;
  if (diskMB !== null && diskMB < 1024) {
    issues.push({ type: 'audio8-disk', severity: 'warn', msg: `磁盘可用 ${diskMB}MB 不足 1GB（模型 423MB + venv ~500MB）` });
    logger.warn(`⚠  磁盘可用 ${diskMB}MB < 1GB`);
  } else if (diskMB !== null) {
    logger.ok(`✓ 磁盘可用 ${diskMB}MB`);
  }
}

module.exports = { checkAudio8Deployment, isInstalled, RUNTIME_DIR };
