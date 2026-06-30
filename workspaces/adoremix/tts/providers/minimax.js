'use strict';

/**
 * MiniMax TTS provider
 * 调用方式：HTTP POST https://api.minimaxi.com/v1/t2a_v2
 * 凭证：API token（包月几十元）
 * 返回：JSON 里 data.audio 是 hex 编码的 mp3
 *
 * 不依赖 python，纯 Node 实现。
 */

const https = require('https');
const fs = require('fs');

const API_URL = 'https://api.minimaxi.com/v1/t2a_v2';

// 短名 → minimax voice_id（基于 demo 提供的映射表）
const VOICES = {
  xiaoxiao:   'female-tianmei',
  yunxi:      'male-qn-jingying',
  yunjian:    'male-qn-jingying',
  xiaoyi:     'female-shaonv',
  yunxia:     'female-shaonv',
  xiaochen:   'female-chengshu',
  xiaohan:    'female-yujie',
  xiaomeng:   'female-shaonv',
  xiaomo:     'female-chengshu',
  xiaoqiu:    'female-tianmei-jingpin',
  xiaorui:    'female-shaonv-jingpin',
  xiaoshuang: 'female-yujie-jingpin',
  xiaoxuan:   'female-chengshu-jingpin',
  xiaoyan:    'female-sharon',
  xiaoyou:    'female-shaonv',
  yunfeng:    'male-qn-badao',
  yunhao:     'male-qn-badao',
  yunxiang:   'male-qn-jingying',
  yunyang:    'male-qn-qingse',
  // 讯飞原生发音人（Qt/WebUI 实际传）→ 就近映射到 minimax voice_id
  aisjiuxu:   'male-qn-jingying',    // 许久（男）
  aisxping:   'female-tianmei',      // 小萍（女）
  aisjinger:  'female-shaonv',       // 小婧（女）
  // minimax 自有音色（直接透传）
  'male-qn-qingse': 'male-qn-qingse',
  'male-qn-daxuesheng': 'male-qn-daxuesheng',
  'male-qn-badao': 'male-qn-badao',
  'female-shaonv': 'female-shaonv',
  'female-yujie': 'female-yujie',
  'female-chengshu': 'female-chengshu',
  'female-tianmei': 'female-tianmei',
  'female-sharon': 'female-sharon'
};

function synthesize({ text, voice, volume, speed, outFile }, creds) {
  return new Promise((resolve, reject) => {
    const token = creds.minimax_token;
    if (!token) return reject(new Error('MiniMax TTS 缺凭证：minimax_token'));

    const voiceId = VOICES[voice] || 'female-tianmei';

    // volume/speed 在 0-100 范围，minimax 用 0-2 范围的 speed，0-100 的 vol
    const speedNorm = Math.max(0.5, Math.min(2, (parseInt(speed) || 50) / 50));
    const volNorm = parseInt(volume) || 50;

    const body = JSON.stringify({
      model: 'speech-2.8-hd',
      text,
      stream: false,
      voice_setting: {
        voice_id: voiceId,
        speed: speedNorm,
        vol: volNorm,
        pitch: 0,
        emotion: 'happy'
      },
      audio_setting: {
        sample_rate: 32000,
        bitrate: 128000,
        format: 'mp3',
        channel: 1
      },
      subtitle_enable: false
    });

    const url = new URL(API_URL);
    const req = https.request({
      hostname: url.hostname,
      path: url.pathname,
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${token}`,
        'Content-Type': 'application/json',
        'Content-Length': Buffer.byteLength(body)
      }
    }, (res) => {
      let data = '';
      res.on('data', (c) => data += c);
      res.on('end', () => {
        let result;
        try { result = JSON.parse(data); }
        catch (e) { return reject(new Error('MiniMax 返回非 JSON: ' + data.slice(0, 200))); }
        if (result.base_resp && result.base_resp.status_code !== 0) {
          return reject(new Error('MiniMax API 错误: ' + result.base_resp.status_msg));
        }
        const audioHex = result.data && result.data.audio;
        if (!audioHex) return reject(new Error('MiniMax 返回无 audio 字段'));
        try {
          const audioData = Buffer.from(audioHex, 'hex');
          fs.writeFileSync(outFile, audioData);
          resolve({ outFile, provider: 'minimax', voice: voiceId });
        } catch (e) {
          reject(new Error('写入 mp3 失败: ' + e.message));
        }
      });
    });

    req.on('error', (e) => reject(new Error('MiniMax 网络错误: ' + e.message)));
    req.write(body);
    req.end();
  });
}

module.exports = {
  name: 'minimax',
  description: 'MiniMax TTS（HTTP API，包月几十元）',
  voices: VOICES,
  requiredCreds: ['minimax_token'],
  synthesize
};
