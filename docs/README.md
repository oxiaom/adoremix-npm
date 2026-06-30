# AdoreMix 广播服务器

> 基于 Qt/C++ 的广播服务器系统，npm 一键跨平台部署

[![npm version](https://img.shields.io/npm/v/@oxiaom/adoremix.svg)](https://www.npmjs.com/package/@oxiaom/adoremix)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## ✨ 特性

- 🎯 **一键部署** — `npm install -g @oxiaom/adoremix` 跨 6 平台（Windows / Linux x64 / ARM64 / ARM / macOS x64 / macOS ARM64）
- 🔊 **多 TTS 引擎** — 讯飞 / MiniMax / Edge TTS 三选一，配置切换零代码改动
- 🌐 **双 WebUI** — 低码率（16k，WiFi/互联网）+ 高码率（44.1k，局域网）一键切换
- 🚀 **开机自启** — Linux systemd / Windows Service 自动注册
- 🩺 **健康检查** — `adoremix doctor` 全面体检 + 自动修复
- 📋 **配置向导** — 交互式配 IP / CDN / TTS / 数据库
- 🔌 **零外部依赖** — Qt 运行时 + 业务资源全部打包（除 MySQL/Redis 自备）

## 📦 安装

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
| `adoremix start/stop/status` | 服务管理 |
| `adoremix service install` | 注册开机自启 |
| `adoremix config network` | 配置 IP（自动列网卡） |
| `adoremix config webui` | 切换 WebUI 版本（low/high） |
| `adoremix tts config` | 配置 TTS provider |
| `adoremix tts test "你好"` | 测试 TTS |
| `adoremix doctor` | 健康检查 |

完整命令见 [使用文档](USAGE.md)。

## 📊 平台支持

| 平台 | 架构 | 包名 |
|---|---|---|
| Windows | x64 | `@oxiaom/adoremix-win32-x64` |
| Linux | x64 | `@oxiaom/adoremix-linux-x64` |
| Linux | ARM64 | `@oxiaom/adoremix-linux-arm64` |
| Linux | ARM (armhf) | `@oxiaom/adoremix-linux-arm` |
| macOS | x64 (Intel) | `@oxiaom/adoremix-darwin-x64`（待编译，可用 Rosetta 跑 arm64 包） |
| macOS | ARM64 (Apple Silicon) | `@oxiaom/adoremix-darwin-arm64`（已支持） |

npm 会自动按当前平台拉对应子包，**不用手动选**。

## 🔧 TTS 引擎对比

| 引擎 | 费用 | 依赖 | 质量 |
|---|---|---|---|
| 讯飞（xf） | ~4000 元/年 | Node.js | ⭐⭐⭐⭐⭐ |
| MiniMax | 包月几十元 | Node.js | ⭐⭐⭐⭐ |
| Edge TTS | **免费** | python + ffmpeg | ⭐⭐⭐⭐ |

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
│   ├── darwin-x64/        # macOS Intel 原生包
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
