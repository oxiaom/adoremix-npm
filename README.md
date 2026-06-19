# AdoreMix npm 包

AdoreMix 广播服务器的跨平台 npm 安装器、运行器和服务管理器。

把原本手工部署的 Qt/C++ 程序 + Node.js 协作脚本 + Qt 运行时 + 业务资源，
封装为 `npm install` 一键部署、自带开机自启和配置向导。

## 平台支持

| 平台 | 子包 | 状态 |
|---|---|---|
| Windows x64 | `@oxiaom/adoremix-win32-x64` | 已支持 |
| Linux x64 | `@oxiaom/adoremix-linux-x64` | 已支持 |
| Linux ARM (armv7/armhf) | `@oxiaom/adoremix-linux-arm` | 已支持 |
| Linux ARM64 (aarch64) | `@oxiaom/adoremix-linux-arm64` | 已支持 |
| macOS x64 (Intel) | `@oxiaom/adoremix-darwin-x64` | CI 编译中（需触发首次构建） |
| macOS ARM64 (Apple Silicon) | `@oxiaom/adoremix-darwin-arm64` | CI 编译中（需触发首次构建） |

MySQL / Redis / nginx 由用户自备，配置项写入 `config.ini`。

## 用户使用

```bash
# 全局安装（自动按当前平台选择子包）
npm install -g @oxiaom/adoremix

# 初始化工作目录（复制资源、生成 config.ini、安装 tts.js/find.js 等的依赖）
adoremix install

# 启动（前台）
adoremix start

# 后台运行
adoremix start --daemon

# 状态
adoremix status

# 日志
adoremix logs --follow

# 注册开机自启（Linux: systemd / Windows: Windows Service）
adoremix service install
adoremix service status

# 修改配置
adoremix config set Settings.LocalIP 192.168.1.100
adoremix config get Settings.ManagePort
adoremix config list
```

## 命令一览

| 命令 | 说明 |
|---|---|
| `adoremix version` | 打印版本和原生二进制路径 |
| `adoremix install` | 初始化工作目录 |
| `adoremix start [--daemon]` | 启动 |
| `adoremix stop` | 停止 |
| `adoremix restart` | 重启 |
| `adoremix status` | 状态 |
| `adoremix logs [-f]` | 日志 |
| `adoremix config get/set/list/init` | 配置管理 |
| `adoremix service install/uninstall/status` | 系统服务 |

## 工作目录

资源会被复制到一个稳定的工作目录（不在 `node_modules` 内）：

- Windows: `%PROGRAMDATA%\adoremix`（即 `C:\ProgramData\adoremix`）
- Linux root: `/opt/adoremix`
- Linux 用户态: `~/.local/share/adoremix`

`--workdir <path>` 可覆盖。

## Monorepo 开发

```bash
git clone <repo>
cd adoremix-npm
npm install
node workspaces/adoremix/bin/adoremix.js version
```

### 拆分原生包

把现有的 AdoreMix 部署产物拆到各子包：

```bash
# Windows：从 D:/zhuangyi/vbox/AdoreMIXMICV8 拆
node scripts/split-zip.js --only win32-x64

# Linux x64/ARM：从对应 zip 拆
node scripts/split-zip.js --only linux-x64
node scripts/split-zip.js --only linux-arm

# 全部 + dry-run 预览
node scripts/split-zip.js --dry-run
```

### 发布

```bash
# 1. 同步所有 package.json 版本号 + dry-run 预演
node scripts/publish-all.js --version 1.0.0 --dry-run

# 2. 实际发布（需要 npm login）
node scripts/publish-all.js --version 1.0.0
```

或通过 CI：
- 手动触发 `split-zip.yml` workflow，输入版本号和 zip URL
- 自动打 tag → 触发 `publish.yml` → 5 包发布到 npm

## 目录结构

```
adoremix-npm/
├── package.json
├── workspaces/
│   ├── adoremix/              # adoremix 主包
│   │   ├── bin/
│   │   ├── src/{cli,paths,install,logger}.js
│   │   ├── src/config/{ini,defaults,wizard,index}.js
│   │   ├── src/runner/{spawn,pid,signals,index}.js
│   │   ├── src/service/{windows,linux,index}.js
│   │   └── templates/{config.ini,adoremix.service,winservice.js}.tmpl
│   ├── win32-x64/             # @oxiaom/adoremix-win32-x64
│   ├── linux-x64/
│   ├── linux-arm64/
│   └── linux-arm/
├── scripts/
│   ├── split-zip.js
│   ├── publish-prepare.js
│   └── publish-all.js
└── .github/workflows/{split-zip,publish}.yml
```

## License

MIT
