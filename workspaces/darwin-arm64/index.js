'use strict';

const path = require('path');
const fs = require('fs');

const root = path.join(__dirname, 'native');
const BIN_NAME = 'AdoreMixV8.0.17_console_darwinarm64';
// Qt 框架/插件必须放在 .app bundle 里（macdeployqt 产物），
// binName 因此是相对 workdir 的路径；spawn/doctor/chmod 都按相对路径拼接。
const BIN_REL = path.join('AdoreMix.app', 'Contents', 'MacOS', BIN_NAME);
const LAME_NAME = 'lame';

function exists() {
  return fs.existsSync(path.join(root, BIN_REL));
}

module.exports = {
  platform: 'darwin',
  arch: 'arm64',
  pkgName: '@oxiaom/adoremix-darwin-arm64',
  root,
  bin: path.join(root, BIN_REL),
  binName: BIN_REL,
  lame: path.join(root, LAME_NAME),
  lameName: LAME_NAME,
  nodeSrc: root,
  exists,
  isWindows: false,
  notice: 'macOS ARM64 二进制由私有源码仓库的 .github/workflows/build-darwin.yml 在 macos-15 runner 上自动构建，release artifact 由 adoremix-npm 的 pull-darwin-artifacts.yml 拉取并打包发布。'
};
