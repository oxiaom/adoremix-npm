# AdoreMix 广播服务器使用文档

AdoreMix 是一套基于 Qt/C++ 的广播服务器系统，支持文字转语音（TTS）、实时喊话、定时广播、设备管理等功能。本 npm 包把它打包成跨平台一键部署的命令行工具，自带配置向导、开机自启和多 TTS provider 切换。

## 目录

- [快速开始](#快速开始)
- [系统要求](#系统要求)
- [安装](#安装)
- [初始化](#初始化)
- [启动与管理](#启动与管理)
- [开机自启](#开机自启)
- [网络配置](#网络配置)
- [TTS 文字转语音](#tts-文字转语音)
- [WebUI 切换](#webui-切换)
- [健康检查](#健康检查)
- [配置项详解](#配置项详解)
- [工作目录结构](#工作目录结构)
- [升级与卸载](#升级与卸载)
- [故障排查](#故障排查)
- [常见问题](#常见问题)

---

## 快速开始

```bash
# 1. 装 Node.js 18+（Ubuntu/Debian）
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo bash -
sudo apt install -y nodejs

# 2. 一键安装 AdoreMix（自动按平台拉对应二进制）
npm install -g @oxiaom/adoremix

# 3. 初始化（生成配置 + 部署资源）
adoremix install

# 4. 配置 IP（让其他设备能连）
adoremix config network

# 5. 启动
adoremix start --daemon

# 6. 浏览器访问
# http://<本机IP>:12080/
```

---

## 系统要求

| 平台 | 架构 | 状态 |
|---|---|---|
| Windows | x64 | ✅ |
| Linux | x64 | ✅ |
| Linux | ARM64 (aarch64) | ✅ |
| Linux | ARM (armv7/armhf) | ✅ |
| macOS | x64 (Intel) | ✅ |
| macOS | ARM64 (Apple Silicon) | ✅ |

**软件要求**：
- Node.js ≥ 16（推荐 20 LTS）
- 网络：能访问 npm registry（国内建议配 `npm config set registry https://registry.npmmirror.com`）

**外部服务**（业务运行需要，按需自备）：
- MySQL（业务数据）
- Redis（可选，缓存）
- ffmpeg（仅 TTS 用 edge provider 时需要）

---

## 安装

### 全局安装

```bash
npm install -g @oxiaom/adoremix
```

npm 会自动根据你的平台拉对应的原生二进制子包（40-70 MB），不需要手动选平台。

### 验证安装

```bash
adoremix version
```

输出示例：
```
adoremix CLI       v1.0.18
platform/arch      linux_arm64
platform pkg       @oxiaom/adoremix-linux-arm64
native root        /usr/lib/node_modules/@oxiaom/adoremix/node_modules/@oxiaom/adoremix-linux-arm64/native
native bin         AdoreMixV8.0.17_console_linuxarm64  (exists: yes)
```

---

## 初始化

```bash
adoremix install
```

这一步会：
1. 创建工作目录（默认 `/opt/adoremix` 或 `~/.local/share/adoremix`）
2. 复制原生二进制 + Qt 运行时 + 业务资源到工作目录
3. 设置二进制可执行权限（Linux）
4. 安装 Node.js 协作依赖（tts.js / find.js 等用到的 axios / ws / crypto-js 等）
5. 部署 TTS dispatcher（xf / minimax / edge 三选一）
6. 部署 WebUI（默认低码率版）
7. 生成默认 config.ini（首次会走配置向导）

**常用参数**：
```bash
adoremix install --workdir /custom/path    # 指定工作目录
adoremix install --force                    # 覆盖已有安装
adoremix install --skip-npm-install         # 跳过协作依赖安装
adoremix install --no-interactive           # 跳过配置向导，用默认值
```

**默认工作目录**：
- Linux root 用户：`/opt/adoremix`
- Linux 普通用户：`~/.local/share/adoremix`
- Windows：`C:\ProgramData\adoremix`
- macOS：`~/.local/share/adoremix`（或 `/opt/adoremix`，需 sudo）

### macOS 首次运行注意事项

macOS 二进制首次启动可能被 Gatekeeper 拦截，出现"无法验证开发者"提示。处理方法：

```bash
# 方案 1：移除 quarantine 属性（推荐）
xattr -d com.apple.quarantine /path/to/workdir/AdoreMixV8.0.17_console_darwin*

# 方案 2：系统偏好设置 → 安全性与隐私 → 允许打开
```

`adoremix start` 在 macOS 上完全可用（前台 + 后台）。`adoremix service install`（开机自启）暂不支持 macOS，建议用 `adoremix start --daemon` 配合 `~/Library/LaunchAgents/*.plist` 手动管理。

---

## 启动与管理

### 启动

```bash
# 前台启动（Ctrl+C 退出，看实时日志）
adoremix start

# 后台启动（推荐，nohup 风格）
adoremix start --daemon
```

### 停止 / 重启 / 状态

```bash
adoremix stop        # 停止（读 pidfile，SIGTERM）
adoremix restart     # 重启
adoremix status      # 查看状态（PID + CPU + 内存）
```

输出示例：
```
状态：运行中  PID=68493  CPU=0.0%  MEM=14 MB
```

### 查看日志

```bash
adoremix logs                # 看最后 50 行
adoremix logs --follow       # 实时跟随（Linux）
adoremix logs -n 100         # 看最后 100 行
adoremix logs --file <path>  # 指定日志文件
```

---

## 开机自启

### Linux（systemd）

```bash
# root 用户：注册系统服务（创建 adoremix 系统用户 + systemd unit）
sudo adoremix service install

# 普通用户：注册用户级服务（~/.config/systemd/user/）
adoremix service install

# 查看服务状态
adoremix service status
# 或：systemctl status adoremix

# 卸载服务
adoremix service uninstall
```

**普通用户开机自启注意**：需要 linger 才能在用户未登录时启动：
```bash
loginctl enable-linger $USER
```

### Windows（Windows Service）

```bash
adoremix service install
# 创建名为 AdoreMixService 的 Windows 服务

# 用 Windows 自带工具管理
sc query AdoreMixService
sc start AdoreMixService
sc stop AdoreMixService

# 卸载
adoremix service uninstall
```

---

## 网络配置

### 配置 IP（最重要）

广播服务需要让其他设备能连上来。默认 config.ini 里 `LocalIP=127.0.0.1`，**必须改成真实 IP**。

```bash
# 交互式（推荐，自动列本机网卡）
adoremix config network

# 直接指定 IP
adoremix config network --ip 192.168.1.100

# 非交互（CI 用，自动选第一个网卡）
adoremix config network --no-interactive
```

这一步会同时设置 `LocalIP` / `Meida_ip` / `Fip` 三个字段，并智能更新 `preurl`（如果是 IP 格式就同步改，CDN 域名不动）。

### 配置 CDN / 外网 URL

如果设备从外网访问，或者用了 CDN 加速：

```bash
# 交互式
adoremix config preurl

# 直接指定
adoremix config preurl --url http://cdn.your-domain.com/
```

`preurl` 是设备拉资源的基准 URL，默认 `http://<本机IP>:12080/`。

### 日志开关

```bash
adoremix config log --enable    # 开启（保存播放日志 + mp3，长期占磁盘）
adoremix config log --disable   # 关闭（默认）
```

---

## TTS 文字转语音

AdoreMix 支持三种 TTS provider，按需切换：

| Provider | 费用 | 依赖 | 适用场景 |
|---|---|---|---|
| **xf**（科大讯飞） | 约 4000 元/年 | Node.js | 商用，质量高 |
| **minimax** | 包月几十元 | Node.js | 性价比高 |
| **edge**（Microsoft Edge TTS） | **免费** | python3 + edge-tts + ffmpeg | 测试 / 低成本 |

### 配置 TTS

```bash
# 交互式向导（推荐）
adoremix tts config

# 或直接切换 provider
adoremix config set TTS.provider minimax
adoremix config set TTS.minimax_token sk-cp-xxxxxxxxxxxxx

# 讯飞（兼容 Qt 已有字段）
adoremix config set TTS.provider xf
adoremix config set Settings.ttsxfAPPID your_appid
adoremix config set Settings.ttsxfAPISecret your_apiSecret
adoremix config set Settings.ttsxfAPIKey your_apiKey

# Edge（免费，先装依赖）
adoremix config set TTS.provider edge
adoremix tts deps --fix    # 自动装 python3 + edge-tts + ffmpeg
```

### 测试 TTS

```bash
# 用当前 provider 生成测试 mp3
adoremix tts test "你好，这是 TTS 测试"

# 指定 voice + 音量 + 语速
adoremix tts test "你好" --voice yunxi --volume 80 --speed 60
```

生成的 mp3 在 `<工作目录>/tty/_cli_test.mp3`。

### 查看 voice 列表

```bash
adoremix tts voices
```

输出示例（19 个标准 voice 短名 + 当前 provider 的映射）：
```
xiaoxiao     → female-tianmei               晓晓 - 女声，自然亲切
yunxi        → male-qn-jingying             云希 - 男声，年轻活力
yunjian      → male-qn-jingying             云健 - 男声，成熟稳重
...
```

### 检查依赖

```bash
adoremix tts deps           # 检查当前 provider 依赖
adoremix tts deps --fix     # 自动修复（apt install / pip install / npm install）
```

### 列出所有 provider

```bash
adoremix tts list
```

输出示例：
```
★ 当前 minimax  MiniMax    MiniMax HTTP API TTS
          费用: 包月几十元
          凭证: ✓  依赖: ✓

   xf       讯飞         科大讯飞 WebSocket TTS
          费用: 约 4000 元/年
          凭证: ✗ 缺  依赖: ✓

   edge     Edge TTS   Microsoft Edge TTS（python）
          费用: 免费
          凭证: ✓  依赖: ✗ 缺
```

### Qt/C++ 调用方式（开发者参考）

Qt 主程序通过 `QProcess` 调用：
```
node tts.js <volume> <speed> <voice_short> <mp3_out> <txt_path>
```

dispatcher（`tts.js`）会读 `config.ini [TTS].provider` 自动路由到对应实现。**Qt 代码完全不用改**，切 provider 只改 config.ini。

---

## WebUI 切换

AdoreMix 内置两个 WebUI 版本：

| 版本 | 配置 | 适用场景 |
|---|---|---|
| **low**（默认） | 16k stereo / 32kbps | WiFi 音响、互联网环境（省流量） |
| **high** | 44.1k stereo / 64kbps | 局域网、音质要求高 |

### 切换 UI

```bash
# 交互式
adoremix config webui

# 直接指定
adoremix config webui --variant high
adoremix config webui --variant low
```

切换时**只替换 UI 文件**（`index.html` + `assets/` + `js/`），**用户上传的 mp3 等数据完整保留**。

切换后重启生效：
```bash
adoremix restart
```

---

## 健康检查

```bash
adoremix doctor           # 全面检查
adoremix doctor --fix     # 检查 + 自动修复
```

检查项：
- ✅ Node.js 版本
- ✅ 平台子包加载
- ✅ 二进制存在 + 可执行权限
- ✅ 动态库依赖完整（`ldd` 扫描）
- ✅ config.ini 存在
- ✅ .Adore.db 数据库
- ✅ 服务运行状态
- ✅ TTS provider 依赖（凭证 / npm 包 / python / ffmpeg）

`doctor --fix` 自动修复能力（缺什么自动装什么）：
- 🔧 系统库：`apt install` libdouble-conversion3 / libpcre2-16-0 等
- 🔧 **ICU 70 跨发行版兜底**：Debian 12 / 树莓派 OS / Armbian 缺 libicu70（Ubuntu 22.04 编译的库版本不匹配）时，自动从 Ubuntu 官方源下载对应架构 .deb 安装（arm64 / armhf / x64 全覆盖）
- 🔧 **lame**：二进制转码 mp3 必需的外部命令，自动 `apt install lame`
- 🔧 **edge TTS 三连坑**：python3-pip 缺失自动装；Debian 12 PEP 668 自动加 `--break-system-packages`；pip 默认走清华镜像避免下载损坏
- 🔧 dispatcher 协作依赖（ini 等 node 包）：自动 `npm install`（默认走 npmmirror 镜像）
- 🔧 TTS provider 的 npm 包（crypto-js/ws/log4node）：自动装

输出示例：
```
=== AdoreMix 健康检查 ===
✓ Node.js v20.20.2
✓ 平台子包 @oxiaom/adoremix-linux-arm64
✓ 工作目录二进制 AdoreMixV8.0.17_console_linuxarm64
✓ 动态库依赖完整
✓ config.ini
✓ .Adore.db (146.0 KB)
✓ 服务运行中 PID=70210

=== TTS Provider 检查 ===
当前 provider: minimax
✓ minimax provider 所有依赖就绪

🎉 全部正常
```

---

## 配置项详解

配置文件在工作目录的 `config.ini`，用标准 INI 格式。可以用命令改，也可以直接编辑。

### 常用命令

```bash
adoremix config list                       # 列出全部
adoremix config get Settings.LocalIP       # 读单项
adoremix config set Settings.LocalIP 1.2.3.4   # 写单项
adoremix config init --force               # 重生成默认配置
```

### 关键配置项

#### [Settings] 段

| 键 | 说明 | 默认值 |
|---|---|---|
| `LocalIP` | 本机对外 IP（**必须改**） | 127.0.0.1 |
| `Meida_ip` | 媒体服务 IP（跟随 LocalIP） | 127.0.0.1 |
| `Fip` | 文件服务 IP（跟随 LocalIP） | 127.0.0.1 |
| `preurl` | 设备拉资源基准 URL | http://127.0.0.1:12080/ |
| `isopenrizhi` | 日志开关（true 会保存 mp3 + 播放日志） | false |
| `webui` | WebUI 版本（low / high） | low |
| `wbport` | web 后台端口 | 6082 |
| `DataPort` | 媒体数据端口 | 6002 |
| `ManagePort` | 管理端口 | 6007 |
| `task_ip` | MySQL 主机 | 127.0.0.1 |
| `sqltask_port` | MySQL 端口 | 3307 |
| `task_username` | MySQL 用户名 | root |
| `task_passwd` | MySQL 密码 | (空) |
| `basename` | MySQL 数据库名 | adore |
| `EnableRedis` | 启用 Redis | false |
| `RedisIP` / `RedisPort` / `RedisAUTH` | Redis 连接 | 127.0.0.1 / 6379 / (空) |
| `ttsxfAPPID` / `ttsxfAPISecret` / `ttsxfAPIKey` | 讯飞 TTS 凭证 | (空) |

#### [TTS] 段

| 键 | 说明 |
|---|---|
| `provider` | TTS provider（`xf` / `minimax` / `edge`） |
| `minimax_token` | MiniMax API token |

#### [listener] 段（QtWebApp HTTP 服务）

| 键 | 说明 | 默认值 |
|---|---|---|
| `port` | HTTP 服务端口（**网页访问**） | 12080 |
| `minThreads` / `maxThreads` | 线程池 | 100 / 3000 |
| `maxRequestSize` | 单请求最大 | 16 MB |
| `maxMultiPartSize` | 文件上传最大 | 100 MB |

#### 端口清单

| 端口 | 用途 |
|---|---|
| **12080** | HTTP API + 网页（浏览器访问） |
| 6082 | web 后台 |
| 12083 | cutehttpd 服务 |
| 6002 | 媒体数据端口 |
| 6007 | 管理端口 |
| 6036 | 数据接收端口 |
| 6000/6001 | 网络交叉端口 |
| 6003/6006 | 推流端口 |

---

## 工作目录结构

```
/opt/adoremix/                      ← 工作目录（root 用户）
├── AdoreMixV8.0.17_console_linux*  ← 主二进制
├── config.ini                      ← 配置文件
├── .Adore.db                       ← SQLite 数据库（默认数据）
├── tts.js                          ← Qt 调用入口（wrapper）
├── find.js / findsc.js             ← Node 协作脚本
├── adoremix-tts/                   ← TTS dispatcher
│   ├── tts.js                      ← dispatcher 主逻辑
│   ├── voice-mapping.js            ← 19 个标准 voice 短名
│   └── providers/
│       ├── xf.js                   ← 讯飞实现
│       ├── minimax.js              ← MiniMax 实现
│       └── edge.js                 ← Edge TTS 实现
├── etc/
│   ├── docroot/                    ← WebUI 静态资源
│   │   ├── index.html
│   │   ├── assets/
│   │   ├── js/
│   │   └── mp3/                    ← 用户上传的 mp3
│   ├── templates/                  ← HTML 模板
│   └── ssl/                        ← SSL 证书
├── conf/                           ← nginx 配置模板
├── html/                           ← 错误页等
├── lib/                            ← Qt + 第三方 .so 依赖
├── platforms/                      ← Qt platform plugins
├── sqldrivers/                     ← SQL 驱动（含 sqlitecipher）
├── bearer/ iconengines/ imageformats/ mediaservice/ audio/   ← Qt plugins
├── translations/                   ← Qt 翻译文件
├── qt.conf                         ← Qt plugins 路径提示
├── var/                            ← PID + 运行日志
│   ├── app.pid
│   └── app.log
├── logs/                           ← 服务日志（systemd 模式）
├── tty/                            ← TTS 临时音频
├── dmp/                            ← 崩溃转储
├── temp/                           ← 临时文件
└── package.json                    ← Node 协作依赖
```

---

## 升级与卸载

### 升级

```bash
# 升级 npm 包
npm update -g @oxiaom/adoremix

# 重新部署（保留 config.ini 和用户数据）
adoremix install --force

# 重启
adoremix restart
```

`--force` 会覆盖二进制和资源，但**不会覆盖 config.ini**（已存在时保留）。

### 卸载

```bash
# 1. 停服务
adoremix stop
adoremix service uninstall   # 如果注册了系统服务

# 2. 卸 npm 包
npm uninstall -g @oxiaom/adoremix

# 3. 删工作目录（可选，会删所有用户数据）
sudo rm -rf /opt/adoremix
```

---

## 故障排查

### 服务起不来

```bash
# 1. 跑健康检查
adoremix doctor --fix

# 2. 看日志
adoremix logs --follow
# 或前台启动看实时输出
adoremix start
```

### 浏览器打不开（12080 端口）

```bash
# 1. 检查服务在跑
adoremix status

# 2. 检查端口监听
ss -tlnp | grep 12080

# 3. 检查防火墙
sudo ufw allow 12080/tcp   # Ubuntu
```

### 缺动态库

v1.0.3+ 已经把所有依赖打包进 `lib/`，正常情况不会缺。如果遇到：

```bash
adoremix doctor --fix    # 自动识别 + apt install
```

### TTS 不工作

```bash
# 1. 检查 provider 依赖
adoremix tts deps

# 2. 自动修复
adoremix tts deps --fix

# 3. 测试
adoremix tts test "你好"

# 4. 看 TTS 日志（dispatcher 输出到 stdout）
# 前台启动看：adoremix start
```

### 切换 TTS provider 后 Qt 不生效

确认 config.ini 改对了：
```bash
adoremix config get TTS.provider
```

dispatcher 读 config.ini 的 `[TTS].provider` 字段，不读命令行参数。改完不用重启 Qt（每次 Qt 调 `node tts.js` 都会重新读 config.ini）。

### 切换 WebUI 后 mp3 没了

不会发生。v1.0.18+ 只替换 UI 文件（index.html / assets/ / js/），完整保留 `mp3/` 目录。如果遇到，检查版本：
```bash
adoremix version   # 应 ≥ 1.0.18
```

---

## 常见问题

### Q: 必须装 Node.js 吗？

是的。AdoreMix 的 CLI 工具和 TTS dispatcher 都是 Node.js 写的。但**客户机器只需要装 Node.js，不需要装 Qt / python / 编译器**（除非用 edge TTS 才需要 python）。

### Q: 可以不用 npm 吗？

可以。从 GitHub release 下载对应平台的 tarball，解压到工作目录，直接跑二进制。但失去 CLI 的便利（配置向导 / 开机自启 / doctor 等）。

### Q: macOS 支持吗？

**支持**（v1.0.19+）。`npm install -g @oxiaom/adoremix` 在 macOS Intel（x64）和 Apple Silicon（arm64）上都可正常安装运行。首次启动若被 Gatekeeper 拦截，运行 `xattr -d com.apple.quarantine <二进制路径>` 即可。

注意：macOS 上 `adoremix service install`（开机自启）暂未实现，用 `adoremix start --daemon` 替代。

### Q: 多个 AdoreMix 实例能共存吗？

可以。用不同工作目录：
```bash
adoremix install --workdir /opt/adoremix-2
adoremix start --workdir /opt/adoremix-2
```

注意改 config.ini 里的端口避免冲突。

### Q: TTS 哪个 provider 最好？

- **质量最高**：xf（讯飞）
- **性价比**：minimax（包月几十，质量接近讯飞）
- **免费测试**：edge（Microsoft Edge TTS，质量不错，但需要 python）

建议：先用 edge 测试跑通，正式部署用 minimax。

### Q: config.ini 改了不生效？

大部分配置改完要重启：
```bash
adoremix restart
```

TTS provider 切换**不需要重启**（dispatcher 每次调用都重新读 config.ini）。

---

## 联系与反馈

- GitHub: https://github.com/oxiaom/adoremix-npm
- npm: https://www.npmjs.com/package/@oxiaom/adoremix
- 问题反馈：GitHub Issues

---

## 版本历史

- **v1.0.18**: WebUI 切换保留用户数据（mp3 等）
- **v1.0.17**: WebUI 多版本（low 16k / high 44.1k）
- **v1.0.15**: TTS dispatcher 完整版（xf / minimax / edge + CLI 命令）
- **v1.0.10**: doctor 集成 TTS 检查
- **v1.0.7**: 新增 doctor 健康检查命令
- **v1.0.6**: 日志开关默认 false（避免占磁盘）
- **v1.0.5**: config network / preurl 子命令
- **v1.0.3**: 完整依赖打包（libdouble-conversion + libpcre2-16 + .Adore.db）
- **v1.0.0**: 首版发布（4 平台 + CLI + systemd / Windows Service）
