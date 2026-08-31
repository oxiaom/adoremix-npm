'use strict';

/**
 * Audio8 TTS provider
 * 调用方式：HTTP 调用本地 Audio8 TTS 服务（OpenAI 兼容 /v1/audio/speech）
 * 支持流式 MP3 输出（设备边收边播，匹配现有 quemp3 推送管道）
 *
 * 服务部署参考（Audio8-AI/Audio8_TTS）：
 *   git clone https://github.com/Audio8-AI/Audio8_TTS.git ~/audio8
 *   cd ~/audio8/onnx_runtime && python3 -m venv .venv && . .venv/bin/activate
 *   pip install -r requirements.txt    # torch/transformers/onnxruntime 等
 *   bash start_server.sh               # 默认监听 http://0.0.0.0:8024
 *   首次启动自动从 HuggingFace 下载 ~572MB 模型(0.1B-INT8)
 *
 * 凭证：不需要 API Key（本地服务）
 * 依赖：lame（mp3 转码），ffmpeg（HTTP 流 → mp3）
 *
 * 速度支持：x-speed 头（0.5~2.0，1.0=正常；2.0=2x 加速）
 * 声音克隆：3~10 秒参考音频，但需在 Audio8 服务端预设（请求时用 voice 参数指定）
 */

const { execFileSync, execSync } = require('child_process');
const fs = require('fs');
const path = require('path');
const os = require('os');
const https = require('https');
const http = require('http');
const { URL } = require('url');
const logger = require('../../src/logger');

// 中文常用 voice（Audio8 的 zh-CN voices，按性别分组）
const VOICES = {
  // 女声
  xiaoxiao:  'zh-CN-XiaoxiaoNeural',    // 晓晓（温柔女声）
  xiaoyi:    'zh-CN-XiaoyiNeural',      // 晓伊（活力女声）
  xiaomo:    'zh-CN-XiaomoNeural',      // 晓墨（文艺女声）
  xiaoxuan:  'zh-CN-XiaoxuanNeural',    // 晓萱（新闻女声）
  // 男声
  yunxi:     'zh-CN-YunxiNeural',       // 云希（青年男声）
  yunjian:   'zh-CN-YunjianNeural',     // 云健（浑厚男声）
  yunyang:   'zh-CN-YunyangNeural',     // 云扬（播音男声）
  // 默认
  default:   'zh-CN-XiaoxiaoNeural'
};

const DEFAULT_BASE_URL = 'http://127.0.0.1:8024';
const DEFAULT_TIMEOUT_MS = 30000;

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

function synthesize({ text, voice, volume, speed, outFile }, creds) {
  return new Promise((resolve, reject) => {
    const issues = checkDeps();
    if (issues.length > 0) {
      return reject(new Error('Audio8 依赖缺失:\n  ' + issues.map(i => i.msg + ' (修复: ' + i.fix + ')').join('\n  ')));
    }

    const baseUrl = (creds && creds.audio8_base_url) || DEFAULT_BASE_URL;
    const wantedVoice = VOICES[voice] || VOICES.default;
    // 音量：Audio8 用 dB 偏移（-6~6 dB），UI 传的是 0~100 百分比，转 dB
    const vo = parseInt(volume) || 50;
    const volumeDb = Math.round((vo - 50) * 0.12);
    // 速度：Audio8 用 0.5~2.0 倍速，UI 传 0~100 转 0.5~2.0
    const sp = parseInt(speed) || 50;
    const speedMul = 0.5 + (sp / 100) * 1.5;

    // OpenAI 兼容调用：POST /v1/audio/speech，body=json，response=audio/mpeg 流
    let urlObj;
    try { urlObj = new URL(baseUrl); } catch (e) {
      return reject(new Error(`Audio8 服务地址无效: ${baseUrl}（请在 config.ini [TTS] audio8_base_url 配置，例 http://127.0.0.1:8024）`));
    }
    urlObj.pathname = '/v1/audio/speech';
    const postData = JSON.stringify({
      input: text,
      voice: wantedVoice,
      model: 'audio8-tts',
      response_format: 'mp3',
      speed: speedMul,
      volume: volumeDb
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
      // 流式保存
      streamToFile(res, outFile)
        .then(bytes => resolve({ bytes }))
        .catch(reject);
    });
    req.on('error', err => {
      reject(new Error(`Audio8 连接失败（${baseUrl}）: ${err.message}。请确认 Audio8 TTS 服务已启动，且 config.ini [TTS] audio8_base_url 配置正确。`));
    });
    req.on('timeout', () => {
      req.destroy();
      reject(new Error(`Audio8 请求超时（${DEFAULT_TIMEOUT_MS / 1000}s）。服务可能在转码长文本。`));
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
const AUDIO8_VENV_DIR = '~/audio8/onnx_runtime/.venv';
const AUDIO8_REQUIREMENTS = 'onnx_runtime/requirements.txt';
const AUDIO8_SYSTEMD_NAME = 'audio8-tts';
const AUDIO8_SYSTEMD_PATH = '/etc/systemd/system/audio8-tts.service';
const AUDIO8_HEALTH_URL = `http://127.0.0.1:${AUDIO8_DEFAULT_PORT}/v1/models`;
// 自托管的预下载模型（可选，存到 ~/audio8_models/0.1B/ 下，避免每次 git clone 后再下 572MB）
const AUDIO8_MODEL_DIR = '~/audio8_models/audio8-TTS-0.1B-ONNX-INT8';

// 包管理器嗅探（apt/dnf/yum/apk/pacman）
// 用 which 而非 command -v（Debian/Ubuntu 12+ 的 /bin/sh 没有 command 内建，且 PATH 不一定对）
function detectPkgMgr() {
  function exists(cmd) {
    try {
      const out = execSync('/bin/sh -c "which ' + cmd + ' 2>/dev/null || echo NOT_FOUND"', { encoding: 'utf8' });
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
  return `[Unit]
Description=Audio8 TTS (AdoreMix)
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=${AUDIO8_DEPLOY_DIR}/onnx_runtime
Environment=PATH=${AUDIO8_VENV_DIR}/bin:/usr/bin:/bin
ExecStart=${AUDIO8_VENV_DIR}/bin/python -m arktts_runtime.service --model-dir ./model --voices-dir ./model/voices --port ${AUDIO8_DEFAULT_PORT}
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

  // 检查 config.ini 是否有预托管模型（audio8_model_dir）
  let modelDir = '';
  try {
    const cfg = require(path.join(__dirname, '..', 'src', 'config'));
    const wd = opts.workdir || process.env.ADOREMIX_WORKDIR || path.join(os.homedir(), '.local', 'share', 'adoremix');
    modelDir = cfg.getConfigValue(wd, 'TTS.audio8_model_dir') || '';
  } catch (e) {}
  const modelLink = `~/audio8/onnx_runtime/model`;  // Audio8 期望的相对路径
  // 如果有预托管模型目录，建软链指向
  if (modelDir) {
    try {
      logger.log('=== 链接预托管模型 ' + modelDir + ' → ' + modelLink + ' ===');
      execSync(`mkdir -p $(dirname ${modelLink}) && rm -rf ${modelLink} && ln -s ${modelDir} ${modelLink}`, { stdio: 'inherit', shell: '/bin/bash' });
    } catch (e) {
      logger.warn('链接模型失败: ' + e.message);
    }
  }

  // git clone
  try {
    logger.log('=== 克隆 Audio8_TTS 仓库 ===');
    execSync(`mkdir -p ~/audio8 && if [ ! -d ~/audio8/.git ]; then git clone ${AUDIO8_REPO} ~/audio8_temp && mv ~/audio8_temp/* ~/audio8_temp/.[!.]* ~/audio8/ 2>/dev/null; rm -rf ~/audio8_temp; else cd ~/audio8 && git pull; fi`, { stdio: 'inherit', shell: '/bin/bash' });
  } catch (e) {
    logger.error('克隆失败: ' + e.message.slice(0, 200));
    return 1;
  }

  // venv + pip install
  try {
    logger.log('=== 创建 venv 并安装 Python 依赖（首次需 5-10 分钟下载 torch 等）===');
    execSync('python3 -m venv ~/.audio8_venv', { stdio: 'inherit', shell: '/bin/bash' });
    execSync('source ~/.audio8_venv/bin/activate && pip install -U pip --quiet && pip install -r ~/audio8/onnx_runtime/requirements.txt --quiet', { stdio: 'inherit', shell: '/bin/bash' });
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

  // 等服务健康（含下载 572MB 模型，冷启动最多 60s）
  logger.log('=== 等待服务健康（首次启动要下载 ~572MB 模型，最多 60 秒）===');
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
    logger.warn('60 秒内未就绪，请手动 systemctl status ' + AUDIO8_SYSTEMD_NAME);
    logger.log('也可直接前台启动测试: source ~/.audio8_venv/bin/activate && python -m arktts_runtime.service --model-dir ~/audio8/model --voices-dir ~/audio8/model/voices --port ' + AUDIO8_DEFAULT_PORT);
  }

  // 改本地 config.ini
  try {
    const cfg = require(path.join(__dirname, '..', 'src', 'config'));
    const wd = opts.workdir || process.env.ADOREMIX_WORKDIR || path.join(os.homedir(), '.local', 'share', 'adoremix');
    cfg.setConfigValue(wd, 'TTS.provider', 'audio8');
    cfg.setConfigValue(wd, 'TTS.audio8_base_url', `http://127.0.0.1:${AUDIO8_DEFAULT_PORT}`);
    logger.ok(`config.ini 已更新: provider=audio8, audio8_base_url=http://127.0.0.1:${AUDIO8_DEFAULT_PORT}`);
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
    execSync(`rm -rf ~/audio8 ~/audio8_venv`, { stdio: 'pipe', shell: '/bin/bash' });
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
    const urlObj = new URL(`${baseUrl}/v1/models`);
    const lib = urlObj.protocol === 'https:' ? require('https') : require('http');
    await new Promise(resolve => {
      const req = lib.request({ hostname: urlObj.hostname, port: urlObj.port, path: urlObj.pathname, method: 'GET', timeout: 5000 }, res => {
        if (res.statusCode === 200) {
          logger.ok(`Audio8 服务健康: ${baseUrl}/v1/models 返回 ${res.statusCode}`);
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

module.exports = { synthesize, checkDeps, VOICES, DEFAULT_BASE_URL, install, uninstall, status };
