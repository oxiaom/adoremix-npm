'use strict';

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

const logger = require('../logger');
const paths = require('../paths');

const SVC_NAME = 'AdoreMixService';

function fillTemplate(workdir) {
  const tplPath = path.join(__dirname, '..', '..', 'templates', 'winservice.js.tmpl');
  let tpl = fs.readFileSync(tplPath, 'utf8');
  return tpl
    .replace(/__WORKDIR__/g, workdir.replace(/\\/g, '\\\\'))
    .replace(/__NODE__/g, paths.nodeExecutable().replace(/\\/g, '\\\\'))
    .replace(/__CLI__/g, paths.cliBin().replace(/\\/g, '\\\\'));
}

function ensureNodeWindows(workdir) {
  try {
    require.resolve('node-windows');
    return true;
  } catch (e) {
    logger.warn('node-windows 未安装，正在尝试本地安装...');
    try {
      execSync('npm install --no-save node-windows', { cwd: workdir, stdio: 'inherit' });
      return true;
    } catch (e2) {
      logger.error('node-windows 安装失败，请手动在工作目录执行 npm install node-windows');
      return false;
    }
  }
}

function install(opts) {
  const workdir = opts.workdir;
  if (!ensureNodeWindows(workdir)) return 1;
  const wrapperPath = path.join(workdir, 'winservice.js');
  const content = fillTemplate(workdir);
  fs.writeFileSync(wrapperPath, content, 'utf8');
  logger.ok(`生成 wrapper ${wrapperPath}`);
  try {
    execSync(`node "${wrapperPath}" install`, { cwd: workdir, stdio: 'inherit' });
  } catch (e) {
    logger.error(`注册失败：${e.message}`);
    return 1;
  }
  logger.log('');
  logger.log('查看服务：sc query AdoreMixService');
  logger.log('启动/停止：sc start/stop AdoreMixService');
  logger.log('或：net start/stop AdoreMixService');
  return 0;
}

function uninstall(opts) {
  const workdir = opts.workdir;
  const wrapperPath = path.join(workdir, 'winservice.js');
  if (!fs.existsSync(wrapperPath)) {
    logger.warn(`未找到 ${wrapperPath}，直接 sc delete`);
    try {
      execSync(`sc delete ${SVC_NAME}`, { stdio: 'inherit' });
      return 0;
    } catch (e) {
      return 1;
    }
  }
  try {
    execSync(`node "${wrapperPath}" uninstall`, { cwd: workdir, stdio: 'inherit' });
  } catch (e) {
    logger.error(`卸载失败：${e.message}`);
    return 1;
  }
  return 0;
}

function status() {
  try {
    execSync(`sc query ${SVC_NAME}`, { stdio: 'inherit' });
    return 0;
  } catch (e) {
    logger.warn(`服务未安装或查询失败`);
    return 1;
  }
}

module.exports = { install, uninstall, status, SVC_NAME };
