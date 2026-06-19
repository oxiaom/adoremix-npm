#!/usr/bin/env node
'use strict';

/**
 * AdoreMix TTS dispatcher
 *
 * Qt/C++ 调用方式（不变）：
 *   node tts.js <volume> <speed> <voice_short> <mp3_out> <txt_path> [appid] [apiSecret] [apiKey]
 *
 * 根据 config.ini [TTS].provider 调用对应实现：
 *   - xf:     讯飞 WebSocket（原 tts.js 逻辑，需 appid/apiSecret/apiKey）
 *   - minimax: MiniMax HTTP API（需 token）
 *   - edge:   python edge-tts（免费，需 python3 + ffmpeg）
 *
 * 凭证优先从 config.ini 读，命令行 appid/apiSecret/apiKey 兼容旧调用（仅 xf）。
 */

const fs = require('fs');
const path = require('path');
const ini = require('ini');

const PROVIDERS = {
  xf: require('./providers/xf'),
  minimax: require('./providers/minimax'),
  edge: require('./providers/edge')
};

function log(...args) { console.log('[tts]', ...args); }
function err(...args) { console.error('[tts ERR]', ...args); }

async function main() {
  const arg = process.argv.slice(2);
  if (arg.length < 5) {
    err('用法: node tts.js <volume> <speed> <voice> <mp3_out> <txt_path> [appid] [apiSecret] [apiKey]');
    process.exit(1);
  }

  const [volume, speed, voice, mp3Name, txtPath, appidArg, apiSecretArg, apiKeyArg] = arg;

  // 读文本（Qt 写的 utf-8 文本）
  let text;
  try { text = fs.readFileSync(txtPath, 'utf-8'); }
  catch (e) { err(`读文本失败: ${txtPath} - ${e.message}`); process.exit(2); }

  // 读 config.ini 找 provider
  const cfgPath = path.join(process.cwd(), 'config.ini');
  let ttsSection = {};
  if (fs.existsSync(cfgPath)) {
    try {
      const cfg = ini.parse(fs.readFileSync(cfgPath, 'utf-8'));
      ttsSection = cfg.TTS || {};
    } catch (e) { err(`config.ini 解析失败: ${e.message}`); }
  }
  const providerName = (ttsSection.provider || 'xf').toLowerCase();
  const provider = PROVIDERS[providerName];
  if (!provider) {
    err(`未知 provider: ${providerName}（可选: xf / minimax / edge）`);
    process.exit(3);
  }

  // 输出路径（Qt 传的是文件名，实际写到 ./tty/ 下）
  const ttyDir = path.join(process.cwd(), 'tty');
  if (!fs.existsSync(ttyDir)) fs.mkdirSync(ttyDir, { recursive: true });
  const outFile = path.join(ttyDir, mp3Name);

  // 凭证：优先 config.ini，命令行参数兼容旧版 xf
  const creds = {
    xf_appid: ttsSection.xf_appid || appidArg || '',
    xf_apiSecret: ttsSection.xf_apiSecret || apiSecretArg || '',
    xf_apiKey: ttsSection.xf_apiKey || apiKeyArg || '',
    xf_voice_override: ttsSection.xf_voice_override || '',
    minimax_token: ttsSection.minimax_token || '',
    edge_voice_override: ttsSection.edge_voice_override || ''
  };

  log(`provider=${providerName} voice=${voice} text=${text.length}字 → ${mp3Name}`);

  try {
    const result = await provider.synthesize(
      { text, voice, volume, speed, outFile },
      creds
    );
    log(`✓ ${result.provider} 生成成功: ${result.outFile} (voice=${result.voice})`);
  } catch (e) {
    err(`${providerName} 失败: ${e.message}`);
    process.exit(4);
  }
}

main().catch(e => { err(e.message); process.exit(99); });
