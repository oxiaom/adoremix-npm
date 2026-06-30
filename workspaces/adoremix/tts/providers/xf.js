'use strict';

/**
 * 讯飞 TTS provider
 * 调用方式：WebSocket wss://tts-api.xfyun.cn/v2/tts
 * 凭证：appid + apiSecret + apiKey（一年 4000 元）
 * 返回：直接 mp3 流（不需要 lame 转码）
 */

const CryptoJS = require('crypto-js');
const WebSocket = require('ws');
const fs = require('fs');

// 讯飞 vcn（voice name）跟标准短名 1:1 映射（讯飞有自己的 vcn 名）
// 这里用标准短名直接传给讯飞（讯飞接受任意 vcn，无效会用默认）
// 如果用户的讯飞账号有自定义 vcn，可以在 config.ini 配 xf_voice_override
const VOICES = {
  xiaoxiao: 'xiaoxiao', yunxi: 'yunxi', yunjian: 'yunjian',
  xiaoyi: 'xiaoyi', yunxia: 'yunxia', xiaochen: 'xiaochen',
  xiaohan: 'xiaohan', xiaomeng: 'xiaomeng', xiaomo: 'xiaomo',
  xiaoqiu: 'xiaoqiu', xiaorui: 'xiaorui', xiaoshuang: 'xiaoshuang',
  xiaoxuan: 'xiaoxuan', xiaoyan: 'xiaoyan', xiaoyou: 'xiaoyou',
  yunfeng: 'yunfeng', yunhao: 'yunhao', yunxiang: 'yunxiang', yunyang: 'yunyang',
  // 讯飞原生发音人（WebUI 实际传，讯飞 API 直接认，自身透传）
  aisjiuxu: 'aisjiuxu', aisxping: 'aisxping', aisjinger: 'aisjinger'
};

function synthesize({ text, voice, volume, speed, outFile }, creds) {
  return new Promise((resolve, reject) => {
    const appid = creds.xf_appid;
    const apiSecret = creds.xf_apiSecret;
    const apiKey = creds.xf_apiKey;
    if (!appid || !apiSecret || !apiKey) {
      return reject(new Error('讯飞 TTS 缺凭证：xf_appid / xf_apiSecret / xf_apiKey'));
    }

    // 标准短名走 VOICES 映射；讯飞原生 vcn(如 aisjiuxu 许久)直接透传（讯飞接受任意 vcn）
    const vcn = VOICES[voice] || voice || creds.xf_voice_override || 'xiaoxiao';
    const host = 'tts-api.xfyun.cn';
    const hostUrl = `wss://${host}/v2/tts`;

    const date = new Date().toUTCString();
    const signatureOrigin = `host: ${host}\ndate: ${date}\nGET /v2/tts HTTP/1.1`;
    const signatureSha = CryptoJS.HmacSHA256(signatureOrigin, apiSecret);
    const signature = CryptoJS.enc.Base64.stringify(signatureSha);
    const authorizationOrigin = `api_key="${apiKey}", algorithm="hmac-sha256", headers="host date request-line", signature="${signature}"`;
    const authStr = CryptoJS.enc.Base64.stringify(CryptoJS.enc.Utf8.parse(authorizationOrigin));
    const wssUrl = `${hostUrl}?authorization=${authStr}&date=${date}&host=${host}`;

    const ws = new WebSocket(wssUrl);
    let receivedAny = false;

    ws.on('open', () => {
      const frame = {
        common: { app_id: appid },
        business: {
          aue: 'lame', sfl: 1,
          volume: parseInt(volume) || 50,
          speed: parseInt(speed) || 50,
          vcn, tte: 'UTF8'
        },
        data: { text: Buffer.from(text).toString('base64'), status: 2 }
      };
      ws.send(JSON.stringify(frame));
      if (fs.existsSync(outFile)) fs.unlinkSync(outFile);
    });

    ws.on('message', (data) => {
      let res;
      try { res = JSON.parse(data); } catch (e) { return; }
      if (res.code !== 0) {
        ws.close();
        reject(new Error(`讯飞错误 ${res.code}: ${res.message}`));
        return;
      }
      const audioBuf = Buffer.from(res.data.audio, 'base64');
      fs.appendFileSync(outFile, audioBuf);
      receivedAny = true;
      if (res.data.status === 2) {
        ws.close();
      }
    });

    ws.on('close', () => {
      if (!receivedAny) return reject(new Error('讯飞未返回音频'));
      resolve({ outFile, provider: 'xf', voice: vcn });
    });

    ws.on('error', (err) => reject(new Error('讯飞 WebSocket 错误: ' + err.message)));
  });
}

module.exports = {
  name: 'xf',
  description: '讯飞在线 TTS（WebSocket，年费约 4000 元）',
  voices: VOICES,
  requiredCreds: ['xf_appid', 'xf_apiSecret', 'xf_apiKey'],
  synthesize
};
