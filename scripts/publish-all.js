'use strict';

/**
 * 5 包同版本发布脚本（子→主顺序，确保主包 install 时子包已就绪）。
 *
 * 用法：
 *   node scripts/publish-all.js                    # 默认从 package.json 读版本
 *   node scripts/publish-all.js --dry-run          # 预演
 *   node scripts/publish-all.js --version 1.0.1    # 指定版本（会同步改写所有 package.json）
 *
 * 前置：
 *   - 已 npm login（npm whoami 应返回用户名）
 *   - 子包的 native/ 已通过 split-zip.js 准备好
 *   - 当前在 monorepo 根目录
 */

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

const ROOT = path.join(__dirname, '..');
const SUBPKGS = ['win32-x64', 'linux-x64', 'linux-arm64', 'linux-arm'];
const MAIN_PKG_DIR = 'adoremix';

function readPkg(rel) {
  return JSON.parse(fs.readFileSync(path.join(ROOT, 'workspaces', rel, 'package.json'), 'utf8'));
}

function writePkg(rel, obj) {
  fs.writeFileSync(path.join(ROOT, 'workspaces', rel, 'package.json'), JSON.stringify(obj, null, 2) + '\n', 'utf8');
}

function setVersion(ver) {
  writePkg(MAIN_PKG_DIR, Object.assign(readPkg(MAIN_PKG_DIR), { version: ver }));
  for (const sub of SUBPKGS) {
    writePkg(sub, Object.assign(readPkg(sub), { version: ver }));
  }
  const rootPath = path.join(ROOT, 'package.json');
  const root = JSON.parse(fs.readFileSync(rootPath, 'utf8'));
  root.version = ver;
  fs.writeFileSync(rootPath, JSON.stringify(root, null, 2) + '\n', 'utf8');
  console.log(`所有 package.json 版本同步为 ${ver}`);
}

function npmPublish(pkgRel, access, dryRun) {
  const cwd = path.join(ROOT, 'workspaces', pkgRel);
  const cmd = `npm publish${access ? ` --access ${access}` : ''}${dryRun ? ' --dry-run' : ''}`;
  console.log(`\n>>> ${pkgRel}: ${cmd}`);
  execSync(cmd, { cwd, stdio: 'inherit' });
}

function main() {
  const args = process.argv.slice(2);
  const dryRun = args.includes('--dry-run');
  const verIdx = args.indexOf('--version');
  const ver = verIdx >= 0 ? args[verIdx + 1] : null;

  if (ver) setVersion(ver);
  const finalVer = readPkg(MAIN_PKG_DIR).version;
  console.log(`发布版本：v${finalVer}${dryRun ? '  (dry-run)' : ''}`);

  try {
    execSync('node ' + path.join('scripts', 'publish-prepare.js') + ' add', { cwd: ROOT, stdio: 'inherit' });
    for (const sub of SUBPKGS) {
      const subPkg = readPkg(sub);
      if (!fs.existsSync(path.join(ROOT, 'workspaces', sub, 'native')) ||
          fs.readdirSync(path.join(ROOT, 'workspaces', sub, 'native')).length <= 1) {
        console.log(`\n[跳过] ${sub}：native/ 目录为空（未提供二进制），不发布`);
        continue;
      }
      npmPublish(sub, 'public', dryRun);
    }
    npmPublish(MAIN_PKG_DIR, 'public', dryRun);
  } finally {
    execSync('node ' + path.join('scripts', 'publish-prepare.js') + ' remove', { cwd: ROOT, stdio: 'inherit' });
  }
  console.log('\n发布完成。');
}

if (require.main === module) {
  main();
}
