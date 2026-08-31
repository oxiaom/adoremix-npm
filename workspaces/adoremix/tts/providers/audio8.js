'use strict';

/**
 * Audio8 TTS provider
 * 调用方式：HTTP 调用本地 Audio8 TTS 服务（OpenAI 兼容 /v1/audio/speech）
 * 支持流式 MP3 输出（设备边收边播，匹配现有 quemp3 推送管道）
 *
 * 服务部署参考（Audio8-AI/Audio8_TTS）：
 *   pip install audio8-tts（或依官方文档）
 *   python -m audio8_tts.server  # 默认监听 http://0.0.0.0:7860
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

const DEFAULT_BASE_URL = 'http://127.0.0.1:7860';
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
      return reject(new Error(`Audio8 服务地址无效: ${baseUrl}（请在 config.ini [TTS] audio8_base_url 配置，例 http://127.0.0.1:7860）`));
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

module.exports = { synthesize, checkDeps, VOICES, DEFAULT_BASE_URL };
