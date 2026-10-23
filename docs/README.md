# AdoreMix 广播服务器

> 基于 Qt/C++ 的广播服务器系统，npm 一键跨平台部署

[![npm version](https://img.shields.io/npm/v/@oxiaom/adoremix.svg)](https://www.npmjs.com/package/@oxiaom/adoremix)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## 💰 开源与收费说明

> ✅ **软件开源 MIT 协议，自行部署完全免费商用；仅当选择中国电信云服务托管时，才产生每月 1.8~3.8 元的运营成本费。**

本项目服务端、客户端代码已在 GitHub 开源，采用 MIT 开源协议。

1. **软件本身：永久免费，无版权费用**
   任何个人、机构、企事业单位、学校均可自由使用、商用，支持自行下载源码、独立安装部署，
   **无授权费、无功能限制、无版权约束**。

2. **可选托管服务（按需选择，非强制）**
   如需免去自建服务器、运维维护的工作，可选择由中国电信提供的云服务托管。
   仅收取**非盈利性质**的基础运营成本费：**1.8 元 / 月 ～ 3.8 元 / 月**

   ⚠️ 此费用为非盈利性质的云托管服务费，**不是软件授权费**，不使用该托管方案则无需支付这笔费用。

3. **发票说明**
   若办理电信托管服务产生缴费，可凭缴费记录联系我们申请开具发票。

## ✨ 特性

- 🎯 **一键部署** — `npm install -g @oxiaom/adoremix` 跨 5 平台（Windows x64 / Linux x64 / ARM64 / ARM / macOS Apple Silicon）
- 🔊 **多 TTS 引擎** — 讯飞 / MiniMax / Edge / Audio8 本地离线，配置切换零代码改动
- 🌐 **双 WebUI** — 低码率（16k，WiFi/互联网）+ 高码率（44.1k，局域网）一键切换
- 🚀 **开机自启** — Linux systemd / Windows Service 自动注册
- 🩺 **健康检查** — `adoremix doctor` 全面体检 + 自动修复
- 📋 **配置向导** — 交互式配 IP / CDN / TTS / 数据库
- 🔌 **零外部依赖** — Qt 运行时 + 业务资源全部打包（默认 SQLite，MySQL 可选，Redis 已移除）

## ⚡ 一条命令安装（推荐）

**Windows**（PowerShell）：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/oxiaom/adoremix-npm/main/scripts/install.ps1 | iex"
```

**Linux**（x64 / arm64 / armv7）：

```bash
curl -fsSL https://raw.githubusercontent.com/oxiaom/adoremix-npm/main/scripts/install.sh | bash
```

脚本会自动完成：检测/安装 Node.js 18+（装在用户目录，**不需要管理员权限**）→ 配置 npm 全局目录 → 安装 `@oxiaom/adoremix` → 初始化工作目录 → 自动选择网卡 IP → `adoremix doctor` 体检 → 后台启动（Linux 有 systemd 且 root 时自动注册开机自启；Windows 管理员模式自动注册服务）。

自定义参数（安装前设置环境变量）：

| 变量 | 说明 | 示例 |
|---|---|---|
| `ADOREMIX_VERSION` | 指定版本，默认 `latest` | `1.0.76` |
| `ADOREMIX_SKIP_START` | `1` = 装完不启动 | `1` |
| `ADOREMIX_NO_SERVICE` | `1` = 不注册服务（Windows） | `1` |
| `ADOREMIX_SERVICE` | `auto`/`yes`/`no`（Linux） | `no` |
| `ADOREMIX_NPM_REGISTRY` | 指定 npm 源 | `https://registry.npmmirror.com` |
| `ADOREMIX_NODE_MAJOR` | 自动安装的 Node 大版本，默认 20 | `22` |

> 中国大陆网络如访问 GitHub 较慢，可先 `npm install -g @oxiaom/adoremix` 手动安装，效果相同。

## 📦 手动安装

```bash
# 装 Node.js 18+（已装跳过）
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo bash -
sudo apt install -y nodejs

# 装 AdoreMix
npm install -g @oxiaom/adoremix

# 初始化
adoremix install

# 启动
adoremix start --daemon
```

浏览器打开 `http://<本机IP>:12080/` 即可使用。

## 📖 文档

- [完整使用文档](USAGE.md) — 从安装到高级配置
- [快速开始](USAGE.md#快速开始)
- [TTS 配置](USAGE.md#tts-文字转语音)
- [网络配置](USAGE.md#网络配置)
- [WebUI 切换](USAGE.md#webui-切换)
- [故障排查](USAGE.md#故障排查)

## 🚀 5 分钟上手

```bash
# 1. 装
npm install -g @oxiaom/adoremix

# 2. 初始化（生成默认配置）
adoremix install

# 3. 配本机 IP（让设备能连）
adoremix config network

# 4. 配 TTS（选 minimax 包月几十块，性价比高）
adoremix tts config

# 5. 启动 + 开机自启
adoremix start --daemon
adoremix service install
```

## 🎨 功能概览

| 命令 | 用途 |
|---|---|
| `adoremix install` | 初始化工作目录 |
| `adoremix start/stop/restart/status` | 服务管理 |
| `adoremix logs -f` | 查看日志 |
| `adoremix service install` | 注册开机自启 |
| `adoremix config network / preurl / webui / log` | IP、CDN、WebUI、日志开关 |
| `adoremix tts config / test / voices / deps` | TTS 配置、测试、音色、依赖 |
| `adoremix doctor [--fix]` | 健康检查 + 自动修复 |
| `adoremix uninstall [--purge]` | 卸载（`--purge` 连工作目录） |

**选装组件**（不影响主服务）：

| 命令 | 用途 | 平台 |
|---|---|---|
| `adoremix mp3server install` | MP3Server 分块推流（6665） | 全平台 |
| `adoremix nginx install` | nginx 静态加速（9876）+ preurl 切换 | Linux |
| `adoremix config-manager install` | 设备配置管理 UI（9877） | Linux |
| `adoremix audio8 install` + `adoremix audio8-fetch-model` | 本地离线 TTS（8024） | Linux |

完整命令见 [使用文档](USAGE.md)。

## 📊 平台支持

| 平台 | 架构 | 包名 |
|---|---|---|
| Windows | x64 | `@oxiaom/adoremix-win32-x64` |
| Linux | x64 | `@oxiaom/adoremix-linux-x64` |
| Linux | ARM64 | `@oxiaom/adoremix-linux-arm64` |
| Linux | ARM (armhf) | `@oxiaom/adoremix-linux-arm` |
| macOS | x64 (Intel) | ❌ 已放弃支持 |
| macOS | ARM64 (Apple Silicon) | `@oxiaom/adoremix-darwin-arm64`（已支持） |

npm 会自动按当前平台拉对应子包，**不用手动选**。

## 🔧 TTS 引擎对比

| 引擎 | 费用 | 依赖 | 质量 |
|---|---|---|---|
| 讯飞（xf） | ~4000 元/年 | Node.js | ⭐⭐⭐⭐⭐ |
| MiniMax | 包月几十元 | Node.js | ⭐⭐⭐⭐ |
| Edge TTS | **免费** | python + ffmpeg | ⭐⭐⭐⭐ |
| Audio8（本地） | **免费**（自部署） | Linux + ~1.8GB 内存 + 423MB 模型 | ⭐⭐⭐（弱 CPU 慢，适合定时广播） |

切换 provider 只改 config.ini 一个字段，Qt 代码不用动：
```bash
adoremix tts config
```

## 📁 项目结构

```
adoremix-npm/
├── workspaces/
│   ├── adoremix/          # CLI 主包（@oxiaom/adoremix）
│   │   ├── bin/           # adoremix 命令入口
│   │   ├── src/           # CLI + 配置 + 服务管理
│   │   ├── tts/           # TTS dispatcher + 3 providers
│   │   ├── webui/         # WebUI（low + high 两版）
│   │   └── templates/     # systemd / winservice 模板
│   ├── win32-x64/         # Windows 原生包
│   ├── linux-x64/         # Linux x64 原生包
│   ├── linux-arm64/       # Linux ARM64 原生包
│   ├── linux-arm/         # Linux ARM 原生包
│   └── darwin-arm64/      # macOS Apple Silicon 原生包
├── docker/                # Docker 构建脚本（Linux 4 平台）
├── docker/source-repo/    # 私有源码仓库的 CI 配置（darwin 编译）
├── docs/                  # 文档（本目录）
└── scripts/               # 发布脚本
```

## 🤝 联系

- GitHub: [oxiaom/adoremix-npm](https://github.com/oxiaom/adoremix-npm)
- npm: [@oxiaom/adoremix](https://www.npmjs.com/package/@oxiaom/adoremix)
- 问题反馈: [GitHub Issues](https://github.com/oxiaom/adoremix-npm/issues)

## 📄 License

MIT
