const path = require('path');
const fs = require('fs');

const root = path.join(__dirname, 'native');
const BIN_NAME = 'AdoreMixV8X.exe';
const LAME_NAME = 'lame.exe';

function exists() {
  return fs.existsSync(path.join(root, BIN_NAME));
}

module.exports = {
  platform: 'win32',
  arch: 'x64',
  pkgName: '@oxiaom/adoremix-win32-x64',
  root,
  bin: path.join(root, BIN_NAME),
  binName: BIN_NAME,
  lame: path.join(root, LAME_NAME),
  lameName: LAME_NAME,
  nodeSrc: root,
  exists,
  isWindows: true
};
