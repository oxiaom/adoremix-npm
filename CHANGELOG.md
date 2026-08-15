# Changelog

本文件记录 @oxiaom/adoremix 各版本变更。版本号同步主包 + 4-6 个平台子包。

## 1.0.40 — 2026-08-15

### 修复:mp3 流播放 Windows 卡死(实时喊话发一个包就停)
- **PackSize 默认值 1024 → 2048**。设备端 mp3 预缓冲阈值是 2048 字节,而服务器"发一个包等一个 5 字节 ACK"的流控,当 PackSize=1024 时一个包不够预缓冲,设备端会 `prebuffer stalled` 丢包不回 ACK,服务器等不到 ACK 停发 → 死锁。改为 2048 后一个包正好填满预缓冲,正常回 ACK 继续流。
- 注:已部署的老版本需手动把 config.ini 的 `PackSize` 改成 `2048`(install --force 不覆盖 config.ini)。

## 1.0.38 — 2026-08-13

### 可选组件：设备配置管理 UI（config-manager，仅 Linux）
- 内置 Python Flask 应用，Web 界面管理设备（端口 9877，开机自启）。
- 三个功能页：**配置 IP 地址 / 修改 config.ini / 查看运行日志**。
- `adoremix config-manager install/uninstall/status`：检测 python3 + Flask，写 systemd 服务，路径参数化（`ADOREMIX_WORKDIR`）。
- 仅 Linux（依赖 systemd）。

## 1.0.37 — 2026-08-13

### 可选组件：NGINX 静态加速（仅 Linux）
- `adoremix nginx install/uninstall/status`：媒体文件走 nginx（端口 9876 挂 `etc/docroot`），减轻设备服务压力。
- mp3 等媒体文件加 30 天缓存头，js/css/图片 7 天缓存。
- 安装后 `Settings.preurl` 自动改为 `http://IP:9876/`；卸载还原到原端口。
- 开机自启（systemd）。仅 Linux。

### doctor 增强
- 全面检查所有捆绑库从 `lib/` 加载（不只 glibc/libstdc++），防止版本不匹配。
- 检测平台子包版本不一致（npm 镜像同步滞后），`--fix` 自动用官方源重装。

## 1.0.30 — 2026-08-10

### Linux(修复若干 bug,x64/arm64/arm 三架构重建)
- **etc 目录扁平化**:x64/arm 之前是 `etc/etc/docroot` 嵌套,应用读的是扁平 `etc/docroot` → 网页资源 404。已改 `cp -r etc/.` 并重建。
- **捆绑 lame**:TTS 转 mp3 调用外部命令 `lame`,之前只装了库没装命令 → 转码失败。已补装并捆绑。
- **补齐生产资源**:源码 etc 不完整(static 只有 .map、xcx 不全、缺 bangzhu/templates/ttys 部分 SQL),重建会丢网页资源。已把完整 docroot/static JS/xcx/bangzhu/templates/ttys 补回包内,并同步回源码。

## 1.0.29 — 2026-08-04

### Windows
- **补 .Adore.db**:win32 包的 .Adore.db 从未提交,Windows 安装缺数据库。已提交并发布。

## 1.0.28 — 2026-08-05

### 平台
- **放弃 macOS Intel（darwin-x64）支持**：Intel Mac 二进制从未发布（Intel runner 排队问题无法解决），正式放弃。macOS 仅支持 Apple Silicon（arm64）。
  - 移除 `workspaces/darwin-x64`、发布脚本/CI/依赖声明中的 darwin-x64 引用。
  - Intel Mac 用户无法安装（`adoremix` 会提示不支持的平台）。

## 1.0.27 — 2026-08-05

### Linux（重大：构建基线 + 自包含）
- **构建基线 Ubuntu 22.04 → Debian 11**：glibc 要求从 2.34 降到 **2.29**，支持面扩大：
  - ✅ Ubuntu 20.04 / 22.04 / 24.04、优麒麟 20.04+、Debian 11 / 12、Rocky / AlmaLinux 9
  - ⚠️ 统信 UOS 20 / 龙蜥 Anolis 8 / openEuler 20.03（glibc 2.28）暂不支持，后续版本适配
  - ❌ CentOS 7 / 中标麒麟（glibc 2.17）：Qt 5.15 本身不支持
- **全依赖捆绑自包含**：Qt 5.15.2 + ICU 67 + kerberos/glib/pcre/z 等全部传递依赖捆绑进 `lib/`，并用 `DT_RPATH($ORIGIN/lib)` 传递解析 —— 不再依赖系统 Qt/ICU/kerberos，任意 glibc ≥ 2.29 的发行版可直接运行（已在 debian:12-slim 裸容器验证启动）。
- **构建加速**：apt 走清华镜像（国内构建从几小时降到几分钟）。
- x64 / arm64 / arm 三个架构全部重建。

### doctor
- ICU 识别泛化到任意版本；捆绑 ICU 后跨发行版不再缺 ICU。

## 1.0.26 — 2026-08-04

### doctor / install（路径与环境）
- **安装目录不能含中文等非 ASCII 字符**：AdoreMix 在含中文路径下运行会出问题。doctor 现在会检出非 ASCII 路径并提示用纯英文路径重装（Windows 例 `C:\adoremix`，Linux 例 `/opt/adoremix`）。
- **`adoremix install` 前置拦截**：工作目录含中文等非 ASCII 直接拒绝安装，从源头防止装出问题路径。
- **doctor 检测陈旧工作目录**：比对 `.adoremix-installed` 记录版本 vs 当前包版本，不一致提示 `adoremix install --force` 刷新二进制/资源（保留 config.ini），避免升级后工作目录还在用旧二进制。

### 构建工具（防回归）
- **split-zip win32 保护**：`scripts/split-zip.js` 的 win32 默认源是旧的 32 位 Qt 5.9 目录，用它 split 会把已修复的 64 位 Qt 5.15.2 native 覆盖回坏状态。现在默认拦截，需显式 `--win32 <新源>` 或 `--win32-force`。

## 1.0.25 — 2026-08-04

### 安装（升级安全）
- **`adoremix install --force` 不再覆盖已存在的 config.ini**：`--force` 只刷新二进制/资源，保留客户自定义配置（端口、设备等）。需要重建配置请用 `adoremix config init --force`。
- 注：1.0.24 文档曾声明此行为但代码未生效（`ensureConfig` 仍传 `force: true`），本版真正修复，与文档对齐。

## 1.0.24 — 2026-08-04

### doctor（解决 Linux 运行中崩溃定位）
- **全面检查所有依赖库版本兼容性**：ldd 检查从"只报缺库"升级为逐项核对所有依赖的版本与匹配：
  - **libstdc++**：需 ≥ `GLIBCXX_3.4.29`（Qt 5.15 要求，GCC 9 时代符号）。系统 libstdc++ 太旧会在运行中 undefined symbol 崩溃，最贴合"启动一会儿就崩"。
  - **glibc**：需 ≥ `GLIBC_2.34`（二进制在 Ubuntu 22.04 编译，Ubuntu < 22.04 会直接加载失败）。
  - **Qt 捆绑一致性**：确认加载的是捆绑 `lib/` 里的 Qt 5.15.3，而非系统 Qt（版本不匹配会崩）。
- 新增"已解析依赖 N 项，缺库 M 项"统计，方便把输出贴回排障。
- 缺库/ICU70 的 `--fix` 逻辑保留不变。

## 1.0.23 — 2026-08-02

### 平台：Windows win32-x64（修复运行即崩）
- **统一 Qt 5.15.2 mingw81_64（64 位）**：此前包内 `AdoreMixV8X.exe` 是 64 位（Qt 5.15.2 构建），但 Qt5*.dll 是 **32 位 Qt 5.9.0**（由旧的 split-zip 从 32 位部署目录拷入）。64 位 exe 加载 32 位 DLL → 启动即 `0xc000007b` 崩溃。
- 重新编译 exe + sqlitecipher 插件，native 内全部 Qt DLL/插件/MinGW 运行时统一为 64 位 Qt 5.15.2；移除 32 位残留（`libgcc_s_sjlj-1.dll`、`qnativewifibearer.dll`、`qsqlmysql.dll`）。
- 构建脚本 `build-win32-x64.sh` 的 windeployqt 改用纯净 PATH：本机 PATH 里的旧 Qt 5.9（`G:\Qt\Qt5.9.0\5.9\mingw53_32\bin`）曾导致 windeployqt 把 32 位 5.9 DLL 部署进 native。

### 升级提示（Windows 老版本客户）
只更新 npm 包**不会**生效——`adoremix start` 优先用工作目录里 `install` 时复制的二进制，需刷新工作目录：
```bash
npm install -g @oxiaom/adoremix@latest
adoremix install --force     # 刷新工作目录新二进制/资源（v1.0.25 起保留 config.ini）
adoremix restart
```

## 1.0.22 — 2026-07-01

### TTS
- **voice 跨 provider 统一映射**：Qt/WebUI 实际传讯飞 4 音色（`xiaoyan`/`aisjiuxu`/`aisxping`/`aisjinger`），但 minimax/xf 之前对讯飞男声 `aisjiuxu`（许久）会 fallback 到女声——**选男声出女声**。现在三个 provider 都正确映射（xf 透传 / minimax 就近 / edge 就近）。
- `adoremix tts voices` 命令对齐 Qt 实际，只展示 4 个讯飞音色 + 当前 provider 的映射，不再列 Qt 不传的短名。

### 服务管理
- **systemd 模式下 `adoremix start/stop/restart` 委托 `systemctl`**：之前 `restart` 是 stop（kill child→systemd inactive）+ start（手动 spawn），新进程脱离 systemd 管理（SSH 断开就死）。现在检测到 systemd 管理时自动委托 `systemctl restart adoremix`，保持服务在 systemd 管理下。

## 1.0.21 — 2026-06-30

### 服务管理
- **Windows service 改前台模式**：winservice 模板跟 Linux systemd 犯了一样的错（`--daemon` → node 退出 → winsw 认为服务停）。Windows 用户 `adoremix service install` 同样起不来，已修。

### TTS
- edge voice 加 `aisxping`（小萍）/ `aisjinger`（小婧）精确映射（之前 fallback 晓晓，性别对但音色不对）。

## 1.0.20 — 2026-06-30

### 服务管理（P0）
- **`adoremix service install` systemd 起不来**：unit 模板用 `--daemon`，node spawn 二进制后 unref 退出，systemd `KillMode=control-group` 把整个 cgroup（含二进制）杀了，服务 Duration 仅 288ms。改前台模式，systemd 正确跟踪 node 主进程。
- **`adoremix logs -f` 看不到实时日志**：systemd 模式日志进 `logs/svc.log`/`svc.err`，命令只看 `var/app.log`。改成自动选最近更新的日志文件。
- service unit 模板 stderr 合并到 `svc.log`（一个文件包含全部日志）。

### TTS（P0）
- **`lame` 漏检**：二进制调外部命令 `lame` 把 TTS 音频转 mp3，doctor 之前只查 ffmpeg 不查 lame，缺失时 TTS 生成 .txt 但 mp3 转码失败（无声）。同时修了 `executables` 拼写 bug（`execubles` 少个 a，导致 executables 数组从没被遍历过）。
- **edge voice 映射 + fallback**：edge-tts 实际只有 8 个 zh-CN voice，但映射了 19 个短名，13 个指向不存在的 voice（如 `XiaoyanNeural`），全触发 `NoAudioReceived` 静默失败。修正映射 + 加 fallback 兜底（voice 失败回落 XiaoxiaoNeural）。
- **doctor 检查 dispatcher 协作依赖（ini）**：`--skip-npm-install` 或 npm install 失败时，dispatcher `require('ini')` 报 MODULE_NOT_FOUND，TTS 全挂。doctor 现在检查 ini 等，`--fix` 自动 npm install。
- tts-deps 的 pip/npm 安装默认走国内镜像（清华 PyPI / npmmirror），避免下载损坏。

## 1.0.19 — 2026-06-29

### 平台
- **新增 darwin-arm64（macOS Apple Silicon）二进制**：通过私有源码仓库 GitHub Actions（macos-14 runner）编译，npm 子包 `@oxiaom/adoremix-darwin-arm64`。

### 服务管理（P0）
- **前台 `adoremix start` 秒退**：入口 `bin/adoremix.js` 在命令完成后无脑 `process.exit`，把前台 spawn 的二进制孤儿化（收到 SIGHUP 被终止）。daemon 模式因 `child.unref()` 没被发现。去掉强制 exit，让事件循环自然管理。

### doctor
- **ICU 70 跨发行版兜底**：二进制在 Ubuntu 22.04（ICU 70）编译，Debian 12 / 树莓派 OS / Armbian 只有 libicu72，缺 libicu70 无法启动。doctor `--fix` 自动从 Ubuntu 官方源下载对应架构 libicu70 .deb 安装（arm64 走 ports.ubuntu.com，x64 走 archive，armhf/armv7 也覆盖）。

### TTS
- **edge provider 自动装 pip + PEP 668 + 清华镜像**：Debian 12/Armbian 三连坑——python3 自带但 pip 缺失（自动 apt install python3-pip）；PEP 668 externally-managed-environment 禁止装系统包（自动加 --break-system-packages）；默认 PyPI 国内慢下载损坏（默认走清华镜像）。

---

## 已知限制

- **darwin-x64（macOS Intel）**：已放弃支持（v1.0.28 起）。macOS 仅支持 Apple Silicon。
- **macOS 开机自启**：`adoremix service install` 暂不支持 macOS（无 launchd 实现），用 `adoremix start --daemon` + 手动 LaunchAgent。
