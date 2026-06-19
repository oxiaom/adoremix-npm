# AdoreMix linux-arm64 原生包

本目录存放 Linux ARM64 (aarch64) 平台的二进制和运行时资源。

## 二进制构建方式（自动化）

本子包的二进制**不再依赖手工交叉编译**，而是通过 Docker + QEMU 在任意 x64 主机上自动构建：

### 本地构建（推荐首次验证用）

在 Windows / macOS / Linux 任意 x64 主机：

```bash
cd D:/zhuangyi/vbox/adoremix-npm
./docker/build-linux-arm64.sh --src D:/zhuangyi/vbox/Adore_mix2
```

前置：
- Docker Desktop 4.x（自带 buildx + QEMU）
- 或 Linux 上手动装 `docker buildx` + `qemu-user-static`

脚本流程：
1. 注册 QEMU static binary（让 x64 能跑 ARM64 镜像）
2. 用 buildx 构建 `docker/Dockerfile.linux-arm64`（Ubuntu 22.04 ARM64 base）
3. 容器内：apt 装 Qt 5.15 dev + hiredis + opus + lame + openssl + mariadb
4. 容器内：编译 QtCipherSqlitePlugin 到 Qt plugins/sqldrivers
5. 容器内：sed 修复 `AdoreMix.pro` 硬编码的 `/opt/qt5.9.1-arm/...` 路径
6. 容器内：`qmake && make` 编译 AdoreMix 主程序
7. 容器内：收集 `.so` + Qt plugins + 资源 + `lame` 到 `/out`
8. 容器内：`patchelf --set-rpath '$ORIGIN/lib'` 让二进制从同级 `lib/` 加载依赖
9. 主机：`docker cp` 把 `/out` 提取到本目录

首次构建约 15-30 分钟（apt + make），后续若用 buildx cache 只需 1-2 分钟。

### CI 自动构建

`/.github/workflows/build-linux-arm64.yml` 提供了同样的流程：

1. 手动触发 workflow（GitHub Actions 页面 → Run workflow）
2. 输入 Adore_mix2 源码 tar.gz 的下载 URL
3. CI 自动构建、提取产物、commit 回 main 分支、打 tag
4. tag 触发 `publish.yml` → npm publish

### 验证产物架构

```bash
file workspaces/linux-arm64/native/AdoreMixV8.0.17_console_linuxarm64
# 应输出：ELF 64-bit LSB executable, ARM aarch64
```

## 预期内容

构建完成后 `native/` 应包含：

```
AdoreMixV8.0.17_console_linuxarm64  # 主程序
lame                                  # MP3 编码器
qt.conf                               # Qt plugins 路径提示
lib/                                  # Qt5 .so + 第三方依赖
  libQt5Core.so.5
  libQt5Network.so.5
  libQt5Sql.so.5
  libQt5WebSockets.so.5
  libQt5Multimedia.so.5
  libhiredis.so*
  libopus.so*
  libmp3lame.so*
  libssl.so*
  libcrypto.so*
  libsqlite3.so*
  libmariadb.so*
platforms/                            # Qt plugins
sqldrivers/                           # libsqlitecipher.so（自编译）
  libqsqlite.so
  libsqlitecipher.so
bearer/
iconengines/
imageformats/
mediaservice/
audio/
translations/
etc/                                  # 业务资源
conf/
html/
tts.js
find.js
findsc.js
xiaoboshu.py
.adoremix-native.json                 # 构建元信息
```

## 目标运行环境

- Ubuntu 22.04 / 24.04 LTS aarch64
- Debian 12+ aarch64
- 树莓派 4/5（Ubuntu Server / Raspberry Pi OS 64-bit）
- 阿里云 / AWS Graviton 等 ARM 云主机
- 任意带 glibc ≥ 2.35 的 ARM64 Linux

不兼容 Android（bionic libc）、OpenWrt（musl libc）、Alpine（musl libc）。
