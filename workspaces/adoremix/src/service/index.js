'use strict';

const logger = require('../logger');

function pick() {
  if (process.platform === 'win32') return require('./windows');
  if (process.platform === 'linux') return require('./linux');
  throw new Error(`service 子命令暂不支持平台 ${process.platform}`);
}

module.exports = {
  install(opts) { return pick().install(opts); },
  uninstall(opts) { return pick().uninstall(opts); },
  status() { return pick().status(); }
};
