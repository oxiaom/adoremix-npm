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
// 注意：edge-tts 的 zh-CN voice 实际只有 8 个（--list-voices 确认）：
//   女声 XiaoxiaoNeural(晓晓) XiaoyiNeural(晓伊)
//   男声 YunxiNeural(云希) YunjianNeural(云健) YunxiaNeural(云夏) YunyangNeural(云扬)
//   方言 liaoning-XiaobeiNeural shaanxi-XiaoniNeural
// 讯飞/Qt 传的很多短名在 edge 无对应，就近映射到同性别有效 voice；
// synthesize 另有 fallback 兜底（voice 调用失败回落 XiaoxiaoNeural）。
const VOICES = {
  // 直接对应
  xiaoxiao:   'zh-CN-XiaoxiaoNeural',
  xiaoyi:     'zh-CN-XiaoyiNeural',
  yunxi:      'zh-CN-YunxiNeural',
  yunjian:    'zh-CN-YunjianNeural',
  yunxia:     'zh-CN-YunxiaNeural',
  yunyang:    'zh-CN-YunyangNeural',
  // edge 无对应，就近映射（女声→晓晓/晓伊，男声→云希/云健）
  xiaoyan:    'zh-CN-XiaoxiaoNeural',
  xiaochen:   'zh-CN-XiaoxiaoNeural',
  xiaohan:    'zh-CN-XiaoxiaoNeural',
  xiaomeng:   'zh-CN-XiaoyiNeural',
  xiaomo:     'zh-CN-XiaoyiNeural',
  xiaoqiu:    'zh-CN-XiaoxiaoNeural',
  xiaorui:    'zh-CN-XiaoxiaoNeural',
  xiaoshuang: 'zh-CN-XiaoyiNeural',
  xiaoxuan:   'zh-CN-XiaoxiaoNeural',
  xiaoyou:    'zh-CN-XiaoyiNeural',
  yunfeng:    'zh-CN-YunxiNeural',
  yunhao:     'zh-CN-YunxiNeural',
  yunxiang:   'zh-CN-YunjianNeural',
  // 讯飞原生发音人（Qt/WebUI 可能直接传讯飞名 aisxxx）→ 就近映射到 edge 有效 voice
  aisjiuxu:   'zh-CN-YunxiNeural',   // 许久（男）→ 云希
  aisbabyxu:  'zh-CN-YunxiaNeural',  // 男童 → 云夏
  aisxuxin:   'zh-CN-YunxiNeural'    // 晓旭（男）→ 云希
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
    const DEFAULT_VOICE = 'zh-CN-XiaoxiaoNeural';
    const wantedVoice = VOICES[voice] || creds.edge_voice_override || DEFAULT_VOICE;

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

    // 跑一次 edge-tts（指定 voice），voice 无效/网络抖动时回落默认 voice 重试
    function runEdge(voiceId) {
      execFileSync(py, [
        '-m', 'edge_tts',
        '--voice', voiceId,
        '--rate', rateStr,
        '--volume', volStr,
        '-f', txtFile,
        '--write-media', webmFile
      ], { stdio: 'pipe' });
      if (!fs.existsSync(webmFile) || fs.statSync(webmFile).size === 0) {
        throw new Error('edge-tts 未生成音频（voice 可能无效或网络问题）');
      }
    }

    let usedVoice = wantedVoice;
    try {
      try {
        runEdge(wantedVoice);
      } catch (e) {
        // voice 在 edge-tts 不存在（微软列表动态变化）或网络抖动 → 回落默认 voice 重试一次
        if (wantedVoice !== DEFAULT_VOICE) {
          usedVoice = DEFAULT_VOICE;
          runEdge(DEFAULT_VOICE);
        } else {
          throw e;
        }
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

      resolve({ outFile, provider: 'edge', voice: usedVoice });
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
