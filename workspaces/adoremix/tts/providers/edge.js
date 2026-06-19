'use strict';

/**
 * Edge TTS provider（免费）
 * 调用方式：python edge-tts 包 + ffmpeg 转 mp3
 * 凭证：不需要（免费）
 *
 * 依赖：python3 + pip install edge-tts + ffmpeg
 * 自动检测：adoremix tts deps
 */

const { execFileSync } = require('child_process');
const fs = require('fs');
const path = require('path');
const os = require('os');

// 短名 → edge-tts voice 全名
const VOICES = {
  xiaoxiao:   'zh-CN-XiaoxiaoNeural',
  yunxi:      'zh-CN-YunxiNeural',
  yunjian:    'zh-CN-YunjianNeural',
  xiaoyi:     'zh-CN-XiaoyiNeural',
  yunxia:     'zh-CN-YunxiaNeural',
  xiaochen:   'zh-CN-XiaochenNeural',
  xiaohan:    'zh-CN-XiaohanNeural',
  xiaomeng:   'zh-CN-XiaomengNeural',
  xiaomo:     'zh-CN-XiaomoNeural',
  xiaoqiu:    'zh-CN-XiaoqiuNeural',
  xiaorui:    'zh-CN-XiaoruiNeural',
  xiaoshuang: 'zh-CN-XiaoshuangNeural',
  xiaoxuan:   'zh-CN-XiaoxuanNeural',
  xiaoyan:    'zh-CN-XiaoyanNeural',
  xiaoyou:    'zh-CN-XiaoyouNeural',
  yunfeng:    'zh-CN-YunfengNeural',
  yunhao:     'zh-CN-YunhaoNeural',
  yunxiang:   'zh-CN-YunxiangNeural',
  yunyang:    'zh-CN-YunyangNeural'
};

function findPython() {
  for (const cmd of ['python3', 'python']) {
    try {
      execFileSync(cmd, ['--version'], { stdio: 'pipe' });
      return cmd;
    } catch (e) {}
  }
  return null;
}

function checkDeps() {
  const issues = [];
  const py = findPython();
  if (!py) {
    issues.push({ msg: '未找到 python3/python', fix: 'apt-get install -y python3 python3-pip' });
    return issues;
  }
  // 检查 edge-tts 包
  try {
    execFileSync(py, ['-c', 'import edge_tts'], { stdio: 'pipe' });
  } catch (e) {
    issues.push({ msg: 'python 缺 edge-tts 包', fix: 'pip3 install edge-tts' });
  }
  // 检查 ffmpeg
  try {
    execFileSync('ffmpeg', ['-version'], { stdio: 'pipe' });
  } catch (e) {
    issues.push({ msg: '未找到 ffmpeg', fix: 'apt-get install -y ffmpeg' });
  }
  return issues;
}

function synthesize({ text, voice, volume, speed, outFile }, creds) {
  return new Promise((resolve, reject) => {
    const issues = checkDeps();
    if (issues.length > 0) {
      return reject(new Error('edge-tts 依赖缺失:\n  ' + issues.map(i => i.msg + ' (修复: ' + i.fix + ')').join('\n  ')));
    }

    const py = findPython();
    const voiceId = VOICES[voice] || creds.edge_voice_override || 'zh-CN-XiaoxiaoNeural';

    // edge-tts rate/volume 是百分比字符串，如 "+50%" / "-20%"
    const sp = parseInt(speed) || 50;
    const vo = parseInt(volume) || 50;
    const rateStr = `${sp - 50 >= 0 ? '+' : ''}${sp - 50}%`;
    const volStr = `${vo - 50 >= 0 ? '+' : ''}${vo - 50}%`;

    // 1. edge-tts 生成 webm（临时文件）
    const tmpDir = os.tmpdir();
    const webmFile = path.join(tmpDir, `adoremix-edge-${Date.now()}.webm`);
    const txtFile = path.join(tmpDir, `adoremix-edge-${Date.now()}.txt`);
    fs.writeFileSync(txtFile, text);

    try {
      // 用 python -m edge_tts 调用（避免命令找不到）
      execFileSync(py, [
        '-m', 'edge_tts',
        '--voice', voiceId,
        '--rate', rateStr,
        '--volume', volStr,
        '-f', txtFile,
        '--write-media', webmFile
      ], { stdio: 'pipe' });

      if (!fs.existsSync(webmFile)) {
        throw new Error('edge-tts 未生成音频');
      }

      // 2. ffmpeg 转 mp3
      execFileSync('ffmpeg', [
        '-y', '-i', webmFile,
        '-acodec', 'libmp3lame',
        '-ab', '128k',
        '-ar', '22050',
        outFile
      ], { stdio: 'pipe' });

      // 3. 清理临时
      try { fs.unlinkSync(webmFile); fs.unlinkSync(txtFile); } catch (e) {}

      resolve({ outFile, provider: 'edge', voice: voiceId });
    } catch (e) {
      try { fs.unlinkSync(webmFile); fs.unlinkSync(txtFile); } catch (_) {}
      reject(new Error('edge-tts 失败: ' + e.message));
    }
  });
}

module.exports = {
  name: 'edge',
  description: 'Microsoft Edge TTS（免费，需 python3 + edge-tts + ffmpeg）',
  voices: VOICES,
  requiredCreds: [],
  checkDeps,
  synthesize
};
