'use strict';

const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');
const logger = require('./logger');
const paths = require('./paths');

// 已知 .so → apt 包名映射（Ubuntu/Debian）
const LIB_TO_PKG = {
  'libdouble-conversion.so.3': 'libdouble-conversion3',
  'libpcre2-16.so.0': 'libpcre2-16-0',
  'libssl.so.3': 'libssl3',
  'libcrypto.so.3': 'libssl3',
  'libhiredis.so.0.14': 'libhiredis0.14',
  'libopus.so.0': 'libopus0',
  'libopusfile.so.0': 'libopusfile0',
  'libmp3lame.so.0': 'libmp3lame0',
  'libsqlite3.so.0': 'libsqlite3-0',
  'libmariadb.so.3': 'libmariadb3',
  'libstdc++.so.6': 'libstdc++6',
  'libgcc_s.so.1': 'libgcc-s1',
  'libz.so.1': 'zlib1g',
  'libglib-2.0.so.0': 'libglib2.0-0',
  'libgssapi_krb5.so.2': 'libkrb5-3',
  'libkrb5.so.3': 'libkrb5-3'
};

function runDoctor(workdir, opts) {
  opts = opts || {};
  logger.log('=== AdoreMix 健康检查 ===');
  logger.log('');

  const issues = [];

  // 1. Node 版本
  const nodeVer = process.versions.node;
  const major = parseInt(nodeVer.split('.')[0], 10);
  if (major < 16) {
    issues.push({ type: 'node', severity: 'error', msg: `Node ${nodeVer} 太老，需要 >= 16` });
    logger.error(`❌ Node.js ${nodeVer}（需要 >= 16）`);
  } else {
    logger.ok(`✓ Node.js v${nodeVer}`);
  }

  // 2. native 包是否加载
  let native;
  try {
    native = paths.loadNative();
    logger.ok(`✓ 平台子包 ${native.pkgName}`);
  } catch (e) {
    issues.push({ type: 'native', severity: 'error', msg: e.message });
    logger.error(`❌ 平台子包未加载：${e.message.split('\n')[0]}`);
    return reportAndExit(issues, opts);
  }

  // 3. 二进制存在 + 可执行
  const binPath = path.join(workdir, native.binName);
  const nativeBinPath = native.bin;
  let binOk = false;
  if (fs.existsSync(binPath)) {
    binOk = true;
    logger.ok(`✓ 工作目录二进制 ${native.binName}`);
  } else if (fs.existsSync(nativeBinPath)) {
    binOk = true;
    logger.warn(`⚠  工作目录无二进制（用 node_modules 子包里的）`);
  } else {
    issues.push({ type: 'binary', severity: 'error', msg: '二进制不存在' });
    logger.error(`❌ 二进制不存在：${native.binName}`);
  }

  if (binOk && process.platform !== 'win32') {
    // 检查 +x
    const stat = fs.statSync(fs.existsSync(binPath) ? binPath : nativeBinPath);
    const mode = stat.mode & 0o111;
    if (!mode) {
      issues.push({ type: 'perm', severity: 'warn', msg: '二进制缺执行权限' });
      logger.warn(`⚠  二进制缺 +x 权限（spawn 时会自动 chmod）`);
    }
  }

  // 4. ldd 检查缺库（仅 Linux）
  if (binOk && process.platform === 'linux') {
    const checkBin = fs.existsSync(binPath) ? binPath : nativeBinPath;
    try {
      const ldd = execSync(`ldd "${checkBin}"`, { encoding: 'utf8', stdio: ['pipe', 'pipe', 'pipe'] });
      const missing = [];
      for (const line of ldd.split('\n')) {
        const m = line.match(/^\s*(\S+)\s*=>\s*not found/);
        if (m) missing.push(m[1]);
      }
      if (missing.length === 0) {
        logger.ok(`✓ 动态库依赖完整`);
      } else {
        logger.error(`❌ 缺动态库：${missing.join(', ')}`);
        const pkgs = [];
        const unknown = [];
        for (const lib of missing) {
          const pkg = LIB_TO_PKG[lib];
          if (pkg) pkgs.push(pkg);
          else unknown.push(lib);
        }
        const allPkgs = [...new Set(pkgs)];
        if (allPkgs.length > 0) {
          const cmd = `apt-get install -y ${allPkgs.join(' ')}`;
          logger.log(`  建议命令（root 用户）：${cmd}`);
          if (unknown.length > 0) {
            logger.warn(`  未知库（无 apt 映射）：${unknown.join(', ')}`);
          }
          issues.push({
            type: 'libs',
            severity: 'error',
            msg: missing.join(', '),
            fixCmd: cmd,
            pkgs: allPkgs
          });
          if (opts.fix) {
            logger.info(`==> 自动修复：执行 ${cmd}`);
            try {
              execSync(cmd, { stdio: 'inherit', cwd: workdir });
              logger.ok('✓ 缺库已安装');
            } catch (e) {
              logger.error(`修复失败：${e.message}`);
              logger.warn('可能需要 sudo：手动执行 sudo ' + cmd);
            }
          }
        }
      }
    } catch (e) {
      logger.warn(`⚠  ldd 检查失败（非 Linux 或权限问题）：${e.message.split('\n')[0]}`);
    }
  }

  // 5. config.ini 存在
  const cfgPath = path.join(workdir, 'config.ini');
  if (fs.existsSync(cfgPath)) {
    logger.ok(`✓ config.ini`);
  } else {
    issues.push({ type: 'config', severity: 'warn', msg: 'config.ini 不存在，需要 adoremix install' });
    logger.warn(`⚠  config.ini 不存在`);
  }

  // 6. .Adore.db 存在 + 有数据
  const dbPath = path.join(workdir, '.Adore.db');
  if (fs.existsSync(dbPath)) {
    const size = fs.statSync(dbPath).size;
    if (size > 0) {
      logger.ok(`✓ .Adore.db (${(size / 1024).toFixed(1)} KB)`);
    } else {
      issues.push({ type: 'db', severity: 'warn', msg: '.Adore.db 是空文件' });
      logger.warn(`⚠  .Adore.db 是空文件（缺默认数据）`);
    }
  }

  // 7. 进程状态
  const pidMgr = require('./runner/pid');
  const wp = paths.workdirPaths(workdir);
  const pid = pidMgr.readPid(wp.pidfile);
  if (pid && pidMgr.isRunning(pid)) {
    logger.ok(`✓ 服务运行中 PID=${pid}`);
  } else {
    logger.log(`○ 服务未运行（adoremix start 启动）`);
  }

  return reportAndExit(issues, opts);
}

function reportAndExit(issues, opts) {
  logger.log('');
  const errors = issues.filter(i => i.severity === 'error');
  const warns = issues.filter(i => i.severity === 'warn');
  if (errors.length === 0 && warns.length === 0) {
    logger.ok('🎉 全部正常');
    return 0;
  }
  if (errors.length > 0) {
    logger.error(`发现 ${errors.length} 个问题：`);
    return 1;
  }
  logger.warn(`发现 ${warns.length} 个警告（不影响运行）`);
  return 0;
}

module.exports = { runDoctor, LIB_TO_PKG };
