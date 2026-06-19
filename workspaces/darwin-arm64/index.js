'use strict';

const path = require('path');
const fs = require('fs');

const root = path.join(__dirname, 'native');
const BIN_NAME = 'AdoreMixV8.0.17_console_darwinarm64';
const LAME_NAME = 'lame';

function exists() {
  return fs.existsSync(path.join(root, BIN_NAME));
}

module.exports = {
  platform: 'darwin',
  arch: 'arm64',
  pkgName: '@oxiaom/adoremix-darwin-arm64',
  root,
  bin: path.join(root, BIN_NAME),
  binName: BIN_NAME,
  lame: path.join(root, LAME_NAME),
  lameName: LAME_NAME,
  nodeSrc: root,
  exists,
  isWindows: false,
  notice: 'macOS ARM64 二进制由私有源码仓库的 .github/workflows/build-darwin.yml 在 macos-14 runner 上自动构建，release artifact 由 adoremix-npm 的 pull-darwin-artifacts.yml 拉取并打包发布。'
};
