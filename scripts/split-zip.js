'use strict';

/**
 * 把现有的 AdoreMix 部署产物拆分到各平台子包的 native/ 目录。
 *
 * 用法：
 *   node scripts/split-zip.js                        # 使用默认源路径
 *   node scripts/split-zip.js --win32 <dir>          # 指定 Windows 源目录
 *   node scripts/split-zip.js --linux-x64 <zip>      # 指定 Linux x64 zip
 *   node scripts/split-zip.js --linux-arm <zip>      # 指定 Linux ARM zip
 *   node scripts/split-zip.js --only win32-x64       # 只处理指定平台
 *   node scripts/split-zip.js --dry-run              # 预览不执行
 *
 * 默认源路径（可改）：
 *   --win32       D:/zhuangyi/vbox/AdoreMIXMICV8
 *   --linux-x64   D:/zhuangyi/vbox/AdoreMIXMICV8linux8.10.zip
 *   --linux-arm   D:/zhuangyi/vbox/AdoreMIXMICV8linux8.10_arm.zip
 */

const fs = require('fs');
const fse = require('fs-extra');
const path = require('path');
const { execSync } = require('child_process');

const ROOT = path.join(__dirname, '..');
const WORKSPACES = path.join(ROOT, 'workspaces');

const DEFAULTS = {
  'win32-x64': 'D:/zhuangyi/vbox/AdoreMIXMICV8',
  'linux-x64': 'D:/zhuangyi/vbox/AdoreMIXMICV8linux8.10.zip',
  'linux-arm': 'D:/zhuangyi/vbox/AdoreMIXMICV8linux8.10_arm.zip'
};

const EXCLUDE_GLOBS = [
  'node_modules',
  'node_modules.rar',
  'package-lock.json',
  'npp.7.8.9.Installer.exe',
  'tts_local_edg.zip',
  'reqhttp.log',
  'logs',
  'temp',
  'dmp',
  'tty',
  'var',
  'find.so',
  'Severinit.o',
  '*.o',
  '*.pdb',
  '*d.dll',
  'a.out',
  'debug',
  'release',
  'Makefile*',
  '*.pro.user*',
  'build-AdoreMix-*'
];

const INCLUDE_KEEP = ['README.md'];

function parseArgs(argv) {
  const args = { only: null, dryRun: false, sources: {} };
  for (let i = 0; i < argv.length; i++) {
    const a = argv[i];
    if (a === '--dry-run') args.dryRun = true;
    else if (a === '--only') args.only = argv[++i];
    else if (a === '--win32') args.sources['win32-x64'] = argv[++i];
    else if (a === '--linux-x64') args.sources['linux-x64'] = argv[++i];
    else if (a === '--linux-arm') args.sources['linux-arm'] = argv[++i];
    else if (a === '--linux-arm64') args.sources['linux-arm64'] = argv[++i];
  }
  for (const k of Object.keys(DEFAULTS)) {
    if (!args.sources[k]) args.sources[k] = DEFAULTS[k];
  }
  return args;
}

function matchExclude(name) {
  return EXCLUDE_GLOBS.some((pat) => {
    if (pat.includes('*')) {
      const re = new RegExp('^' + pat.replace(/\./g, '\\.').replace(/\*/g, '.*') + '$');
      return re.test(name);
    }
    return pat === name;
  });
}

function copyDirFiltered(src, dest, dryRun) {
  const entries = fs.readdirSync(src, { withFileTypes: true });
  for (const e of entries) {
    if (matchExclude(e.name)) {
      console.log(`  skip   ${e.name}`);
      continue;
    }
    const s = path.join(src, e.name);
    const d = path.join(dest, e.name);
    if (e.isDirectory()) {
      if (!dryRun) fse.ensureDirSync(d);
      copyDirFiltered(s, d, dryRun);
    } else {
      if (!dryRun) fse.copyFileSync(s, d);
      console.log(`  copy   ${path.relative(src, s)}`);
    }
  }
}

function unzip(zipPath, dest, dryRun) {
  if (!fs.existsSync(zipPath)) {
    throw new Error(`源 zip 不存在：${zipPath}`);
  }
  if (dryRun) {
    console.log(`  unzip (dry-run) ${zipPath} -> ${dest}`);
    return;
  }
  fse.removeSync(dest);
  fse.ensureDirSync(dest);
  if (process.platform === 'win32') {
    execSync(`powershell -NoProfile -Command "Expand-Archive -LiteralPath '${zipPath}' -DestinationPath '${dest}' -Force"`, { stdio: 'inherit' });
  } else {
    execSync(`unzip -o '${zipPath}' -d '${dest}'`, { stdio: 'inherit' });
  }
}

function flattenIfSingleWrapper(dest) {
  const entries = fs.readdirSync(dest, { withFileTypes: true });
  if (entries.length === 1 && entries[0].isDirectory()) {
    const inner = path.join(dest, entries[0].name);
    const tmp = dest + '_tmp';
    fs.renameSync(inner, tmp);
    fse.removeSync(dest);
    fs.renameSync(tmp, dest);
    console.log(`  flatten ${entries[0].name}/ -> ./`);
  }
}

function applyExcludes(dest) {
  for (const e of EXCLUDE_GLOBS) {
    const re = e.includes('*') ? new RegExp('^' + e.replace(/\./g, '\\.').replace(/\*/g, '.*') + '$') : null;
    const entries = fs.existsSync(dest) ? fs.readdirSync(dest) : [];
    for (const name of entries) {
      const matched = re ? re.test(name) : (e === name);
      if (matched) {
        const p = path.join(dest, name);
        fse.removeSync(p);
        console.log(`  rm     ${name}`);
      }
    }
  }
}

function chmodBinaries(dest, platform) {
  if (platform.startsWith('linux')) {
    const tryChmod = (rel) => {
      const p = path.join(dest, rel);
      if (fs.existsSync(p)) {
        fs.chmodSync(p, 0o755);
        console.log(`  chmod  0755  ${rel}`);
      }
    };
    tryChmod('AdoreMix64_V8.06');
    tryChmod('AdoreMixV8.0.17_console_linuxarm0');
    tryChmod('lame');
    tryChmod('xiaoboshu.py');
  }
}

function ensureQtConf(dest, platform) {
  if (platform !== 'win32-x64') return;
  const p = path.join(dest, 'qt.conf');
  if (fs.existsSync(p)) return;
  fs.writeFileSync(p, '[Paths]\r\nPlugins=./\r\n', 'utf8');
  console.log('  write  qt.conf');
}

function processPlatform(platform, source, dryRun) {
  console.log(`\n[${platform}] source=${source}`);
  const dest = path.join(WORKSPACES, platform, 'native');
  if (fs.existsSync(dest) && !dryRun) {
    fse.removeSync(dest);
  }
  if (!dryRun) fse.ensureDirSync(dest);

  const isDir = fs.existsSync(source) && fs.statSync(source).isDirectory();
  if (isDir) {
    copyDirFiltered(source, dest, dryRun);
  } else {
    unzip(source, dest, dryRun);
    if (!dryRun) {
      flattenIfSingleWrapper(dest);
      applyExcludes(dest);
    }
  }
  if (!dryRun) {
    chmodBinaries(dest, platform);
    ensureQtConf(dest, platform);
    for (const f of INCLUDE_KEEP) {
      const keep = path.join(dest, f);
      if (!fs.existsSync(keep)) {
        const src = path.join(WORKSPACES, platform, 'native', 'README.md');
        if (fs.existsSync(src)) {
          // keep README
        }
      }
    }
  }
  console.log(`[${platform}] done`);
}

function main() {
  const args = parseArgs(process.argv.slice(2));
  const platforms = args.only ? [args.only] : Object.keys(args.sources);
  for (const p of platforms) {
    const src = args.sources[p];
    if (!src) {
      console.log(`\n[${p}] 无源（跳过）`);
      continue;
    }
    processPlatform(p, src, args.dryRun);
  }
  console.log('\n拆分完成。下一步：检查各 workspaces/<platform>/native/ 内容，然后 npm publish。');
}

if (require.main === module) {
  try { main(); } catch (e) {
    console.error('split 失败：', e.message);
    process.exit(1);
  }
}

module.exports = { processPlatform, parseArgs, EXCLUDE_GLOBS };
