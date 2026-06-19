'use strict';

const os = require('os');
const prompts = require('prompts');
const logger = require('../logger');

const NET_KEYS = [
  'Settings.LocalIP',
  'Settings.Meida_ip',
  'Settings.Fip'
];

function listInterfaces() {
  const ifaces = os.networkInterfaces();
  const list = [];
  for (const name of Object.keys(ifaces)) {
    for (const it of ifaces[name] || []) {
      if (it.family === 'IPv4' && !it.internal) {
        list.push({ name, address: it.address, mac: it.mac });
      }
    }
  }
  return list;
}

function isValidIPv4(s) {
  return /^(\d{1,3}\.){3}\d{1,3}$/.test(s) && s.split('.').every(p => +p >= 0 && +p <= 255);
}

async function chooseIpInteractive(initial) {
  const list = listInterfaces();
  if (list.length === 0) {
    logger.warn('未检测到任何 IPv4 网卡');
  }
  const choices = list.map(it => ({
    title: `${it.address}  (${it.name}${it.mac ? ', ' + it.mac.slice(0, 17) : ''})`,
    value: it.address,
    description: `网卡 ${it.name}`
  }));
  choices.push({
    title: '🌐  手动输入外网/其他 IP（部署到云服务器用）',
    value: '__custom__'
  });
  if (initial) {
    choices.unshift({
      title: `✓ 保持当前 IP: ${initial}`,
      value: initial,
      description: '不改'
    });
  }

  const onCancel = () => { logger.warn('已取消'); process.exit(1); };
  const resp = await prompts({
    type: 'select',
    name: 'ip',
    message: '选择绑定的 IP',
    choices,
    initial: initial ? 0 : 0
  }, { onCancel });
  if (!resp.ip) return null;
  if (resp.ip === '__custom__') {
    const r2 = await prompts({
      type: 'text',
      name: 'ip',
      message: '输入 IPv4 地址（外网/公网 IP）',
      validate: v => isValidIPv4(v) ? true : 'IPv4 格式错误，如 1.2.3.4'
    }, { onCancel });
    return r2.ip;
  }
  return resp.ip;
}

async function setupNetwork(workdir, opts) {
  opts = opts || {};
  const cfg = require('./index');
  const current = cfg.getConfigValue(workdir, 'Settings.LocalIP');
  let ip;

  if (opts.ip) {
    if (!isValidIPv4(opts.ip)) {
      logger.error(`IP 格式错误：${opts.ip}`);
      return 1;
    }
    ip = opts.ip;
    logger.log(`使用命令行指定的 IP: ${ip}`);
  } else if (opts.interactive === false) {
    // 非交互模式：自动选第一个网卡
    const list = listInterfaces();
    if (list.length === 0) {
      logger.error('未检测到 IPv4 网卡，请用 --ip <地址> 指定');
      return 1;
    }
    ip = list[0].address;
    logger.log(`非交互模式：自动选择第一个网卡 ${list[0].name} = ${ip}`);
  } else {
    logger.log('');
    logger.log('=== 网络配置向导 ===');
    logger.log('说明：');
    logger.log('  • 内网部署 → 选本机网卡 IP');
    logger.log('  • 外网/云服务器 → 手动输入公网 IP');
    logger.log(`  • 将同时设置：${NET_KEYS.join(' / ')}`);
    logger.log('');
    ip = await chooseIpInteractive(current);
    if (!ip) return 1;
  }

  for (const key of NET_KEYS) {
    cfg.setConfigValue(workdir, key, ip);
  }
  logger.ok(`已设置 ${NET_KEYS.map(k => k.split('.')[1]).join(' / ')} = ${ip}`);

  // 顺便显示当前端口配置，方便检查
  const ports = [
    ['listener.port', 'HTTP 网页'],
    ['Settings.wbport', 'web 后台'],
    ['Settings.cuteport', 'cutehttpd'],
    ['Settings.DataPort', '媒体数据'],
    ['Settings.ManagePort', '管理端口']
  ];
  logger.log('');
  logger.log('当前端口配置：');
  for (const [k, desc] of ports) {
    const v = cfg.getConfigValue(workdir, k);
    logger.log(`  ${desc.padEnd(12)} ${k} = ${v}`);
  }
  logger.log('');
  logger.log('改完后记得：adoremix restart');
  return 0;
}

module.exports = { setupNetwork, listInterfaces, isValidIPv4, NET_KEYS };
