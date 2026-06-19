'use strict';

const fs = require('fs');
const fse = require('fs-extra');
const path = require('path');
const { execSync } = require('child_process');

const paths = require('./paths');
const logger = require('./logger');

const EMPTY_DIRS = ['var', 'logs', 'dmp', 'tty', 'temp'];

const NODE_HELPER_DEPS = {
  'axios': '^1.5.0',
  'crypto-js': '^4.1.1',
  'log4node': '^0.1.6',
  'mysql': '^2.18.1',
  'request': '^2.88.2',
  'sqlite': '^4.2.0',
  'ws': '^8.13.0'
};

function isWorkdirInitialized(workdir) {
  return fs.existsSync(path.join(workdir, '.adoremix-installed'));
}

function ensureWorkdir(workdir) {
  if (!fs.existsSync(workdir)) {
    fse.ensureDirSync(workdir);
    logger.ok(`创建工作目录 ${workdir}`);
  } else {
    logger.info(`工作目录已存在 ${workdir}`);
  }
}

function copyNative(native, workdir, force) {
  if (!native.exists()) {
    throw new Error(
      `原生二进制 ${native.binName} 未找到。\n` +
      `路径：${native.bin}\n` +
      `请先运行拆分脚本：node scripts/split-zip.js --only ${paths.PLATFORM_KEY.replace('_', '-')}`
    );
  }
  const marker = path.join(workdir, '.adoremix-installed');
  if (fs.existsSync(marker) && !force) {
    logger.warn(`工作目录已初始化（存在 ${marker}）。使用 --force 覆盖。`);
    return false;
  }
  logger.info(`复制 native 资源 ${native.root} -> ${workdir}`);
  fse.copySync(native.root, workdir, {
    filter: (s) => {
      const base = path.basename(s);
      return base !== 'README.md' || path.dirname(s) !== native.root;
    }
  });
  fs.writeFileSync(marker, JSON.stringify({
    version: require('../package.json').version,
    platform: native.platform,
    arch: native.arch,
    binName: native.binName,
    installedAt: new Date().toISOString()
  }, null, 2), 'utf8');
  logger.ok('资源复制完成');
  return true;
}

function chmodBinaries(workdir, native) {
  if (process.platform === 'win32') return;
  for (const rel of [native.binName, 'lame', 'xiaoboshu.py']) {
    const p = path.join(workdir, rel);
    if (fs.existsSync(p)) {
      fs.chmodSync(p, 0o755);
      logger.log(`  chmod 0755 ${rel}`);
    }
  }
}

function ensureEmptyDirs(workdir) {
  for (const d of EMPTY_DIRS) {
    const p = path.join(workdir, d);
    fse.ensureDirSync(p);
  }
  logger.ok('创建空目录：var/ logs/ dmp/ tty/ temp/');
}

function writeHelperPackageJson(workdir) {
  const pkgPath = path.join(workdir, 'package.json');
  const existing = fs.existsSync(pkgPath) ? JSON.parse(fs.readFileSync(pkgPath, 'utf8')) : {};
  existing.name = existing.name || 'adoremix-workdir';
  existing.version = existing.version || '1.0.0';
  existing.private = true;
  existing.dependencies = Object.assign({}, NODE_HELPER_DEPS, existing.dependencies || {});
  fs.writeFileSync(pkgPath, JSON.stringify(existing, null, 2), 'utf8');
  logger.ok('写入 package.json（tts.js/find.js/findsc.js 协作依赖）');
  return pkgPath;
}

function installHelperDeps(workdir, skipNpmInstall) {
  if (skipNpmInstall) {
    logger.warn('--skip-npm-install 跳过协作依赖安装');
    return;
  }
  logger.info('在工作目录安装 Node 协作依赖（axios/ws/crypto-js/mysql 等）...');
  try {
    execSync('npm install --production --no-audit --no-fund', {
      cwd: workdir,
      stdio: 'inherit'
    });
    logger.ok('协作依赖安装完成');
  } catch (e) {
    logger.error('npm install 失败，请手动到工作目录执行 npm install');
    throw e;
  }
}

// 部署多 provider TTS dispatcher（xf/minimax/edge）
// 覆盖原 Dockerfile 拷的旧 tts.js（讯飞专用版），换成统一 dispatcher
function deployTtsDispatcher(workdir) {
  const ttsSrcDir = path.join(__dirname, '..', 'tts');
  if (!fs.existsSync(ttsSrcDir)) {
    logger.warn('主包无 tts/ 目录（旧版？），跳过 TTS dispatcher 部署');
    return;
  }
  const ttsDstDir = path.join(workdir, 'adoremix-tts');
  // 复制整个 tts/ 目录（dispatcher + providers + voice-mapping）
  fse.copySync(ttsSrcDir, ttsDstDir, {
    filter: (src) => {
      const base = path.basename(src);
      // 不复制 tts-wrapper.js（它要复制到顶层当 tts.js）
      return base !== 'tts-wrapper.js';
    }
  });
  // 顶层 tts.js 用 wrapper 覆盖原版（Qt 调用入口）
  const wrapperSrc = path.join(ttsSrcDir, 'tts-wrapper.js');
  const ttsJs = path.join(workdir, 'tts.js');
  fse.copyFileSync(wrapperSrc, ttsJs);
  logger.ok('部署 TTS dispatcher（xf/minimax/edge 三选一）');
  logger.log('    配置：adoremix tts config');
  logger.log('    测试：adoremix tts test "你好"');
}

async function runInstall(opts) {
  opts = opts || {};
  const workdir = opts.workdir || paths.defaultWorkdir();
  let native;
  try {
    native = opts.native || paths.loadNative();
  } catch (e) {
    logger.error(e.message);
    return 1;
  }
  if (native.notice) {
    logger.warn(native.notice);
  }
  logger.log(`平台       ${native.platform}-${native.arch}`);
  logger.log(`工作目录   ${workdir}`);
  logger.log(`主二进制   ${native.binName}`);
  logger.log('');

  ensureWorkdir(workdir);
  let copied;
  try {
    copied = copyNative(native, workdir, opts.force);
  } catch (e) {
    logger.error(e.message);
    return 1;
  }
  if (!copied && !opts.force) return 1;

  chmodBinaries(workdir, native);
  ensureEmptyDirs(workdir);
  writeHelperPackageJson(workdir);
  try {
    installHelperDeps(workdir, opts.skipNpmInstall);
  } catch (e) {
    return 1;
  }
  deployTtsDispatcher(workdir);

  const config = require('./config');
  const cfgOk = await config.ensureConfig(workdir, { interactive: opts.interactive !== false, force: opts.force });
  if (!cfgOk) {
    logger.warn('配置未生成。请稍后运行 adoremix config init');
  }

  logger.log('');
  logger.ok('安装完成。');
  logger.log('  启动（前台）        adoremix start');
  logger.log('  开机自启            adoremix service install');
  logger.log('  查看状态            adoremix status');
  logger.log('  查看日志            adoremix logs --follow');
  return 0;
}

module.exports = {
  runInstall,
  EMPTY_DIRS,
  NODE_HELPER_DEPS,
  isWorkdirInitialized
};
