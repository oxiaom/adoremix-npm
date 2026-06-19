'use strict';

const fs = require('fs');
const fse = require('fs-extra');
const path = require('path');
const { execSync } = require('child_process');
const os = require('os');

const logger = require('../logger');
const paths = require('../paths');

const SYSTEM_UNIT_PATH = '/etc/systemd/system/adoremix.service';
const USER_UNIT_DIR = path.join(os.homedir(), '.config', 'systemd', 'user');
const USER_UNIT_PATH = path.join(USER_UNIT_DIR, 'adoremix.service');

function isSystemMode() {
  return process.getuid && process.getuid() === 0;
}

function ensureUserExists(username) {
  try {
    execSync(`id -u ${username}`, { stdio: 'ignore' });
    return false;
  } catch (e) {
    execSync(`useradd -r -s /usr/sbin/nologin ${username}`);
    return true;
  }
}

function chownWorkdir(workdir, username) {
  execSync(`chown -R ${username}:${username} ${workdir}`);
}

function fillTemplate(workdir) {
  const tplPath = path.join(__dirname, '..', '..', 'templates', 'adoremix.service.tmpl');
  let tpl = fs.readFileSync(tplPath, 'utf8');
  const user = isSystemMode() ? 'adoremix' : os.userInfo().username;
  const node = paths.nodeExecutable();
  const cli = paths.cliBin();
  return tpl
    .replace(/__USER__/g, user)
    .replace(/__GROUP__/g, user)
    .replace(/__WORKDIR__/g, workdir)
    .replace(/__NODE__/g, node)
    .replace(/__CLI__/g, cli);
}

function installSystem(workdir) {
  let created = false;
  try {
    created = ensureUserExists('adoremix');
    if (created) logger.ok('创建系统用户 adoremix');
  } catch (e) {
    logger.warn(`无法创建 adoremix 用户：${e.message}（服务将以 root 运行）`);
  }
  if (created) {
    try { chownWorkdir(workdir, 'adoremix'); } catch (e) {
      logger.warn(`chown 失败：${e.message}`);
    }
  }
  const content = fillTemplate(workdir);
  fs.writeFileSync(SYSTEM_UNIT_PATH, content, 'utf8');
  logger.ok(`写入 unit 文件 ${SYSTEM_UNIT_PATH}`);
  execSync('systemctl daemon-reload');
  execSync('systemctl enable adoremix');
  logger.ok('systemctl enable adoremix');
  execSync('systemctl start adoremix');
  logger.ok('systemctl start adoremix');
  logger.log('');
  logger.log('查看状态：systemctl status adoremix');
  logger.log('查看日志：journalctl -u adoremix -f');
}

function installUser(workdir) {
  fse.ensureDirSync(USER_UNIT_DIR);
  const content = fillTemplate(workdir);
  fs.writeFileSync(USER_UNIT_PATH, content, 'utf8');
  logger.ok(`写入 user unit ${USER_UNIT_PATH}`);
  execSync('systemctl --user daemon-reload');
  execSync('systemctl --user enable adoremix');
  logger.ok('systemctl --user enable adoremix');
  execSync('systemctl --user start adoremix');
  logger.ok('systemctl --user start adoremix');
  logger.log('');
  logger.log('用户服务需 linger 才能开机自启：loginctl enable-linger $USER');
  logger.log('查看状态：systemctl --user status adoremix');
}

function uninstallSystem() {
  try { execSync('systemctl stop adoremix', { stdio: 'ignore' }); } catch (e) {}
  try { execSync('systemctl disable adoremix', { stdio: 'ignore' }); } catch (e) {}
  if (fs.existsSync(SYSTEM_UNIT_PATH)) fs.unlinkSync(SYSTEM_UNIT_PATH);
  execSync('systemctl daemon-reload');
  logger.ok('服务已卸载');
}

function uninstallUser() {
  try { execSync('systemctl --user stop adoremix', { stdio: 'ignore' }); } catch (e) {}
  try { execSync('systemctl --user disable adoremix', { stdio: 'ignore' }); } catch (e) {}
  if (fs.existsSync(USER_UNIT_PATH)) fs.unlinkSync(USER_UNIT_PATH);
  execSync('systemctl --user daemon-reload');
  logger.ok('用户服务已卸载');
}

function statusSystem() {
  try {
    execSync('systemctl status adoremix --no-pager', { stdio: 'inherit' });
  } catch (e) {
    return 1;
  }
  return 0;
}

function statusUser() {
  try {
    execSync('systemctl --user status adoremix --no-pager', { stdio: 'inherit' });
  } catch (e) {
    return 1;
  }
  return 0;
}

module.exports = {
  install(opts) {
    const workdir = opts.workdir;
    if (isSystemMode()) installSystem(workdir);
    else installUser(workdir);
    return 0;
  },
  uninstall() {
    if (isSystemMode()) uninstallSystem();
    else uninstallUser();
    return 0;
  },
  status() {
    return isSystemMode() ? statusSystem() : statusUser();
  },
  _internal: { fillTemplate, SYSTEM_UNIT_PATH, USER_UNIT_PATH }
};
