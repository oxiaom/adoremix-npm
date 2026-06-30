# Changelog

本文件记录 @oxiaom/adoremix 各版本变更。版本号同步主包 + 4-6 个平台子包。

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

- **darwin-x64（macOS Intel）**：GitHub Actions 的 Intel macOS runner 限额紧，首次编译一直排队。Intel Mac 用户暂时可通过 Rosetta 运行 darwin-arm64 包，或等 Intel runner 可用。
- **macOS 开机自启**：`adoremix service install` 暂不支持 macOS（无 launchd 实现），用 `adoremix start --daemon` + 手动 LaunchAgent。
