'use strict';

const path = require('path');
const os = require('os');
const fs = require('fs');

const PLATFORM_KEY = `${process.platform}_${process.arch}`;
const PLATFORM_PKG = {
  'win32_x64': '@oxiaom/adoremix-win32-x64',
  'linux_x64': '@oxiaom/adoremix-linux-x64',
  'linux_arm64': '@oxiaom/adoremix-linux-arm64',
  'linux_arm': '@oxiaom/adoremix-linux-arm',
  'darwin_x64': '@oxiaom/adoremix-darwin-x64',
  'darwin_arm64': '@oxiaom/adoremix-darwin-arm64'
}[PLATFORM_KEY];

let _native = null;
let _loadError = null;

function loadNative() {
  if (_native) return _native;
  if (_loadError) throw _loadError;
  if (!PLATFORM_PKG) {
    _loadError = new Error(`不支持的平台：${PLATFORM_KEY}。当前支持 win32-x64 / linux-x64 / linux-arm64 / linux-arm / darwin-x64 / darwin-arm64。`);
    throw _loadError;
  }
  try {
    _native = require(PLATFORM_PKG);
  } catch (e) {
    _loadError = new Error(
      `未安装平台子包 ${PLATFORM_PKG}。可能原因：\n` +
      `  - npm install 时被 --no-optional 跳过\n` +
      `  - 子包尚未发布到 npm registry\n` +
      `原始错误：${e.message}`
    );
    throw _loadError;
  }
  return _native;
}

function defaultWorkdir() {
  if (process.platform === 'win32') {
    const base = process.env.PROGRAMDATA || 'C:\\ProgramData';
    return path.join(base, 'adoremix');
  }
  if (process.getuid && process.getuid() === 0) {
    return '/opt/adoremix';
  }
  const xdg = process.env.XDG_DATA_HOME;
  return xdg ? path.join(xdg, 'adoremix') : path.join(os.homedir(), '.local', 'share', 'adoremix');
}

function workdirPaths(workdir) {
  return {
    root: workdir,
    config: path.join(workdir, 'config.ini'),
    bin: null,
    lame: null,
    pidfile: path.join(workdir, 'var', 'app.pid'),
    logfile: path.join(workdir, 'var', 'app.log'),
    svcLog: path.join(workdir, 'logs', 'svc.log'),
    svcErr: path.join(workdir, 'logs', 'svc.err'),
    varDir: path.join(workdir, 'var'),
    logsDir: path.join(workdir, 'logs'),
    dmpDir: path.join(workdir, 'dmp'),
    ttyDir: path.join(workdir, 'tty'),
    tempDir: path.join(workdir, 'temp'),
    etcDir: path.join(workdir, 'etc'),
    confDir: path.join(workdir, 'conf'),
    htmlDir: path.join(workdir, 'html'),
    nodeModulesDir: path.join(workdir, 'node_modules')
  };
}

function cliRoot() {
  return path.join(__dirname, '..');
}

function nodeExecutable() {
  return process.execPath;
}

function cliBin() {
  return path.join(cliRoot(), 'bin', 'adoremix.js');
}

module.exports = {
  PLATFORM_KEY,
  PLATFORM_PKG,
  loadNative,
  defaultWorkdir,
  workdirPaths,
  cliRoot,
  cliBin,
  nodeExecutable
};
