'use strict';

const os = require('os');
const prompts = require('prompts');
const logger = require('../logger');

const NET_KEYS = [
  'Settings.LocalIP',
  'Settings.Meida_ip',
  'Settings.Fip'
];

const PREURL_KEY = 'Settings.preurl';
const HTTP_PORT_KEY = 'listener.port';

// 默认 preurl 格式：http://<IP>:<port>/
// 如果用户改成 CDN 域名（如 http://cdn.xxx.com/），改 IP 时不应该覆盖
function extractPreurlHost(preurl) {
  if (!preurl) return null;
  const m = String(preurl).match(/^https?:\/\/([^:/]+)/);
  return m ? m[1] : null;
}

function isPreurlCdn(preurl) {
  const host = extractPreurlHost(preurl);
  if (!host) return false;
  return !isValidIPv4(host);  // 域名 = CDN，IP = 直连
}

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

  // 智能更新 preurl：如果是 IP 格式（直连），同步改；CDN 域名不动
  const currentPreurl = cfg.getConfigValue(workdir, PREURL_KEY);
  const port = cfg.getConfigValue(workdir, HTTP_PORT_KEY) || 12080;
  if (currentPreurl && isPreurlCdn(currentPreurl)) {
    logger.log('');
    logger.log(`preurl 当前是 CDN/域名：${currentPreurl}（保留不覆盖）`);
    logger.log('  改 CDN 用：adoremix config preurl http://cdn.your.com/');
  } else {
    const newPreurl = `http://${ip}:${port}/`;
    cfg.setConfigValue(workdir, PREURL_KEY, newPreurl);
    logger.ok(`已同步更新 preurl = ${newPreurl}`);
  }

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

async function setupLog(workdir, opts) {
  opts = opts || {};
  const cfg = require('./index');
  const KEY = 'Settings.isopenrizhi';
  let val;
  if (opts.enable !== undefined) {
    val = !!opts.enable;
  } else if (opts.interactive === false) {
    val = false;
  } else {
    const cur = cfg.getConfigValue(workdir, KEY);
    logger.log('');
    logger.log('=== 日志开关 (isopenrizhi) ===');
    logger.log('开启后：');
    logger.log('  • 记录所有播放日志');
    logger.log('  • 实时喊话推流的语音/音频自动保存为 mp3');
    logger.log('注意：长期开启会占用大量磁盘空间');
    logger.log(`当前：${cur ? '开启' : '关闭'}`);
    logger.log('');
    const resp = await prompts({
      type: 'toggle',
      name: 'val',
      message: '是否开启日志',
      initial: !!cur,
      active: '开启',
      inactive: '关闭'
    });
    val = resp.val;
  }
  cfg.setConfigValue(workdir, KEY, val);
  logger.ok(`isopenrizhi = ${val}`);
  if (val) {
    logger.warn('日志已开启，长期运行会占用磁盘，建议定期清理 tty/ 和 logs/');
  }
  logger.log('改完后记得：adoremix restart');
  return 0;
}

async function setupPreurl(workdir, opts) {
  opts = opts || {};
  const cfg = require('./index');
  const current = cfg.getConfigValue(workdir, PREURL_KEY);
  const port = cfg.getConfigValue(workdir, HTTP_PORT_KEY) || 12080;
  const ip = cfg.getConfigValue(workdir, 'Settings.LocalIP') || '127.0.0.1';

  let url;
  if (opts.url) {
    url = opts.url;
  } else if (opts.interactive === false) {
    url = `http://${ip}:${port}/`;
  } else {
    logger.log('');
    logger.log('=== preurl 配置（设备拉资源用的 URL）===');
    logger.log('说明：');
    logger.log('  • 直连：http://<本机IP>:<端口>/（默认）');
    logger.log('  • CDN 加速：http://cdn.your.com/（设备从 CDN 拉资源）');
    logger.log(`  • 当前值：${current}`);
    logger.log('');
    const resp = await prompts({
      type: 'select',
      name: 'choice',
      message: '选择 preurl 来源',
      choices: [
        { title: `用本机直连：http://${ip}:${port}/`, value: 'direct' },
        { title: '🌐  手动输入 CDN/外网地址', value: 'custom' }
      ]
    });
    if (resp.choice === 'direct') {
      url = `http://${ip}:${port}/`;
    } else if (resp.choice === 'custom') {
      const r2 = await prompts({
        type: 'text',
        name: 'url',
        message: '输入完整 URL（含 http(s):// 和末尾 /）',
        initial: 'http://cdn.example.com/',
        validate: v => /^https?:\/\/[^/]+\//.test(v) ? true : '格式：http(s)://域名或IP/'
      });
      url = r2.url;
    } else {
      return 1;
    }
  }
  cfg.setConfigValue(workdir, PREURL_KEY, url);
  logger.ok(`preurl = ${url}`);
  logger.log('改完后记得：adoremix restart');
  return 0;
}

module.exports = {
  setupNetwork,
  setupPreurl,
  setupLog,
  listInterfaces,
  isValidIPv4,
  isPreurlCdn,
  NET_KEYS,
  PREURL_KEY
};
