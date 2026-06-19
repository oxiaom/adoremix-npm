'use strict';

const fs = require('fs');
const path = require('path');
const fse = require('fs-extra');
const prompts = require('prompts');
const logger = require('../logger');
const cfg = require('./index');

const WEBUI_KEY = 'Settings.webui';

const WEBUI_VARIANTS = {
  low: {
    name: '低码率',
    desc: '16k stereo / 32kbps（WiFi 音响、互联网环境）',
    dir: 'low'
  },
  high: {
    name: '高码率',
    desc: '44.1k stereo / 64kbps（局域网、音质要求高）',
    dir: 'high'
  }
};

function getWebuiDir(variant) {
  const v = WEBUI_VARIANTS[variant];
  if (!v) return null;
  // npm 包里 webui/ 在主包根
  return path.join(__dirname, '..', '..', 'webui', v.dir);
}

function deployWebui(workdir, variant) {
  const srcDir = getWebuiDir(variant);
  if (!srcDir) {
    logger.error(`未知 webui 变体: ${variant}（可选: low / high）`);
    return false;
  }
  if (!fs.existsSync(srcDir)) {
    logger.error(`webui 源目录不存在: ${srcDir}`);
    logger.warn('主包可能没包含 webui/（旧版？）');
    return false;
  }
  const docroot = path.join(workdir, 'etc', 'docroot');
  fse.ensureDirSync(docroot);

  // 只替换 UI 相关文件（index.html + assets/ + js/）
  // 保留其他用户数据：mp3/（上传的音频）、bangzhu/、luyin2/、static/、xcx/ 等
  // 这样切换 UI 不会丢失任何业务数据
  const uiFiles = ['index.html'];
  const uiDirs = ['assets', 'js'];

  // 先删旧 UI 文件（如果存在）
  for (const f of uiFiles) {
    const p = path.join(docroot, f);
    if (fs.existsSync(p)) fs.unlinkSync(p);
  }
  for (const d of uiDirs) {
    const p = path.join(docroot, d);
    if (fs.existsSync(p)) fse.removeSync(p);
  }

  // 复制新 UI 文件
  for (const f of uiFiles) {
    const src = path.join(srcDir, f);
    if (fs.existsSync(src)) fse.copySync(src, path.join(docroot, f));
  }
  for (const d of uiDirs) {
    const src = path.join(srcDir, d);
    if (fs.existsSync(src)) fse.copySync(src, path.join(docroot, d));
  }

  // 复制 webui 包里其他顶层文件（如 favicon.ico 等，但不碰用户已有的非 UI 文件）
  // 注意：只复制 webui 包里"独有"的文件，不覆盖 docroot 已有的同名文件
  const webuiEntries = fs.readdirSync(srcDir);
  for (const entry of webuiEntries) {
    if (uiFiles.includes(entry) || uiDirs.includes(entry)) continue;
    const dst = path.join(docroot, entry);
    if (!fs.existsSync(dst)) {
      // 只在 docroot 不存在时复制（避免覆盖用户数据）
      fse.copySync(path.join(srcDir, entry), dst);
    }
  }

  return true;
}

async function setupWebui(workdir, opts) {
  opts = opts || {};
  const current = cfg.getConfigValue(workdir, WEBUI_KEY) || 'low';

  let variant;
  if (opts.variant) {
    if (!WEBUI_VARIANTS[opts.variant]) {
      logger.error(`未知变体: ${opts.variant}（可选: ${Object.keys(WEBUI_VARIANTS).join(' / ')}）`);
      return 1;
    }
    variant = opts.variant;
  } else if (opts.interactive === false) {
    variant = current;
  } else {
    logger.log('');
    logger.log('=== WebUI 版本选择 ===');
    logger.log('说明：');
    logger.log('  • 低码率 (16k/32kbps)  - WiFi 音响、互联网环境，省流量');
    logger.log('  • 高码率 (44.1k/64kbps) - 局域网、音质要求高');
    logger.log(`当前：${current}（${WEBUI_VARIANTS[current].desc}）`);
    logger.log('');
    const resp = await prompts({
      type: 'select',
      name: 'variant',
      message: '选择 WebUI 版本',
      choices: Object.keys(WEBUI_VARIANTS).map(k => ({
        title: `${WEBUI_VARIANTS[k].name.padEnd(6)} ${WEBUI_VARIANTS[k].desc}`,
        value: k
      })),
      initial: Object.keys(WEBUI_VARIANTS).indexOf(current)
    });
    if (!resp.variant) return 1;
    variant = resp.variant;
  }

  logger.info(`部署 WebUI: ${variant} (${WEBUI_VARIANTS[variant].desc})`);
  const ok = deployWebui(workdir, variant);
  if (!ok) return 1;

  cfg.setConfigValue(workdir, WEBUI_KEY, variant);
  logger.ok(`Settings.webui = ${variant}`);
  logger.ok(`已部署到 ${path.join(workdir, 'etc', 'docroot')}`);
  logger.log('改完后记得：adoremix restart');
  return 0;
}

module.exports = {
  setupWebui,
  deployWebui,
  WEBUI_VARIANTS,
  WEBUI_KEY
};
