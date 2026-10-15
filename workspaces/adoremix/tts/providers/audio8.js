'use strict';

/**
 * Audio8 TTS provider
 * 调用方式：HTTP 调用本地 Audio8 TTS 服务（OpenAI 兼容路径 POST /v1/audio/speech）
 * 服务只返回 WAV（response_format 仅支持 wav|pcm）→ 本地 ffmpeg 转 MP3 给设备管道
 *
 * 部署：adoremix audio8 install（装 onnx_runtime_0_1b_int8 + venv + systemd）
 *       adoremix audio8-fetch-model（下 ~423MB 0.1B INT8 模型 + 生成默认音色）
 *       systemctl restart audio8-tts
 * 端点：GET /api/health 健康检查；voice 必填（default=模型内置参考音）
 *
 * 凭证：不需要 API Key（本地服务）
 * 依赖：ffmpeg（WAV → MP3 转码，必需）
 *
 * 性能提示：CPU int8 推理慢（2 核 Celeron 实测 ~15s 生成 1s 音频，线程数已按核数自适应），
 * 适合定时广播预生成，弱 CPU 不建议实时喊话。
 * 声音克隆：0.5-30s 参考音频 + 转写文本，POST /api/voices/register（需额外下 registration 模型，
 * adoremix audio8-fetch-model --registration）
 */

const { execFileSync, execSync, execFile } = require('child_process');
const fs = require('fs');
const path = require('path');
const os = require('os');
const https = require('https');
const http = require('http');
const { URL } = require('url');
const logger = require('../../src/logger');

// Audio8 没有预置音色库(每个音色需注册克隆)。install/fetch-model 会自动把模型内置
// 参考音物化为 default 音色——所有短名先都映射到 default,注册克隆音色后再扩展。
const VOICES = {
  xiaoxiao: 'default', xiaoyi: 'default', xiaomo: 'default', xiaoxuan: 'default',
  yunxi: 'default', yunjian: 'default', yunyang: 'default',
  default: 'default'
};

const DEFAULT_BASE_URL = 'http://127.0.0.1:8024';
// 弱 CPU 上 0.1B int8 合成很慢(实测 2 核 Celeron 约 15s/1s 音频),
// 服务端算完才回包,socket 空闲时间长,超时必须放宽到 10 分钟
const DEFAULT_TIMEOUT_MS = 600000;

function checkDeps() {
  const issues = [];
  // ffmpeg：HTTP 流 → mp3 文件
  try {
    execFileSync('ffmpeg', ['-version'], { stdio: 'pipe' });
  } catch (e) {
    issues.push({ msg: '未找到 ffmpeg（需要将 HTTP 流保存为 mp3 文件）', fix: 'apt-get install -y ffmpeg (Debian/Ubuntu) 或 yum install -y ffmpeg (CentOS/AlmaLinux)' });
  }
  return issues;
}

// 从 Audio8 服务拉 MP3 流，通过 ffmpeg 转为指定输出文件
// Audio8 服务返回 OpenAI 兼容的 audio/mpeg 流（直接是 mp3）
function streamToFile(audioStream, outFile) {
  return new Promise((resolve, reject) => {
    // 边收边写：tee 到临时文件，避免等全部下载
    const tmpFile = outFile + '.part';
    const ws = fs.createWriteStream(tmpFile);
    let totalBytes = 0;
    audioStream.on('data', chunk => {
      totalBytes += chunk.length;
    });
    audioStream.on('error', err => {
      ws.destroy();
      try { fs.unlinkSync(tmpFile); } catch (e) {}
      reject(new Error(`Audio8 流接收错误: ${err.message}`));
    });
    audioStream.pipe(ws);
    ws.on('finish', () => {
      try {
        // Audio8 直接返回 audio/mpeg（mp3 流），无需 ffmpeg 转码
        fs.renameSync(tmpFile, outFile);
        resolve(totalBytes);
      } catch (e) {
        reject(new Error(`Audio8 临时文件改名失败: ${e.message}`));
      }
    });
    ws.on('error', err => {
      try { fs.unlinkSync(tmpFile); } catch (e) {}
      reject(new Error(`Audio8 写文件失败: ${err.message}`));
    });
  });
}

// ffmpeg WAV → MP3（Audio8 的 /v1/audio/speech 只支持 wav|pcm，设备端要 mp3，本地转码）
function transcodeToMp3(wavFile, mp3File) {
  return new Promise((resolve, reject) => {
    execFile('ffmpeg',
      ['-y', '-loglevel', 'error', '-i', wavFile, '-codec:a', 'libmp3lame', '-qscale:a', '4', mp3File],
      (err, stdout, stderr) => {
        if (err) return reject(new Error('ffmpeg WAV→MP3 转码失败: ' + String(stderr || err.message).split('\n')[0]));
        resolve();
      });
  });
}

function synthesize({ text, voice, volume, speed, outFile }, creds) {
  return new Promise((resolve, reject) => {
    const issues = checkDeps();
    if (issues.length > 0) {
      return reject(new Error('Audio8 依赖缺失:\n  ' + issues.map(i => i.msg + ' (修复: ' + i.fix + ')').join('\n  ')));
    }

    const baseUrl = (creds && creds.audio8_base_url) || DEFAULT_BASE_URL;
    const wantedVoice = VOICES[voice] || VOICES.default;

    // OpenAI 兼容路径:POST /v1/audio/speech。仅支持 response_format=wav|pcm,
    // 音量/语速服务端不支持(静默忽略),mp3 由本地 ffmpeg 转码。
    let urlObj;
    try { urlObj = new URL(baseUrl); } catch (e) {
      return reject(new Error(`Audio8 服务地址无效: ${baseUrl}（请在 config.ini [TTS] audio8_base_url 配置，例 http://127.0.0.1:8024）`));
    }
    urlObj.pathname = '/v1/audio/speech';
    const postData = JSON.stringify({
      input: text,
      voice: wantedVoice,
      response_format: 'wav'
    });
    const opts = {
      hostname: urlObj.hostname,
      port: urlObj.port || (urlObj.protocol === 'https:' ? 443 : 80),
      path: urlObj.pathname,
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Content-Length': Buffer.byteLength(postData)
      },
      timeout: DEFAULT_TIMEOUT_MS
    };
    const lib = urlObj.protocol === 'https:' ? https : http;
    const req = lib.request(opts, res => {
      if (res.statusCode !== 200) {
        let body = '';
        res.on('data', c => body += c);
        res.on('end', () => {
          reject(new Error(`Audio8 返回 HTTP ${res.statusCode}: ${body.slice(0, 200)}`));
        });
        return;
      }
      // 服务端算完才回 WAV(弱 CPU 上要几十秒到几分钟) → 落临时 wav → ffmpeg 转 mp3
      const wavTmp = outFile + '.a8wav';
      streamToFile(res, wavTmp)
        .then(() => transcodeToMp3(wavTmp, outFile))
        .then(() => {
          try { fs.unlinkSync(wavTmp); } catch (e) {}
          let bytes = 0;
          try { bytes = fs.statSync(outFile).size; } catch (e) {}
          resolve({ bytes });
        })
        .catch(reject);
    });
    req.on('error', err => {
      reject(new Error(`Audio8 连接失败（${baseUrl}）: ${err.message}。请确认 Audio8 TTS 服务已启动（adoremix audio8 status），且 config.ini [TTS] audio8_base_url 配置正确。`));
    });
    req.on('timeout', () => {
      req.destroy();
      reject(new Error(`Audio8 请求超时（${DEFAULT_TIMEOUT_MS / 1000}s）。弱 CPU 上合成慢属正常(约 15s/1s 音频)，可稍后重试或换短文本。`));
    });
    req.write(postData);
    req.end();
  });
}

// ===== audio8 install / uninstall / status（类似 nginx install 的可选组件）=====
// **本机部署**:在当前 adoremix 进程所在机器上直接装（不是 SSH）。
// 各机器跑 `adoremix audio8 install` 就在自己身上起 Audio8 TTS 服务。
// 仅 Linux 可装（依赖 Python3 + venv + systemd），Windows/macOS 直接提示不支持。
const AUDIO8_DEFAULT_PORT = 8024;
const AUDIO8_REPO = 'https://github.com/Audio8-AI/Audio8_TTS.git';
const AUDIO8_DEPLOY_DIR = '~/audio8';
// 0.1B INT8 模型必须配套 onnx_runtime_0_1b_int8/ 运行时（官方模型卡明示:
// onnx_runtime/ 目录是 0.6B INT4 专用,与 0.1B INT8 图不兼容——实测 cache 输入名对不上必报 KeyError）
const AUDIO8_RUNTIME_DIR = 'onnx_runtime_0_1b_int8';
const AUDIO8_VENV_DIR = `~/audio8/${AUDIO8_RUNTIME_DIR}/.venv`;
const AUDIO8_REQUIREMENTS = `${AUDIO8_RUNTIME_DIR}/requirements.txt`;
const AUDIO8_SYSTEMD_NAME = 'audio8-tts';
const AUDIO8_SYSTEMD_PATH = '/etc/systemd/system/audio8-tts.service';
const AUDIO8_HEALTH_URL = `http://127.0.0.1:${AUDIO8_DEFAULT_PORT}/api/health`;

// 包管理器嗅探（apt/dnf/yum/apk/pacman）
// 用 which 而非 command -v（Debian/Ubuntu 12+ 的 /bin/sh 没有 command 内建，且 PATH 不一定对）
function detectPkgMgr() {
  function exists(cmd) {
    try {
      const out = execSync('which ' + cmd + ' 2>/dev/null || echo NOT_FOUND', { shell: '/bin/bash', encoding: 'utf8' });
      const t = out.trim();
      return t !== '' && t !== 'NOT_FOUND';
    } catch (e) { return false; }
  }
  if (exists('apt-get')) return 'apt';
  if (exists('dnf')) return 'dnf';
  if (exists('yum')) return 'yum';
  if (exists('apk')) return 'apk';
  if (exists('pacman')) return 'pacman';
  return null;
}

function systemInstallCmd(pkgMgr, pkgs) {
  // pkgs: { name: 'pkg-name' } 数组
  const list = pkgs.map(p => p.name).join(' ');
  switch (pkgMgr) {
    case 'apt': return `apt-get update && apt-get install -y ${list}`;
    case 'dnf':
    case 'yum': return `${pkgMgr} install -y ${list}`;
    case 'apk': return `apk add ${list}`;
    case 'pacman': return `pacman -Sy --noconfirm ${list}`;
    default: return null;
  }
}

function buildSystemdUnit() {
  // systemd 不展开 ~，必须用绝对路径(root 下 $HOME=/root)
  const home = (function(){
    try { return execSync('/bin/bash -c "echo $HOME"', { shell: '/bin/bash', stdio: 'pipe', encoding: 'utf8' }).trim() || '/root'; }
    catch (e) { return '/root'; }
  })();
  const runtimeDir = path.join(home, 'audio8', AUDIO8_RUNTIME_DIR);
  const venvDir = AUDIO8_VENV_DIR.replace(/^~/, home);
  // 推理线程数 = CPU 核数(默认 5 在少核机器上严重超订阅,实测 2 核 Celeron:
  // THREADS=5 要 93s,THREADS=2 只要 37s,2.5 倍差距)
  const threads = os.cpus().length || 2;
  return `[Unit]
Description=Audio8 TTS (AdoreMix)
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=${runtimeDir}
Environment=PATH=${venvDir}/bin:/usr/bin:/bin
Environment=ARKTTS_MODEL_DIR=${runtimeDir}/model
Environment=ARKTTS_VOICES_DIR=${runtimeDir}/voices
Environment=ARKTTS_PRECISION=int8
Environment=ARKTTS_CODEC_PRECISION=fp16
Environment=ARKTTS_THREADS=${threads}
# service.py 只定义 FastAPI app,无启动入口,必须用 uvicorn 拉起(python -m arktts_runtime.service 会静默退出)
ExecStart=${venvDir}/bin/python -m uvicorn arktts_runtime.service:app --host 0.0.0.0 --port ${AUDIO8_DEFAULT_PORT}
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
`;
}

function install(opts) {
  opts = opts || {};
  // 平台检查
  if (process.platform !== 'linux') {
    logger.error(`Audio8 TTS 仅支持 Linux（当前 ${process.platform}，Windows/macOS 上 ffmpeg/venv/systemd 不可用）`);
    logger.log(`如需在 Windows 本机用 Audio8，请用 WSL2 或部署到 Linux 主机后通过 config.ini audio8_base_url 远程调用。`);
    return 1;
  }

  // 探测包管理器
  const pkgMgr = detectPkgMgr();
  if (!pkgMgr) {
    logger.error('未识别到包管理器（apt/dnf/yum/apk/pacman 均未找到）。Audio8 install 仅支持这些主流 Linux 发行版。');
    return 1;
  }
  logger.ok(`检测到包管理器: ${pkgMgr}`);

  // 包映射（按发行版提供 ffmpeg/git/python3）
  // ffmpeg 在 RHEL 系官方源没有，要先装 epel-release
  let sysPkgs = [
    { name: 'git' },
    { name: 'python3' },
    { name: 'python3-pip' },     // Debian/Ubuntu
    { name: 'python3-venv' },
    { name: 'ffmpeg' }
  ];
  if (pkgMgr === 'dnf' || pkgMgr === 'yum') {
    sysPkgs = [
      { name: 'git' },
      { name: 'python3' },
      { name: 'python3-pip' },
      { name: 'python3-virtualenv' },   // RHEL 系包名不同
      { name: 'epel-release' },          // ffmpeg 在 EPEL
      { name: 'ffmpeg' }
    ];
  }
  if (pkgMgr === 'apk') {
    sysPkgs = [
      { name: 'git' },
      { name: 'python3' },
      { name: 'py3-pip' },
      { name: 'ffmpeg' }
    ];
  }

  try {
    logger.log('=== 安装系统依赖 ===');
    execSync(systemInstallCmd(pkgMgr, sysPkgs), { stdio: 'inherit' });
    if (pkgMgr === 'dnf' || pkgMgr === 'yum') {
      // EPEL 装好后再装 ffmpeg
      try { execSync(`${pkgMgr} install -y ffmpeg --enablerepo=epel`, { stdio: 'inherit' }); } catch (e) { logger.warn('ffmpeg 安装失败（EPEL 装好后重试）: ' + e.message); }
    }
  } catch (e) {
    logger.error('系统依赖安装失败: ' + e.message.slice(0, 200));
    return 1;
  }

  // config 工作目录:与 adoremix 其余命令同源(root Linux 下是 /opt/adoremix,不是 ~/.local/share)
  const pathsMod = require(path.join(__dirname, '..', '..', 'src', 'paths'));
  const configWorkdir = () => opts.workdir || process.env.ADOREMIX_WORKDIR || pathsMod.defaultWorkdir();

  // 检查 config.ini 是否有预托管模型（audio8_model_dir）
  let modelDir = '';
  try {
    const cfg = require(path.join(__dirname, '..', '..', 'src', 'config'));
    modelDir = cfg.getConfigValue(configWorkdir(), 'TTS.audio8_model_dir') || '';
  } catch (e) {}
  const modelLink = `~/audio8/${AUDIO8_RUNTIME_DIR}/model`;  // Audio8 期望的模型目录
  // 如果有预托管模型目录，建软链指向
  if (modelDir) {
    try {
      logger.log('=== 链接预托管模型 ' + modelDir + ' → ' + modelLink + ' ===');
      execSync(`mkdir -p $(dirname ${modelLink}) && rm -rf ${modelLink} && ln -s ${modelDir} ${modelLink}`, { stdio: 'inherit', shell: '/bin/bash' });
    } catch (e) {
      logger.warn('链接模型失败: ' + e.message);
    }
  }

  // 拉 Audio8_TTS 源码：先试内置 tarball（主包 audio8-assets/audio8-tts.tgz，离线），再 git 镜像，最后 codeload
  let cloned = false;
  // 1) 主包内置 tarball（最稳，完全离线）
  const BUNDLED_TARBALL = path.join(__dirname, '..', '..', 'audio8-assets', 'audio8-tts.tgz');
  if (fs.existsSync(BUNDLED_TARBALL)) {
    try {
      logger.log('=== 使用主包内置 Audio8_TTS tarball（离线） ===');
      // tarball 可能带 1~2 层包装目录(如 audio8src/Audio8_TTS-master/)。
      // 不用 --strip-components(层数不定),解压后在 ~/audio8 里循环平仓:
      // 只要目录下只有一个子目录且还看不到 onnx_runtime/,就把子目录内容上提,最多 3 层。
      execSync(`rm -rf ~/audio8 && mkdir -p ~/audio8 && tar xzf "${BUNDLED_TARBALL}" -C ~/audio8 && ` +
        `cd ~/audio8 && for i in 1 2 3; do ` +
        `[ -f ${AUDIO8_RUNTIME_DIR}/requirements.txt ] && break; ` +
        `single=$(ls -A | wc -l); [ "$single" = "1" ] || break; ` +
        `d=$(ls -A); [ -d "$d" ] || break; ` +
        `mv "$d"/* . 2>/dev/null; mv "$d"/.[!.]* . 2>/dev/null; rmdir "$d" 2>/dev/null || true; ` +
        `done; ls ~/audio8 | head -5`, { stdio: 'inherit', shell: '/bin/bash' });
      // 平仓后必须能看到 runtime 的 requirements.txt,否则视为解压失败
      const flat = execSync(`[ -f ~/audio8/${AUDIO8_RUNTIME_DIR}/requirements.txt ] && echo OK || echo MISSING`,
        { shell: '/bin/bash', encoding: 'utf8', stdio: ['pipe', 'pipe', 'pipe'] }).trim();
      if (flat === 'OK') cloned = true;
      else logger.warn(`内置 tarball 解压后未找到 ${AUDIO8_RUNTIME_DIR}/requirements.txt（目录层级异常）`);
    } catch (e) {
      logger.warn('内置 tarball 解压失败：' + e.message);
    }
  } else {
    logger.warn(`主包内置 tarball 不存在：${BUNDLED_TARBALL}`);
  }
  // 2) Git 镜像（fallback）
  if (!cloned) {
    const MIRRORS = [
      AUDIO8_REPO,
      'https://ghproxy.cn/https://github.com/Audio8-AI/Audio8_TTS.git',
      'https://hub.fastgit.xyz/Audio8-AI/Audio8_TTS.git'
    ];
    for (let attempt = 1; attempt <= 2 && !cloned; attempt++) {
      for (const url of MIRRORS) {
        try {
          logger.log(`=== 克隆 Audio8_TTS（第 ${attempt} 次）: ${url} ===`);
          execSync(`rm -rf ~/audio8_temp && git clone --depth=1 "${url}" ~/audio8_temp 2>&1 | tail -3`, { stdio: 'inherit', shell: '/bin/bash' });
          execSync(`bash -c "cd ~/audio8_temp && (shopt -s dotglob; mv -- * ~/audio8/ 2>/dev/null || true)"`, { stdio: 'inherit', shell: '/bin/bash' });
          execSync('rm -rf ~/audio8_temp', { stdio: 'ignore', shell: '/bin/bash' });
          cloned = true;
          break;
        } catch (e) {
          logger.warn(`克隆失败：${String(e.message).slice(0, 100)}`);
        }
      }
      if (!cloned) execSync('sleep 5', { stdio: 'ignore', shell: '/bin/bash' });
    }
  }
  // 3) codeload tarball（最后备选）
  if (!cloned) {
    try {
      logger.log('=== 备选：codeload github tarball ===');
      execSync(`rm -rf ~/audio8 && mkdir -p ~/audio8 && cd /tmp && curl -fL --retry 3 --connect-timeout 10 https://codeload.github.com/Audio8-AI/Audio8_TTS/tar.gz/master -o audio8.tar.gz && tar xzf audio8.tar.gz --strip-components=1 -C ~/audio8 && rm -f audio8.tar.gz && ls ~/audio8 | head -3`, { stdio: 'inherit', shell: '/bin/bash' });
      cloned = true;
    } catch (e) {
      logger.error('codeload 也失败：' + String(e.message).slice(0, 200));
    }
  }
  if (!cloned) {
    logger.error('所有源都失败，无法获取 Audio8_TTS 源码');
    logger.warn('解决：手动在 ~/audio8 下放好 Audio8_TTS 源码再重试 install');
    return 1;
  }
  // 统一校验目录结构(git clone 路径也可能带包装目录)
  const layoutOk = execSync(`[ -f ~/audio8/${AUDIO8_RUNTIME_DIR}/requirements.txt ] && echo OK || echo MISSING`,
    { shell: '/bin/bash', encoding: 'utf8', stdio: ['pipe', 'pipe', 'pipe'] }).trim();
  if (layoutOk !== 'OK') {
    logger.error(`~/audio8 目录结构异常：未找到 ${AUDIO8_RUNTIME_DIR}/requirements.txt（可能多了包装目录）`);
    logger.log('当前内容: ' + execSync('ls ~/audio8', { shell: '/bin/bash', encoding: 'utf8', stdio: ['pipe', 'pipe', 'pipe'] }).trim().replace(/\n/g, ' '));
    return 1;
  }

  // venv + pip install（Python 3.11+，numpy 2.4.3 需要）
  // venv 路径必须与 AUDIO8_VENV_DIR/buildSystemdUnit 一致(~/audio8/onnx_runtime_0_1b_int8/.venv),
  // 否则 systemd ExecStart 指向不存在的解释器,服务起不来
  const pyBase = (function(){
    try { execSync('command -v python3.11 2>/dev/null', { shell: '/bin/bash', stdio: 'pipe' }); return 'python3.11'; }
    catch (e) { return 'python3'; }
  })();
  const venvDir = AUDIO8_VENV_DIR.replace(/^~/, os.homedir());
  try {
    logger.log('=== 创建 venv 并安装 Python 依赖（onnxruntime 等约 100MB,Python=' + pyBase + '）===');
    execSync(`${pyBase} -m venv ${venvDir}`, { stdio: 'inherit', shell: '/bin/bash' });
    // 大包走清华镜像(国内/公司网下官方 PyPI 常超时),失败再回退官方源。
    // 0.1B runtime 的 requirements 已含 tokenizers(>=0.20,<0.23) 与 onnxruntime(>=1.22,<1.24) 约束。
    const pipCmd = (idx) =>
      `source ${venvDir}/bin/activate && pip install -U pip --quiet && ` +
      `pip install -r ~/audio8/${AUDIO8_RUNTIME_DIR}/requirements.txt --quiet ${idx}`;
    try {
      execSync(pipCmd('--index-url https://pypi.tuna.tsinghua.edu.cn/simple'), { stdio: 'inherit', shell: '/bin/bash' });
    } catch (e) {
      logger.warn('清华镜像安装失败，回退官方 PyPI 重试: ' + String(e.message).slice(0, 150));
      execSync(pipCmd(''), { stdio: 'inherit', shell: '/bin/bash' });
    }
  } catch (e) {
    logger.error('Python 依赖安装失败: ' + e.message.slice(0, 200));
    return 1;
  }

  // 写 systemd 单元
  try {
    fs.writeFileSync(AUDIO8_SYSTEMD_PATH, buildSystemdUnit(), 'utf8');
    execSync('systemctl daemon-reload', { stdio: 'inherit', shell: '/bin/bash' });
    execSync(`systemctl enable ${AUDIO8_SYSTEMD_NAME}`, { stdio: 'inherit', shell: '/bin/bash' });
    execSync(`systemctl restart ${AUDIO8_SYSTEMD_NAME}`, { stdio: 'inherit', shell: '/bin/bash' });
  } catch (e) {
    logger.error('systemd 配置失败（无 systemd 容器？手动启动: ~/audio8_venv/bin/python -m arktts_runtime.service）: ' + e.message.slice(0, 200));
    return 1;
  }

  // 等服务健康（模型单独用 audio8-fetch-model 下载，未下模型时服务起不来是预期）
  const modelDirFull = path.join(os.homedir(), 'audio8', AUDIO8_RUNTIME_DIR, 'model');
  const modelReady = fs.existsSync(path.join(modelDirFull, 'runtime_manifest.json'));
  if (modelReady) {
    seedDefaultVoice(modelDirFull);
  } else {
    logger.warn('模型未下载（正常，模型与 install 解耦）: 先执行 adoremix audio8-fetch-model 下载 ~423MB 模型,再 systemctl restart ' + AUDIO8_SYSTEMD_NAME);
  }
  logger.log('=== 等待服务健康（最多 60 秒，模型冷启动加载约 20-30 秒）===');
  let ok = false;
  for (let i = 1; i <= 30; i++) {
    try {
      execSync(`curl -sf ${AUDIO8_HEALTH_URL} >/dev/null 2>&1`);
      logger.ok(`Audio8 服务在 ${i*2} 秒后就绪: ${AUDIO8_HEALTH_URL}`);
      ok = true;
      break;
    } catch (e) {}
    execSync('sleep 2', { stdio: 'pipe', shell: '/bin/bash' });
  }
  if (!ok) {
    logger.warn('60 秒内未就绪: ' + (modelReady ? '请手动 systemctl status ' + AUDIO8_SYSTEMD_NAME : '模型缺失所致,先跑 adoremix audio8-fetch-model'));
    logger.log('前台排查: journalctl -u ' + AUDIO8_SYSTEMD_NAME + ' -n 30');
  }

  // 改本地 config.ini(tts/providers/ → 主包 src/config 要退两级)
  try {
    const cfg = require(path.join(__dirname, '..', '..', 'src', 'config'));
    const wd = configWorkdir();
    cfg.setConfigValue(wd, 'TTS.provider', 'audio8');
    cfg.setConfigValue(wd, 'TTS.audio8_base_url', `http://127.0.0.1:${AUDIO8_DEFAULT_PORT}`);
    logger.ok(`config.ini 已更新(${wd}): provider=audio8, audio8_base_url=http://127.0.0.1:${AUDIO8_DEFAULT_PORT}`);
  } catch (e) {
    logger.warn('config.ini 更新失败: ' + e.message);
  }

  logger.ok(`Audio8 TTS 本机安装完成 → http://127.0.0.1:${AUDIO8_DEFAULT_PORT}`);
  return 0;
}

function uninstall(opts) {
  if (process.platform !== 'linux') {
    logger.error('audio8 uninstall 仅 Linux 支持');
    return 1;
  }
  try {
    execSync(`systemctl --now disable ${AUDIO8_SYSTEMD_NAME} 2>/dev/null; true`, { stdio: 'pipe', shell: '/bin/bash' });
    execSync(`systemctl stop ${AUDIO8_SYSTEMD_NAME} 2>/dev/null; true`, { stdio: 'pipe', shell: '/bin/bash' });
    execSync(`rm -f ${AUDIO8_SYSTEMD_PATH} && systemctl daemon-reload`, { stdio: 'pipe', shell: '/bin/bash' });
    execSync(`rm -rf ~/audio8 ~/audio8_venv ~/.audio8_venv`, { stdio: 'pipe', shell: '/bin/bash' });
    execSync(`rm -rf ~/.cache/huggingface/hub/models--Audio8*`, { stdio: 'pipe', shell: '/bin/bash' });
  } catch (e) {
    logger.warn('uninstall 清理部分出错: ' + e.message);
    return 1;
  }
  logger.ok('Audio8 TTS 已卸载');
  return 0;
}

async function status(opts) {
  opts = opts || {};
  const baseUrl = opts.url || process.env.ADOREMIX_AUDIO8_BASE_URL || `http://127.0.0.1:${AUDIO8_DEFAULT_PORT}`;
  try {
    const urlObj = new URL(`${baseUrl}/api/health`);
    const lib = urlObj.protocol === 'https:' ? require('https') : require('http');
    await new Promise(resolve => {
      const req = lib.request({ hostname: urlObj.hostname, port: urlObj.port, path: urlObj.pathname, method: 'GET', timeout: 5000 }, res => {
        if (res.statusCode === 200) {
          logger.ok(`Audio8 服务健康: ${baseUrl}/api/health 返回 ${res.statusCode}`);
          res.resume();
          resolve(0);
        } else {
          logger.warn(`Audio8 服务异常: ${baseUrl} 返回 ${res.statusCode}`);
          res.resume();
          resolve(1);
        }
      });
      req.on('error', err => { logger.warn(`Audio8 服务不可达: ${err.message}`); resolve(1); });
      req.on('timeout', () => { req.destroy(); logger.warn(`Audio8 服务超时: ${baseUrl}`); resolve(1); });
      req.end();
    });
    return 0;
  } catch (e) {
    logger.warn(`Audio8 status 检查失败: ${e.message}`);
    return 1;
  }
}

module.exports = { synthesize, checkDeps, VOICES, DEFAULT_BASE_URL, install, uninstall, status, fetchModel, downloadTo };

// === fetchModel: 单独下载 Audio8 TTS 模型 ===
// 源优先级:环境变量/参数指定 > hf-mirror.com(国内可达) > huggingface.co(官方,国内常被墙)
// 自托管:把 6 个文件传到自己服务器后 ADOREMIX_AUDIO8_MODEL_URL=https://your-host/xxx/ 或
//        adoremix audio8-fetch-model https://your-host/xxx/
const MODEL_DEFAULT_URLS = process.env.ADOREMIX_AUDIO8_MODEL_URL
  ? [process.env.ADOREMIX_AUDIO8_MODEL_URL]
  : [
      'https://hf-mirror.com/Audio8/audio8-TTS-0.1B-ONNX-INT8/resolve/main/',
      'https://huggingface.co/Audio8/audio8-TTS-0.1B-ONNX-INT8/resolve/main/'
    ];
// 模型文件清单（以仓库 runtime_manifest.json 为准,2026-10 核对）
// 核心运行文件 ~423MB;registration/ 子目录是声音克隆注册子模型(+396MB),基础 TTS 不需要
const MODEL_FILES = [
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
const MODEL_REGISTRATION_FILES = [
  'registration/registration_manifest.json',
  'registration/codec_encoder_fp16.onnx',
  'registration/codec_encoder_fp16.onnx.data'
];

// 下载单文件到 target。HF 风格 /resolve/ 会 301/302/307/308 跳 CDN,
// Node 的 http.get 不自动跟随重定向,必须手动跳(最多 5 跳)。
function downloadTo(url, target, file) {
  return new Promise((resolve, reject) => {
    const get = (u, hops) => {
      if (hops > 5) return reject(new Error(file + ' 重定向超过 5 跳'));
      const lib = u.startsWith('https:') ? https : http;
      const req = lib.get(u, response => {
        if ([301, 302, 303, 307, 308].indexOf(response.statusCode) >= 0) {
          const loc = response.headers.location;
          response.resume();
          if (!loc) return reject(new Error(file + ' 重定向缺少 Location'));
          return get(new URL(loc, u).href, hops + 1);
        }
        if (response.statusCode !== 200) {
          response.resume();
          return reject(new Error('HTTP ' + response.statusCode));
        }
        const total = parseInt(response.headers['content-length'] || '0', 10);
        const ws = fs.createWriteStream(target);
        let got = 0, lastLog = 0;
        response.on('data', c => {
          got += c.length;
          // 大文件(model.onnx.data ~572MB)每 100MB 报一次进度,避免长时间无输出像卡死
          if (got - lastLog >= 100 * 1024 * 1024) {
            lastLog = got;
            logger.log(`    ${file}: ${(got / 1048576).toFixed(0)}MB` + (total ? ` / ${(total / 1048576).toFixed(0)}MB` : ''));
          }
        });
        response.pipe(ws);
        ws.on('finish', () => ws.close(() => resolve({ file, got, total })));
        ws.on('error', reject);
      });
      req.on('error', reject);
      // 10 分钟超时:572MB 在 ≥1MB/s 的链路上够用
      req.setTimeout(600000, () => req.destroy(new Error(file + ' 超时(10min)')));
    };
    get(url, 0);
  });
}

// Audio8 没有预置音色库——每个音色都要注册(克隆)。但模型自带 reference_codes.npy +
// manifest.reference_text 就是官方默认参考音的原料,物化成 voices/default/ 即可直接合成。
// (VoiceStore.load 只认 voices/<name>/{codes.npy,meta.json},meta 只强依赖 reference_text)
function seedDefaultVoice(modelDir) {
  try {
    const voicesDefault = path.join(path.dirname(modelDir), 'voices', 'default');
    const metaPath = path.join(voicesDefault, 'meta.json');
    if (fs.existsSync(metaPath)) return true; // 已有默认音色
    const codesSrc = path.join(modelDir, 'reference_codes.npy');
    const manifestPath = path.join(modelDir, 'runtime_manifest.json');
    if (!fs.existsSync(codesSrc) || !fs.existsSync(manifestPath)) return false;
    const manifest = JSON.parse(fs.readFileSync(manifestPath, 'utf8'));
    if (!manifest.reference_text) return false;
    fs.mkdirSync(voicesDefault, { recursive: true });
    fs.copyFileSync(codesSrc, path.join(voicesDefault, 'codes.npy'));
    fs.writeFileSync(metaPath, JSON.stringify({
      name: 'default',
      reference_text: manifest.reference_text,
      dtype: 'int64',
      sample_rate: manifest.sample_rate || 44100,
      source: 'builtin'
    }), 'utf8');
    logger.ok('已生成默认音色 default（模型内置参考音）→ ' + voicesDefault);
    return true;
  } catch (e) {
    logger.warn('默认音色生成失败: ' + e.message);
    return false;
  }
}

async function fetchModel(opts) {
  opts = opts || {};
  // 目标目录必须与 systemd 单元一致(ARKTTS_MODEL_DIR=~/audio8/<runtime>/model)
  const targetDir = process.env.ADOREMIX_AUDIO8_MODEL_DIR
    || path.join(os.homedir(), 'audio8', AUDIO8_RUNTIME_DIR, 'model');
  const baseUrls = opts.url ? [opts.url] : MODEL_DEFAULT_URLS;
  // --registration / ADOREMIX_AUDIO8_WITH_REGISTRATION=1 时追加声音克隆注册子模型(+396MB)
  const files = (opts.registration || process.env.ADOREMIX_AUDIO8_WITH_REGISTRATION === '1')
    ? MODEL_FILES.concat(MODEL_REGISTRATION_FILES) : MODEL_FILES;

  logger.log('Audio8 模型下载 → ' + targetDir);
  fs.mkdirSync(targetDir, { recursive: true });

  let ok = 0, fail = 0;
  for (const f of files) {
    let done = false, lastErr = null;
    // 文件清单含子目录(如 tokenizer/tokenizer.json),先建父目录
    const target = path.join(targetDir, f);
    fs.mkdirSync(path.dirname(target), { recursive: true });
    for (const base of baseUrls) {
      try {
        logger.log(`  → ${f}（源 ${new URL(base).host}）`);
        const r = await downloadTo(base.replace(/\/+$/, '') + '/' + f, target, f);
        logger.log(`    ✓ ${f} 完成 ${(r.got / 1048576).toFixed(1)}MB`);
        done = true;
        break;
      } catch (e) {
        lastErr = e;
        logger.warn(`    ✗ 源 ${new URL(base).host} 失败: ${e.message}`);
      }
    }
    if (done) { ok++; }
    else {
      fail++;
      logger.error(`  ✗ ${f} 所有源均失败: ${lastErr ? lastErr.message : '未知错误'}`);
    }
  }
  if (fail > 0) {
    logger.error(`失败 ${fail} 个文件,模型不完整。可换源自试: adoremix audio8-fetch-model <url>/`);
    return 1;
  }
  logger.ok(`Audio8 模型就绪（${ok} 个文件）: ${targetDir}`);
  seedDefaultVoice(targetDir);
  logger.log('重启服务生效: systemctl restart audio8-tts');
  return 0;
}
