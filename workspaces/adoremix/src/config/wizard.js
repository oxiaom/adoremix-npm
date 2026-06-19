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
    type: 'confirm',
    name: '_enableTTS',
    message: '启用讯飞 TTS？',
    initial: true
  },
  {
    type: (prev) => prev ? 'text' : null,
    name: 'ttsxfAPPID',
    message: '讯飞 APPID'
  },
  {
    type: (prev, values) => values._enableTTS ? 'text' : null,
    name: 'ttsxfAPISecret',
    message: '讯飞 APISecret'
  },
  {
    type: (prev, values) => values._enableTTS ? 'text' : null,
    name: 'ttsxfAPIKey',
    message: '讯飞 APIKey'
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
  return answers;
}

module.exports = { run, guessLocalIP };
