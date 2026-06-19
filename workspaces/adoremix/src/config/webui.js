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
  // 备份原 docroot（如果存在且不是我们自己部署的）
  // 简单做法：直接覆盖（用户业务资源应该在其他地方，docroot 是纯前端 UI）
  if (fs.existsSync(docroot)) {
    // 保留 docroot/mp3/ 目录（广播系统运行时存 mp3 的地方）
    const mp3Backup = path.join(workdir, 'etc', 'docroot_mp3_backup');
    const mp3Dir = path.join(docroot, 'mp3');
    if (fs.existsSync(mp3Dir)) {
      fse.removeSync(mp3Backup);
      fse.moveSync(mp3Dir, mp3Backup);
    }
    fse.removeSync(docroot);
  } else {
    fse.ensureDirSync(path.join(workdir, 'etc'));
  }
  fse.copySync(srcDir, docroot);
  // 恢复 mp3/
  const mp3Backup = path.join(workdir, 'etc', 'docroot_mp3_backup');
  if (fs.existsSync(mp3Backup)) {
    fse.moveSync(mp3Backup, path.join(docroot, 'mp3'));
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
