# AdoreMix darwin-x64 原生包

本目录存放 macOS x64 (Intel) 平台的二进制和运行时资源。

## 二进制构建方式（自动化）

本子包的二进制由**私有源码仓库**（`oxiaom/adoremix-source`，未公开）的 GitHub Actions 自动构建：

### 构建流程

1. 源码仓库收到 push 或手动触发 `build-darwin.yml`
2. GitHub Actions 在 `macos-13`（Intel x64）runner 上：
   - `brew install qt@5 lame`
   - 编译 QtCipherSqlitePlugin 到 Qt plugins/sqldrivers
   - `qmake && make` 编译 AdoreMix 主程序
   - `macdeployqt` 把 Qt frameworks + plugins 打包到二进制同级
   - 打 tag 时上传 `adoremix-darwin-x64-{version}.tar.gz` 到 release
3. 公开 npm 仓库（`oxiaom/adoremix-npm`）的 `pull-darwin-artifacts.yml` workflow：
   - 下载私有仓库的 release artifact
   - 解压到本目录
   - 自动发布到 npm

### 首次构建后预期内容

```
AdoreMixV8.0.17_console_darwinx64  # 主程序（Mach-O x86_64）
lame                                # MP3 编码器
qt.conf
lib/                                # Qt5 frameworks + .dylib
  QtCore.framework/
  QtNetwork.framework/
  QtSql.framework/
  QtWebSockets.framework/
  libhiredis.dylib
  libopus.dylib
  libmp3lame.dylib
  libssl.dylib
  libcrypto.dylib
  libsqlite3.dylib
  libmariadb.dylib
platforms/
sqldrivers/
  libsqlitecipher.dylib
bearer/
iconengines/
imageformats/
translations/
etc/
conf/
html/
tts.js
find.js
findsc.js
.adoremix-native.json
```

### 验证产物架构

```bash
file workspaces/darwin-x64/native/AdoreMixV8.0.17_console_darwinx64
# 应输出：Mach-O 64-bit executable x86_64
```

## 目标运行环境

- macOS 11 Big Sur 及以后（Intel x86_64）
- macOS 12 Monterey / 13 Ventura / 14 Sonoma / 15 Sequoia
- 在 Apple Silicon 上通过 Rosetta 2 也可运行（但建议直接用 darwin-arm64 子包）
