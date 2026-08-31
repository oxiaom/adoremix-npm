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

const { execFileSync } = require('child_process');
const fs = require('fs');
const path = require('path');
const os = require('os');
const https = require('https');
const http = require('http');
const { URL } = require('url');

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
// 通过 SSH 远程部署到 Linux 主机，Windows 本机调用只需装 plink。
// 默认目标：192.168.1.114:22 / 用户 oxiaom。改 SSH_TARGET/SSH_USER 环境变量或 --host/--user 参数即可换机器。
const AUDIO8_DEFAULT_PORT = 8024;
const AUDIO8_REPO = 'https://github.com/Audio8-AI/Audio8_TTS.git';
const AUDIO8_DEPLOY_DIR = '~/audio8';
const AUDIO8_VENV_DIR = '~/audio8/onnx_runtime/.venv';
const AUDIO8_REQUIREMENTS = 'onnx_runtime/requirements.txt';
const AUDIO8_SYSTEMD_NAME = 'audio8-tts';
const AUDIO8_SYSTEMD_PATH = '/etc/systemd/system/audio8-tts.service';
const AUDIO8_HEALTH_URL = `http://127.0.0.1:${AUDIO8_DEFAULT_PORT}/v1/models`;

function plink() {
  for (const cmd of ['plink', '"C:\\Program Files\\PuTTY\\plink.exe"']) {
    try { return execSync(cmd.replace(/"/g, '').split(' ')[0], { stdio: 'pipe' }); } catch (e) {}
  }
  try { return require('child_process').execSync('where plink', { encoding: 'utf8', stdio: ['pipe', 'pipe', 'pipe'] }).trim().split('\n')[0]; } catch (e) {}
  return null;
}

function sshExec(cmd, opts) {
  opts = opts || {};
  const host = opts.host || process.env.ADOREMIX_AUDIO8_SSH_HOST || '192.168.1.114';
  const user = opts.user || process.env.ADOREMIX_AUDIO8_SSH_USER || 'oxiaom';
  const pass = opts.pass || process.env.ADOREMIX_AUDIO8_SSH_PASS || '123123';
  const pl = plink();
  if (!pl) throw new Error('未找到 plink（PuTTY），请安装 PuTTY 或将其加入 PATH');
  return execSync(`"${pl}" -ssh -batch -pw "${pass}" ${user}@${host} '${cmd.replace(/'/g, "'\\''")}'`, { stdio: 'pipe', encoding: 'utf8' });
}

function buildSystemdUnit(pyCmd) {
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
  logger.ok('开始远程安装 Audio8 TTS（目标: ' + (opts.host || '192.168.1.114') + '）');
  const cmds = [
    'echo "=== 系统检测 ==="',
    'python3 --version',
    'pip3 --version',
    'git --version',
    'echo "=== 安装系统依赖 ==="',
    'apt-get update && apt-get install -y git python3-pip python3-venv ffmpeg',
    'echo "=== clone 仓库（如果不存在）==="',
    `if [ ! -d ${AUDIO8_DEPLOY_DIR} ]; then git clone ${AUDIO8_REPO} ${AUDIO8_DEPLOY_DIR}; else echo "已存在,跳过"; fi`,
    'echo "=== 创建 venv 并装依赖 ==="',
    `cd ${AUDIO8_DEPLOY_DIR}/onnx_runtime && python3 -m venv .venv`,
    `${AUDIO8_VENV_DIR}/bin/pip install -U pip`,
    `${AUDIO8_VENV_DIR}/bin/pip install -r ${AUDIO8_REQUIREMENTS}`,
    'echo "=== 写 systemd 单元 ==="',
    // systemd 单元写入使用 heredoc 转义（这里通过 echo + 重定向）
    `bash -c 'cat > ${AUDIO8_SYSTEMD_PATH} <<\"EOF\"\n${buildSystemdUnit()}\nEOF'`,
    'systemctl daemon-reload',
    `systemctl enable ${AUDIO8_SYSTEMD_NAME}`,
    `systemctl restart ${AUDIO8_SYSTEMD_NAME}`,
    'echo "=== 等待服务健康（首次启动要下载 ~572MB 模型,最多 60s）==="',
    `for i in $(seq 1 60); do sleep 2; if curl -sf ${AUDIO8_HEALTH_URL} >/dev/null 2>&1; then echo "OK after ${i} attempts"; break; fi; done`,
    `curl -sf ${AUDIO8_HEALTH_URL} >/dev/null && echo "✓ Audio8 服务健康: http://127.0.0.1:${AUDIO8_DEFAULT_PORT}" || echo "⚠ 60s 内未就绪,可手动 systemctl status ${AUDIO8_SYSTEMD_NAME}"`
  ];
  const fullCmd = cmds.join(' && ');
  try {
    const out = sshExec(fullCmd, opts);
    process.stdout.write(out);
  } catch (e) {
    logger.error('SSH 执行失败:' + e.message.slice(0, 200));
    return 1;
  }
  // 修改本地 config.ini 的 [TTS] provider/base_url
  try {
    const cfg = require(path.join(__dirname, '..', 'src', 'config'));
    const localHost = opts.host || '192.168.1.114';
    cfg.setConfigValue(opts.workdir || path.join(os.homedir(), '.local', 'share', 'adoremix'), 'TTS.provider', 'audio8');
    cfg.setConfigValue(opts.workdir || path.join(os.homedir(), '.local', 'share', 'adoremix'), 'TTS.audio8_base_url', `http://${localHost}:${AUDIO8_DEFAULT_PORT}`);
    logger.ok(`本地 config.ini 已更新: provider=audio8, audio8_base_url=http://${localHost}:${AUDIO8_DEFAULT_PORT}`);
  } catch (e) {
    logger.warn('本地 config.ini 更新失败（可手动设置）:' + e.message.slice(0, 100));
  }
  logger.ok('Audio8 TTS 远程安装完成');
  logger.log(`访问: http://${opts.host || '192.168.1.114'}:${AUDIO8_DEFAULT_PORT}/docs`);
  return 0;
}

function uninstall(opts) {
  opts = opts || {};
  logger.ok('开始远程卸载 Audio8 TTS');
  const cmds = [
    `systemctl --now disable ${AUDIO8_SYSTEMD_NAME} 2>/dev/null; true`,
    `systemctl stop ${AUDIO8_SYSTEMD_NAME} 2>/dev/null; true`,
    `rm -f ${AUDIO8_SYSTEMD_PATH}`,
    'systemctl daemon-reload',
    `rm -rf ${AUDIO8_DEPLOY_DIR}`,
    `rm -rf ~/.cache/huggingface/hub/models--Audio8*`
  ];
  try {
    const out = sshExec(cmds.join(' && '), opts);
    process.stdout.write(out);
  } catch (e) {
    logger.error('SSH 执行失败:' + e.message.slice(0, 200));
    return 1;
  }
  logger.ok('Audio8 TTS 远程卸载完成');
  return 0;
}

async function status(opts) {
  opts = opts || {};
  const baseUrl = (opts.url || process.env.ADOREMIX_AUDIO8_BASE_URL || `http://${opts.host || '192.168.1.114'}:${AUDIO8_DEFAULT_PORT}`);
  const urlObj = new URL(`${baseUrl}/v1/models`);
  const lib = urlObj.protocol === 'https:' ? require('https') : http;
  return new Promise(resolve => {
    const req = lib.request({ hostname: urlObj.hostname, port: urlObj.port, path: urlObj.pathname, method: 'GET', timeout: 5000 }, res => {
      if (res.statusCode === 200) {
        logger.ok(`Audio8 服务健康: ${baseUrl}/v1/models 返回 ${res.statusCode}`);
        resolve(0);
      } else {
        logger.warn(`Audio8 服务异常: ${baseUrl} 返回 ${res.statusCode}`);
        resolve(1);
      }
    });
    req.on('error', err => { logger.warn(`Audio8 服务不可达: ${err.message}`); resolve(1); });
    req.on('timeout', () => { req.destroy(); logger.warn(`Audio8 服务超时: ${baseUrl}`); resolve(1); });
    req.end();
  });
}

module.exports = { synthesize, checkDeps, VOICES, DEFAULT_BASE_URL, install, uninstall, status };
