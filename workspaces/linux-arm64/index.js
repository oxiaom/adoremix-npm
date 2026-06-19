const path = require('path');
const fs = require('fs');

const root = path.join(__dirname, 'native');
const BIN_NAME = 'AdoreMixV8.0.17_console_linuxarm64';
const LAME_NAME = 'lame';

function exists() {
  return fs.existsSync(path.join(root, BIN_NAME));
}

module.exports = {
  platform: 'linux',
  arch: 'arm64',
  pkgName: '@oxiaom/adoremix-linux-arm64',
  root,
  bin: path.join(root, BIN_NAME),
  binName: BIN_NAME,
  lame: path.join(root, LAME_NAME),
  lameName: LAME_NAME,
  nodeSrc: root,
  exists,
  isWindows: false,
  notice: 'ARM64 二进制由 docker/build-linux-arm64.sh 或 .github/workflows/build-linux-arm64.yml 自动构建。'
};
