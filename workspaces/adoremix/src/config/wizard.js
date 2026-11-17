'use strict';

const os = require('os');
const prompts = require('prompts');
const logger = require('../logger');

function guessLocalIP() {
  const ifaces = os.networkInterfaces();
  for (const name of Object.keys(ifaces)) {
    for (const it of ifaces[name]) {
      if (it.family === 'IPv4' && !it.internal) return it.address;
    }
  }
  return '127.0.0.1';
}

const QUESTIONS = [
  {
    type: 'text',
    name: 'LocalIP',
    message: '本机对外 IP（用于 Meida_ip / Fip / LocalIP）',
    initial: () => guessLocalIP()
  },
  {
    type: 'text',
    name: 'task_ip',
    message: 'MySQL 主机',
    initial: '127.0.0.1'
  },
  {
    type: 'number',
    name: 'sqltask_port',
    message: 'MySQL 端口',
    initial: 3307
  },
  {
    type: 'text',
    name: 'task_username',
    message: 'MySQL 用户名',
    initial: 'root'
  },
  {
    type: 'password',
    name: 'task_passwd',
    message: 'MySQL 密码'
  },
  {
    type: 'text',
    name: 'basename',
    message: 'MySQL 数据库名',
    initial: 'adore'
  },
  {
    type: 'confirm',
    name: 'EnableRedis',
    message: '启用 Redis？',
    initial: false
  },
  {
    type: (prev) => prev ? 'text' : null,
    name: 'RedisIP',
    message: 'Redis 主机',
    initial: '127.0.0.1'
  },
  {
    type: (prev, values) => values.EnableRedis ? 'number' : null,
    name: 'RedisPort',
    message: 'Redis 端口',
    initial: 6379
  },
  {
    type: (prev, values) => values.EnableRedis ? 'password' : null,
    name: 'RedisAUTH',
    message: 'Redis 密码（无可留空）'
  },
  {
    type: 'select',
    name: '_ttsProvider',
    message: '选择 TTS provider',
    choices: [
      { title: 'edge   Edge TTS（免费，需 python3 + edge-tts）', value: 'edge' },
      { title: 'audio8 本地离线 TTS（免费自部署，需 Audio8 服务）', value: 'audio8' },
      { title: 'xf     讯飞（商用，约 4000 元/年）', value: 'xf' },
      { title: 'minimax MiniMax（包月几十元）', value: 'minimax' },
      { title: '暂不配置 TTS', value: 'none' }
    ],
    initial: 0
  },
  {
    type: (prev, values) => values._ttsProvider === 'xf' ? 'text' : null,
    name: 'ttsxfAPPID',
    message: '讯飞 APPID'
  },
  {
    type: (prev, values) => values._ttsProvider === 'xf' ? 'text' : null,
    name: 'ttsxfAPISecret',
    message: '讯飞 APISecret'
  },
  {
    type: (prev, values) => values._ttsProvider === 'xf' ? 'text' : null,
    name: 'ttsxfAPIKey',
    message: '讯飞 APIKey'
  },
  {
    type: (prev, values) => values._ttsProvider === 'minimax' ? 'password' : null,
    name: '_minimaxToken',
    message: 'MiniMax API token'
  },
  {
    type: (prev, values) => values._ttsProvider === 'audio8' ? 'text' : null,
    name: '_audio8BaseUrl',
    message: 'Audio8 服务地址（本机部署回车用默认，远程填对方 IP）',
    initial: 'http://127.0.0.1:8024'
  }
];

async function run(current) {
  const answers = {};
  const initial = Object.assign({}, current || {});

  const onCancel = () => {
    logger.warn('已取消');
    process.exit(1);
  };

  for (const q of QUESTIONS) {
    let q2 = q;
    if (typeof q.initial === 'function' && q.type === 'text') {
      q2 = Object.assign({}, q, { initial: q.initial(answers) });
    } else if (initial[q.name] !== undefined) {
      q2 = Object.assign({}, q, { initial: initial[q.name] });
    }
    const res = await prompts(q2, { onCancel });
    if (res[q.name] !== undefined) {
      answers[q.name] = res[q.name];
    }
  }
  delete answers._enableTTS;

  // 把 provider 选择翻译成 config.ini 的实际键。
  //
  // 向导只问一次「用哪个 provider」，但各家的凭证字段完全不同
  // （讯飞在 [Settings]、minimax/audio8 在 [TTS]），所以这里做映射。
  const provider = answers._ttsProvider;
  if (provider && provider !== 'none') {
    answers.TTS = answers.TTS || {};
    answers.TTS.provider = provider;
    if (provider === 'minimax' && answers._minimaxToken) {
      answers.TTS.minimax_token = answers._minimaxToken;
    }
    if (provider === 'audio8' && answers._audio8BaseUrl) {
      answers.TTS.audio8_base_url = answers._audio8BaseUrl;
    }
  }
  delete answers._ttsProvider;
  delete answers._minimaxToken;
  delete answers._audio8BaseUrl;
  return answers;
}

module.exports = { run, guessLocalIP };
