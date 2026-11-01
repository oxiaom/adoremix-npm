'use strict';

const fs = require('fs');
const path = require('path');
const ini = require('./ini');
const defaults = require('./defaults');
const wizard = require('./wizard');
const portseries = require('./portseries');
const logger = require('../logger');
const paths = require('../paths');

function mergeDeep(target, src) {
  if (target == null) target = {};
  for (const k of Object.keys(src || {})) {
    if (src[k] && typeof src[k] === 'object' && !Array.isArray(src[k])) {
      target[k] = mergeDeep(target[k] || {}, src[k]);
    } else {
      target[k] = src[k];
    }
  }
  return target;
}

function configPath(workdir) {
  return path.join(workdir, 'config.ini');
}

function readConfig(workdir) {
  const p = configPath(workdir);
  if (!fs.existsSync(p)) return null;
  return ini.read(p);
}

function writeConfig(workdir, obj) {
  const p = configPath(workdir);
  ini.write(p, obj);
  return p;
}

async function ensureConfig(workdir, opts) {
  opts = opts || {};
  const p = configPath(workdir);
  if (fs.existsSync(p) && !opts.force) {
    logger.info(`配置已存在 ${p}`);
    return true;
  }
  let merged = mergeDeep({}, defaults);
  if (opts.interactive !== false) {
    logger.log('');
    logger.log('=== AdoreMix 配置向导 ===');
    logger.log('提示：可直接回车使用默认值；密码类项回车留空。');
    logger.log('');
    const answers = await wizard.run(merged.Settings || {});
    merged.Settings = Object.assign({}, merged.Settings, answers);
  }
  // 端口系列：--port-series 117 → 所有端口都用 117xx
  if (opts.portSeries !== undefined && opts.portSeries !== null && opts.portSeries !== '') {
    const series = parseInt(opts.portSeries, 10);
    if (!Number.isInteger(series) || series < 0 || series > 640) {
      logger.warn(`端口系列号无效（${opts.portSeries}），使用默认端口`);
    } else {
      merged = portseries.applySeries(merged, series);
      merged.Settings.PortSeries = series;
      logger.ok(`端口已设置为 ${series}xx 系列`);
    }
  }
  writeConfig(workdir, merged);
  logger.ok(`配置已生成 ${p}`);
  return true;
}

function listConfig(workdir) {
  const obj = readConfig(workdir);
  if (!obj) {
    logger.warn('配置不存在，请先 adoremix install 或 adoremix config init');
    return null;
  }
  return obj;
}

function getConfigValue(workdir, dottedKey) {
  const obj = readConfig(workdir);
  if (!obj) return undefined;
  return ini.get(obj, dottedKey);
}

function setConfigValue(workdir, dottedKey, value) {
  let obj = readConfig(workdir);
  if (!obj) obj = mergeDeep({}, defaults);
  const typed = autoCast(value);
  ini.set(obj, dottedKey, typed);
  writeConfig(workdir, obj);
  return obj;
}

function autoCast(value) {
  if (value === 'true') return true;
  if (value === 'false') return false;
  if (/^-?\d+$/.test(value)) return parseInt(value, 10);
  if (/^-?\d+\.\d+$/.test(value)) return parseFloat(value);
  return value;
}

module.exports = {
  defaults,
  configPath,
  readConfig,
  writeConfig,
  ensureConfig,
  listConfig,
  getConfigValue,
  setConfigValue,
  mergeDeep,
  portseries
};
