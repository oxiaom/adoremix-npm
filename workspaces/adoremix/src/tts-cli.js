'use strict';

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');
const prompts = require('prompts');
const logger = require('./logger');
const paths = require('./paths');
const cfg = require('./config');
const ttsDeps = require('./tts-deps');
const { STANDARD_VOICES, DEFAULT_VOICE } = require('../tts/voice-mapping');

// provider 元信息（描述 + 费用 + python 依赖）
const PROVIDER_INFO = {
  xf: {
    name: '讯飞',
    desc: '科大讯飞 WebSocket TTS',
    cost: '约 4000 元/年',
    needsPython: false
  },
  minimax: {
    name: 'MiniMax',
    desc: 'MiniMax HTTP API TTS',
    cost: '包月几十元',
    needsPython: false
  },
  edge: {
    name: 'Edge TTS',
    desc: 'Microsoft Edge TTS（python）',
    cost: '免费',
    needsPython: true
  }
};

function readTtsConfig(workdir) {
  const obj = cfg.readConfig(workdir) || {};
  return {
    provider: (obj.TTS && obj.TTS.provider) || 'xf',
    TTS: obj.TTS || {},
    Settings: obj.Settings || {}
  };
}

// === tts list ===
function cmdList(workdir) {
  const c = readTtsConfig(workdir);
  logger.log('=== TTS Provider 列表 ===');
  logger.log('');
  for (const key of Object.keys(PROVIDER_INFO)) {
    const info = PROVIDER_INFO[key];
    const active = c.provider === key ? '★ 当前' : '  ';
    logger.log(`${active} ${key.padEnd(8)} ${info.name.padEnd(10)} ${info.desc}`);
    logger.log(`          费用: ${info.cost}`);
    // 凭证状态
    const r = ttsDeps.checkDeps(workdir, key, { TTS: c.TTS, Settings: c.Settings });
    const credOk = r.issues.filter(i => i.category === 'cred').length === 0;
    const depOk = r.issues.filter(i => i.category !== 'cred').length === 0;
    logger.log(`          凭证: ${credOk ? '✓' : '✗ 缺'}  依赖: ${depOk ? '✓' : '✗ 缺'}`);
    logger.log('');
  }
  logger.log(`当前激活: ${c.provider}`);
  logger.log('切换: adoremix tts config');
  return 0;
}

// === tts voices ===
function cmdVoices(workdir) {
  const c = readTtsConfig(workdir);
  logger.log(`=== voice 短名列表（当前 provider: ${c.provider}）===`);
  logger.log('');
  // 读对应 provider 的映射
  let providerVoices = {};
  try {
    const providerMod = require(`../tts/providers/${c.provider}`);
    providerVoices = providerMod.voices || {};
  } catch (e) {}
  for (const v of STANDARD_VOICES) {
    const mapped = providerVoices[v.short] || '(无映射)';
    logger.log(`  ${v.short.padEnd(12)} → ${mapped.padEnd(28)} ${v.desc}`);
  }
  logger.log('');
  logger.log(`默认: ${DEFAULT_VOICE}`);
  return 0;
}

// === tts deps ===
function cmdDeps(workdir, opts) {
  const c = readTtsConfig(workdir);
  logger.log(`=== TTS 依赖检查（provider: ${c.provider}）===`);
  logger.log('');
  const r = ttsDeps.checkDeps(workdir, c.provider, { TTS: c.TTS, Settings: c.Settings });
  if (r.issues.length === 0) {
    logger.ok(`✓ ${c.provider} 所有依赖就绪`);
    return 0;
  }
  for (const iss of r.issues) {
    const mark = iss.severity === 'error' ? '❌' : '⚠';
    logger.log(`${mark} ${iss.msg}`);
    if (iss.fixCmd) logger.log(`   修复: ${iss.fixCmd}`);
  }
  if (opts.fix) {
    logger.log('');
    logger.info('==> 自动修复...');
    const sudo = process.getuid && process.getuid() === 0 ? false : true;
    const result = ttsDeps.fixDeps(workdir, r.issues, { sudo });
    logger.ok(`✓ 修复 ${result.fixed} 项，失败 ${result.failed} 项`);
    if (result.failed > 0) {
      logger.warn('部分失败，可能需要 sudo 重跑：sudo adoremix tts deps --fix');
    }
  } else {
    logger.log('');
    logger.log('自动修复: adoremix tts deps --fix');
  }
  return r.issues.some(i => i.severity === 'error') ? 1 : 0;
}

// === tts config ===
async function cmdConfig(workdir, opts) {
  const c = readTtsConfig(workdir);
  logger.log('=== TTS 配置向导 ===');
  logger.log('');

  // 1. 选 provider
  const choices = Object.keys(PROVIDER_INFO).map(k => ({
    title: `${k.padEnd(8)} ${PROVIDER_INFO[k].name} (${PROVIDER_INFO[k].cost})`,
    value: k,
    description: PROVIDER_INFO[k].desc
  }));
  const r1 = await prompts({
    type: 'select',
    name: 'provider',
    message: '选择 TTS provider',
    choices,
    initial: Object.keys(PROVIDER_INFO).indexOf(c.provider)
  });
  if (!r1.provider) return 1;
  cfg.setConfigValue(workdir, 'TTS.provider', r1.provider);
  logger.ok(`TTS.provider = ${r1.provider}`);

  // 2. 根据 provider 填凭证
  if (r1.provider === 'xf') {
    const fields = [
      ['Settings.ttsxfAPPID', 'appid', c.Settings.ttsxfAPPID],
      ['Settings.ttsxfAPISecret', 'apiSecret', c.Settings.ttsxfAPISecret],
      ['Settings.ttsxfAPIKey', 'apiKey', c.Settings.ttsxfAPIKey]
    ];
    for (const [key, name, cur] of fields) {
      const r = await prompts({
        type: 'text',
        name: 'v',
        message: `讯飞 ${name}${cur ? '（回车保持当前）' : ''}`,
        initial: cur || ''
      });
      if (r.v && r.v !== cur) cfg.setConfigValue(workdir, key, r.v);
    }
  } else if (r1.provider === 'minimax') {
    const cur = c.TTS.minimax_token;
    const r = await prompts({
      type: 'password',
      name: 'v',
      message: `MiniMax API token${cur ? '（回车保持当前）' : ''}`
    });
    if (r.v && r.v !== cur) cfg.setConfigValue(workdir, 'TTS.minimax_token', r.v);
  } else if (r1.provider === 'edge') {
    logger.log('Edge TTS 是免费的，无需凭证。');
    logger.log('需要: python3 + edge-tts (pip) + ffmpeg');
    logger.log('检查: adoremix tts deps');
  }

  logger.log('');
  logger.ok('配置完成。建议跑：adoremix tts test "你好"');
  return 0;
}

// === tts test <text> ===
async function cmdTest(workdir, text, opts) {
  if (!text) {
    logger.error('用法: adoremix tts test "你好世界"');
    return 1;
  }
  const c = readTtsConfig(workdir);
  const voice = opts.voice || DEFAULT_VOICE;
  const volume = String(opts.volume || 50);
  const speed = String(opts.speed || 50);

  // 检查依赖
  const r = ttsDeps.checkDeps(workdir, c.provider, { TTS: c.TTS, Settings: c.Settings });
  const errs = r.issues.filter(i => i.severity === 'error');
  if (errs.length > 0) {
    logger.error(`${c.provider} 缺依赖，先跑：adoremix tts deps --fix`);
    for (const e of errs) logger.log(`  ❌ ${e.msg}`);
    return 1;
  }

  // 准备文本 + 输出
  const ttyDir = path.join(workdir, 'tty');
  if (!fs.existsSync(ttyDir)) fs.mkdirSync(ttyDir, { recursive: true });
  const txtFile = path.join(ttyDir, '_cli_test.txt');
  const outFile = path.join(ttyDir, '_cli_test.mp3');
  fs.writeFileSync(txtFile, text);

  // 调用 dispatcher
  const ttsJs = path.join(workdir, 'tts.js');
  if (!fs.existsSync(ttsJs)) {
    logger.error(`未找到 ${ttsJs}（先跑 adoremix install）`);
    return 1;
  }
  logger.info(`provider=${c.provider} voice=${voice} text="${text.slice(0, 40)}${text.length > 40 ? '...' : ''}"`);
  try {
    execSync(`node "${ttsJs}" ${volume} ${speed} ${voice} _cli_test.mp3 _cli_test.txt`, {
      cwd: workdir,
      stdio: 'inherit'
    });
    if (fs.existsSync(outFile)) {
      const size = fs.statSync(outFile).size;
      logger.ok(`✓ 生成成功: ${outFile} (${(size / 1024).toFixed(1)} KB)`);
      return 0;
    } else {
      logger.error('未生成 mp3 文件');
      return 1;
    }
  } catch (e) {
    logger.error(`测试失败: ${e.message.split('\n')[0]}`);
    return 1;
  }
}

module.exports = {
  cmdList,
  cmdVoices,
  cmdDeps,
  cmdConfig,
  cmdTest,
  PROVIDER_INFO
};
