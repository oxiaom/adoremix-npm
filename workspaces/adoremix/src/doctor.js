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

// ICU 70 兜底：
// AdoreMix 二进制在 Ubuntu 22.04（ICU 70）编译，链接 libicui18n.so.70 / libicuuc.so.70 / libicudata.so.70。
// Debian 12 / 树莓派 OS / Armbian 等 apt 源里只有 libicu72，没有 libicu70，跨发行版运行会缺库。
// 这三个 .so 都由同一个包 libicu70 提供，从 Ubuntu 官方源下载对应架构 .deb 装上即可（与系统 libicu72 共存，不冲突）。
const ICU70_LIBS = ['libicui18n.so.70', 'libicuuc.so.70', 'libicudata.so.70'];
const ICU70_DEB_SOURCES = {
  // node arch → [deb arch, Ubuntu 源根]
  arm64: ['arm64', 'http://ports.ubuntu.com/ubuntu-ports'],   // 非 amd64 架构走 ports
  arm: ['armhf', 'http://ports.ubuntu.com/ubuntu-ports'],     // armv7 / armhf（树莓派 32 位、老款盒子）
  x64: ['amd64', 'http://archive.ubuntu.com/ubuntu']
};

function getIcu70DebInfo() {
  const src = ICU70_DEB_SOURCES[process.arch];
  if (!src) return null;
  const [debArch, base] = src;
  return {
    debArch,
    url: `${base}/pool/main/i/icu/libicu70_70.1-2_${debArch}.deb`,
    tmpPath: '/tmp/adoremix-libicu70.deb'
  };
}

function tryFixIcu70() {
  const info = getIcu70DebInfo();
  if (!info) {
    logger.warn(`  ICU 70 兜底暂不支持架构 ${process.arch}，请手动安装 libicu70`);
    return false;
  }
  logger.info(`==> ICU 70 兜底：从 Ubuntu 官方源下载 libicu70 (${info.debArch})`);
  logger.log(`    ${info.url}`);
  try {
    execSync(`wget -q -O ${info.tmpPath} '${info.url}'`, { stdio: 'inherit' });
    const size = fs.statSync(info.tmpPath).size;
    if (size < 100000) {
      logger.error(`下载失败（文件 ${size} 字节，可能 URL 失效或网络不通）`);
      try { fs.unlinkSync(info.tmpPath); } catch (e) {}
      return false;
    }
    logger.info(`==> dpkg -i libicu70_70.1-2_${info.debArch}.deb (${(size / 1024 / 1024).toFixed(1)} MB)`);
    execSync(`dpkg -i ${info.tmpPath}`, { stdio: 'inherit' });
    try { fs.unlinkSync(info.tmpPath); } catch (e) {}
    return true;
  } catch (e) {
    logger.error(`ICU 70 安装失败：${(e.message || '').split('\n')[0]}`);
    logger.warn(`  可能需要 root，手动执行：`);
    logger.warn(`  wget -O /tmp/libicu70.deb '${info.url}' && sudo dpkg -i /tmp/libicu70.deb`);
    return false;
  }
}

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
        // 分类：apt 可装 / ICU 70 跨发行版兜底 / 完全未知
        const pkgs = [];
        const icu70 = [];
        const unknown = [];
        for (const lib of missing) {
          if (ICU70_LIBS.includes(lib)) icu70.push(lib);
          else if (LIB_TO_PKG[lib]) pkgs.push(LIB_TO_PKG[lib]);
          else unknown.push(lib);
        }
        const allPkgs = [...new Set(pkgs)];

        // 1) apt 可装的库
        let aptSolved = allPkgs.length === 0;
        if (allPkgs.length > 0) {
          const cmd = `apt-get install -y ${allPkgs.join(' ')}`;
          logger.log(`  建议命令（root 用户）：${cmd}`);
          if (opts.fix) {
            logger.info(`==> 自动修复：执行 ${cmd}`);
            try {
              execSync(cmd, { stdio: 'inherit', cwd: workdir });
              logger.ok('✓ 缺库已安装');
              aptSolved = true;
            } catch (e) {
              logger.error(`修复失败：${e.message}`);
              logger.warn('可能需要 sudo：手动执行 sudo ' + cmd);
            }
          }
        }

        // 2) ICU 70 跨发行版兜底（Debian 12 / 树莓派 OS / Armbian 等无 libicu70）
        let icuSolved = icu70.length === 0;
        if (icu70.length > 0) {
          const icuMsg = `ICU 70 缺失（${icu70.join(', ')}）— 二进制在 Ubuntu 22.04 编译，Debian 12 等需补 libicu70`;
          if (opts.fix) {
            if (tryFixIcu70()) {
              logger.ok('✓ libicu70 已安装（ICU 70 兜底）');
              icuSolved = true;
            } else {
              issues.push({ type: 'icu70', severity: 'error', msg: icuMsg });
            }
          } else {
            logger.warn(`  ${icuMsg}`);
            logger.log(`    自动修复：adoremix doctor --fix（从 Ubuntu 官方源下载 libicu70 .deb）`);
            issues.push({ type: 'icu70', severity: 'error', msg: icuMsg });
          }
        }

        // 3) 未解决的记 issue
        if (!aptSolved) {
          issues.push({
            type: 'libs',
            severity: 'error',
            msg: missing.join(', '),
            fixCmd: `apt-get install -y ${allPkgs.join(' ')}`,
            pkgs: allPkgs
          });
        }

        // 4) 完全未知的库
        if (unknown.length > 0) {
          logger.warn(`  未知库（无 apt 映射，需手动排查）：${unknown.join(', ')}`);
          issues.push({ type: 'libs-unknown', severity: 'error', msg: unknown.join(', ') });
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

  // 8. TTS provider 依赖检查
  logger.log('');
  logger.log('=== TTS Provider 检查 ===');
  const cfg = require('./config');
  const cfgObj = cfg.readConfig(workdir) || {};
  const ttsDeps = require('./tts-deps');
  const providerName = (cfgObj.TTS && cfgObj.TTS.provider) || 'xf';
  logger.log(`当前 provider: ${providerName}`);
  const ttsResult = ttsDeps.checkDeps(workdir, providerName, cfgObj);
  if (ttsResult.issues.length === 0) {
    logger.ok(`✓ ${providerName} provider 所有依赖就绪`);
  } else {
    for (const iss of ttsResult.issues) {
      const mark = iss.severity === 'error' ? '❌' : '⚠';
      logger.log(`  ${mark} ${iss.msg}`);
      if (iss.fixCmd) logger.log(`     修复：${iss.fixCmd}`);
      if (iss.autoFixable) issues.push({ type: 'tts', severity: iss.severity, msg: iss.msg, fixCmd: iss.fixCmd });
    }
    if (opts.fix) {
      logger.info('==> 自动修复 TTS 依赖...');
      const r = ttsDeps.fixDeps(workdir, ttsResult.issues, { sudo: process.getuid && process.getuid() === 0 });
      logger.ok(`✓ 修复 ${r.fixed} 项，失败 ${r.failed} 项`);
    }
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
