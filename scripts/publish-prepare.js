'use strict';

/**
 * 发布前给子包 package.json 临时加上 os/cpu 字段（从 _publish_os/_publish_cpu 复制）。
 * publish-all.js 在 npm publish 后会还原。
 *
 * 原因：monorepo workspaces 下子包若带 os/cpu 限制，npm install 在不匹配平台上会 EBADPLATFORM。
 * 所以开发时只保留 _publish_os/_publish_cpu 占位字段，发布时再切换。
 */

const fs = require('fs');
const path = require('path');

const ROOT = path.join(__dirname, '..');
const SUBPKGS = ['win32-x64', 'linux-x64', 'linux-arm64', 'linux-arm', 'darwin-x64', 'darwin-arm64'];

function apply(dir, mode) {
  const pkgPath = path.join(ROOT, 'workspaces', dir, 'package.json');
  const pkg = JSON.parse(fs.readFileSync(pkgPath, 'utf8'));
  if (mode === 'add') {
    if (pkg._publish_os) pkg.os = pkg._publish_os;
    if (pkg._publish_cpu) pkg.cpu = pkg._publish_cpu;
  } else if (mode === 'remove') {
    delete pkg.os;
    delete pkg.cpu;
  }
  fs.writeFileSync(pkgPath, JSON.stringify(pkg, null, 2) + '\n', 'utf8');
  console.log(`${mode}  ${dir}  os=${JSON.stringify(pkg.os || null)}  cpu=${JSON.stringify(pkg.cpu || null)}`);
}

const mode = process.argv[2];
if (!['add', 'remove'].includes(mode)) {
  console.error('用法：node publish-prepare.js add|remove');
  process.exit(1);
}
for (const dir of SUBPKGS) {
  apply(dir, mode);
}
