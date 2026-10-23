# AdoreMix 广播服务器使用文档

AdoreMix 是一套基于 Qt/C++ 的广播服务器系统，支持文字转语音（TTS）、实时喊话、定时广播、设备管理等功能。本 npm 包把它打包成跨平台一键部署的命令行工具，自带配置向导、开机自启和多 TTS provider 切换。

> ✅ **软件开源 MIT 协议，自行部署完全免费商用；仅当选择中国电信云服务托管时，才产生每月 1.8~3.8 元的运营成本费。**
>
> 完整说明（含托管服务与发票）见下方 [开源与收费说明](#开源与收费说明) 章节。

## 目录

- [开源与收费说明](#开源与收费说明)

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
- [可选组件](#可选组件)（NGINX / 配置管理 UI / Audio8 TTS / MP3Server）
- [配置项详解](#配置项详解)
- [工作目录结构](#工作目录结构)
- [升级与卸载](#升级与卸载)
- [故障排查](#故障排查)
- [常见问题](#常见问题)

---

## 开源与收费说明

> ✅ **软件开源 MIT 协议，自行部署完全免费商用；仅当选择中国电信云服务托管时，才产生每月 1.8~3.8 元的运营成本费。**

本项目服务端、客户端代码已在 GitHub 开源，采用 MIT 开源协议。

### 1. 软件本身：永久免费，无版权费用

任何个人、机构、企事业单位、学校均可自由使用、商用，支持自行下载源码、独立安装部署，
**无授权费、无功能限制、无版权约束**。

### 2. 可选托管服务（按需选择，非强制）

如需免去自建服务器、运维维护的工作，可选择由中国电信提供的云服务托管。

- 仅收取**非盈利性质**的基础运营成本费：**1.8 元 / 月 ～ 3.8 元 / 月**
- ⚠️ 此费用为非盈利性质的云托管服务费，**不是软件授权费**
- 不使用该托管方案（自行部署）则**无需支付这笔费用**

### 3. 发票说明

若办理电信托管服务产生缴费，可凭缴费记录联系我们申请开具发票。

---

## 快速开始

### 方式一：一条命令（推荐）

```powershell
# Windows PowerShell
powershell -NoProfile -ExecutionPolicy Bypass -Command "iwr https://cdn.jsdelivr.net/gh/oxiaom/adoremix-npm@main/scripts/install.ps1 -OutFile $env:TEMP\adoremix-install.ps1 -UseBasicParsing; & $env:TEMP\adoremix-install.ps1"
```

```bash
# Linux
curl -fsSL https://cdn.jsdelivr.net/gh/oxiaom/adoremix-npm@main/scripts/install.sh | bash
```

脚本会自动：检测/安装 Node.js 18+（用户目录、无需 root）→ 配置 npm 全局目录 → 安装 AdoreMix → 初始化工作目录 → 自动选择网卡 IP → `adoremix doctor` 体检 → 后台启动（root + systemd 或 Windows 管理员模式下自动注册开机自启）。

可选环境变量：`ADOREMIX_VERSION`（默认 latest）、`ADOREMIX_SKIP_START=1`、`ADOREMIX_NPM_REGISTRY`、`ADOREMIX_NODE_MAJOR`（默认 20）、`ADOREMIX_NO_SERVICE=1`。

### 方式二：手动安装

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
| Windows | x64 | ✅（需英文安装路径，见下） |
| Linux | x64 | ✅ |
| Linux | ARM64 (aarch64) | ✅ |
| Linux | ARM (armv7/armhf) | ✅ |
| macOS | x64 (Intel) | ❌（已放弃，仅支持 Apple Silicon） |
| macOS | ARM64 (Apple Silicon) | ✅ |

### Linux 发行版兼容性（v1.0.27+）

Linux 包为**自包含**构建：Qt 5.15.2 + ICU 67 等全部依赖捆绑在 `lib/`（不依赖系统 Qt/ICU），只要求系统 **glibc ≥ 2.29**：

| 发行版 | 版本 | glibc | 支持 |
|---|---|---|---|
| Ubuntu | 20.04+ | 2.31+ | ✅ |
| Ubuntu 优麒麟 | 20.04+ | 2.31+ | ✅ |
| Debian | 11+ | 2.31+ | ✅ |
| Rocky / AlmaLinux | 9 | 2.34 | ✅ |
| 银河麒麟 / 统信 UOS | 22.04 级 | 2.31+ | ✅ |
| 统信 UOS 20 / 龙蜥 Anolis 8 / openEuler 20.03 | — | 2.28 | ⚠️ 暂不支持（glibc 差 0.01，后续版本适配） |
| CentOS 7 / 中标麒麟 | 7 | 2.17 | ❌（Qt 5.15 本身要求更高，无法支持） |

> **安装目录不能含中文等非 ASCII 字符**（Windows/Linux 通用）：AdoreMix 在含中文路径下运行会出问题。Windows 用 `C:\adoremix`、Linux 用 `/opt/adoremix` 这类纯英文路径。`adoremix doctor` 会检测并提示。

**软件要求**：
- Node.js ≥ 16（推荐 20 LTS）
- 网络：能访问 npm registry（国内建议配 `npm config set registry https://registry.npmmirror.com`）

**外部服务**（业务运行需要，按需自备）：
- **MySQL（可选）**：仅 `dbk=1` 时使用；默认 `dbk=3` 使用内置 SQLite（`.Adore.db`），无需额外部署
- **Redis：已移除**，不再需要（服务端代码已删除全部 Redis 逻辑）
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

## 设备在线判定（重要）

服务端每 **5 秒**向每台设备发送心跳 `OKOK`，设备会立即回包（4 字节 `OKOK`）。任意回包都会刷新“最后活跃时间”。

| 网络环境 | 建议 `DevOfflineTimeout` |
|---|---|
| 局域网（<5ms） | 15 秒 |
| 普通公网（50~200ms） | 25 秒（默认） |
| 弱网 / 4G / 高丢包 | 30~40 秒 |

| 场景 | 判定时间 |
|---|---|
| 设备正常断开（TCP FIN/RST） | 立即 |
| 设备断电 / 断网（无 FIN） | 静默超过 `DevOfflineTimeout`（默认 25 秒，最慢再加 5 秒轮询） |
| 公网高延迟/丢包 | 建议调大 `DevOfflineTimeout`（20~30），避免误判 |

```ini
[Settings]
DevOfflineTimeout=25   ; 秒，局域网可设 15
```

> 采用类似 MQTT 的 keepalive 模型：心跳间隔 5s，超时阈值 = 若干个心跳周期；TCP 半开（断电无 FIN）时，只有“多久没收到设备数据”才能可靠判断真实在线状态。

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

## 可选组件

以下是**可选安装**的组件，不装不影响 AdoreMix 主服务。

- NGINX 静态加速 / 设备配置管理 UI / Audio8 TTS：**仅 Linux**（依赖 systemd）
- MP3Server 音频分块服务：**全平台**（Windows / Linux x64 / ARM64 / ARM / macOS）

### NGINX 静态加速

媒体文件（mp3 等）走 nginx 直接出，减轻 AdoreMix 设备服务压力。端口 9876，开机自启。

```bash
adoremix nginx install      # 安装并配置（preurl 自动改为 http://IP:9876/）
adoremix nginx uninstall    # 卸载（preurl 还原到原 12080 端口）
adoremix nginx status       # 查看状态
```

- 挂载静态目录 `etc/docroot`
- mp3/wav/m4a 等媒体文件加 30 天缓存头，js/css/图片 7 天缓存
- 安装完成后 `Settings.preurl` 自动改为 `http://<本机IP>:9876/`
- 需 root，会自动 `apt/dnf install nginx`

### 设备配置管理 UI（config-manager）

Web 界面管理设备，端口 9877，开机自启。三个功能页：**配置 IP 地址 / 修改 config.ini / 查看运行日志**。

```bash
adoremix config-manager install      # 安装（检测 python3 + Flask，自动装）
adoremix config-manager uninstall    # 卸载
adoremix config-manager status       # 查看状态
```

- 访问：`http://<本机IP>:9877/`
- 需 root + python3；Flask 缺失时自动 `python3 -m pip install flask`
- 修改的 `config.ini` 指向 AdoreMix 工作目录（`ADOREMIX_WORKDIR` 环境变量）

### Audio8 TTS（本地离线 TTS，自动安装）

基于 [Audio8-AI/Audio8_TTS](https://github.com/Audio8-AI/Audio8_TTS)（0.1B 参数、Apache 2.0、支持中文，0.1B INT8 ONNX CPU 推理）。在本机（Linux）执行安装，自动解包源码 + 创建 venv + 装依赖 + 起 systemd 服务。**Windows/macOS 不支持**（依赖 systemd），需在 Linux 主机上跑。

```bash
# 1. 装运行时（源码内置离线 tarball + venv + systemd，几分钟）
adoremix audio8 install

# 2. 下模型（核心 ~423MB，默认走 hf-mirror.com 国内可达；自动生成默认音色）
adoremix audio8-fetch-model

# 3. 重启生效 + 检查
systemctl restart audio8-tts
adoremix audio8 status            # 健康检查（GET /api/health）

# 卸载
adoremix audio8 uninstall
```

- 端口：**8024**；健康检查 `GET /api/health`；API 文档 `http://127.0.0.1:8024/docs`
- 模型源默认 `hf-mirror.com`（国内可达）→ `huggingface.co` 兜底，单文件自动切换
- **自托管模型**：把模型 10 个文件放到自己服务器后 `adoremix audio8-fetch-model https://你的域名/模型目录/`，或设环境变量 `ADOREMIX_AUDIO8_MODEL_URL`（模型数据文件全平台通用）
- 模型目录：`~/audio8/onnx_runtime_0_1b_int8/model/`（与 systemd 单元一致，勿手工挪动）
- **默认音色**：Audio8 无预置音色库，fetch-model 会自动把模型内置参考音物化为 `default` 音色，开箱即用
- **声音克隆**（可选）：0.5~30 秒参考音频 + 转写文本，`POST /api/voices/register`；需额外下载注册子模型（+396MB）：`adoremix audio8-fetch-model --registration`
- 服务端返回 WAV，AdoreMix 自动用 ffmpeg 转 MP3 推给设备（ffmpeg 必需）
- 推理线程数按 CPU 核数自动设置（`ARKTTS_THREADS`）
- 适配发行版：Debian/Ubuntu（apt）、RHEL/CentOS/AlmaLinux（dnf/yum）、Alpine（apk）、Arch（pacman）
- 内存占用：模型加载后约 1.8GB，建议 ≥3GB RAM 的机器安装
- install 结束自动写本地 config.ini：`[TTS] provider=audio8, audio8_base_url=http://127.0.0.1:8024`

### ⚠️ 性能实测（2026-10，114 干净机器端到端验证）

CPU int8 推理速度取决于 CPU 核数与单核性能：

| 硬件 | 实测 | 结论 |
|---|---|---|
| 2 核 Celeron G4900 @3.1GHz | 生成 1 秒音频约需 15 秒（RTF≈15×） | 定时广播预生成可用，实时喊话不建议 |
| 4 核及以上现代 CPU | 预计 RTF 3~6× | 定时广播流畅，短句接近可用 |

- 全链路已实测通过：install → fetch-model → 默认音色 → 合成 MP3（含 WAV→MP3 转码）
- 冷启动加载模型约 20~30 秒；长文本按比例耗时，建议广播文本控制在 100 字内
- 弱 CPU 机器建议：定时广播提前生成，或继续用 xf（讯飞）/edge（微软云）云端 TTS

### MP3Server 音频分块服务（选装，全平台）

设备端按 TCP 协议分块拉取 MP3 文件的服务（原 `Adore_mix2/MP3Server` 的 Node 重实现，线协议完全一致）。
与 AdoreMix 主包同一套分发，**无需编译**，Windows / Linux x64 / ARM64 / ARM / macOS 通用。

```bash
adoremix mp3server install     # 注册系统服务（Linux systemd / Windows 服务），开机自启
adoremix mp3server status      # 检查服务 + 端口 + docroot
adoremix mp3server uninstall   # 卸载服务（config 与媒体文件保留）
adoremix mp3server serve       # 前台运行（调试用）
```

- **默认端口 6665**，可在 `config.ini` 修改：`[MP3Server] port=6665`
- **docroot** 默认 = 工作目录下 `etc/docroot`（与 nginx 选装共用同一份媒体目录），可用 `[MP3Server] docroot=` 指定其它目录

#### 修改端口 / 修改媒体目录

两项都改 `config.ini` 后**重启服务**生效，不需要重装：

```bash
# 改端口（例：6665 → 7000）
adoremix config set MP3Server.port 7000
systemctl restart adoremix-mp3server
adoremix mp3server status        # 确认新端口在监听

# 改媒体目录（例：指向独立磁盘 /data/mp3）
adoremix config set MP3Server.docroot /data/mp3
systemctl restart adoremix-mp3server
adoremix mp3server status        # 会显示该目录下的文件数

# 查看当前值
adoremix config get MP3Server.port
adoremix config get MP3Server.docroot
```

⚠️ 注意事项：

1. **设备侧要同步改**：MP3Server 由设备主动连 TCP，设备配置里指向的端口/地址必须与服务端一致，否则改完服务端设备连不上。
2. **必须重启服务**：端口和目录都在服务启动时从 `config.ini` 读取，改配置不会热生效。
3. **目录权限**：服务以安装用户运行（root 安装即 root），自定义 docroot 需该用户可读，否则拉流报 `File not found or cannot open`。
4. **文件缓存**：音频起始位置按文件路径缓存，同名文件被替换后建议重启服务刷新。
5. `docroot` 修改不影响 nginx 选装（nginx 有自己的 `etc/docroot` 路径）；两边要一致时请分别配置。
- **协议**（与设备端约定）：
  1. 设备连接后发一行相对路径（如 `music/a.mp3\n`）
  2. 服务端回一行音频字节数（自动跳过 ID3v2 标签，从第一个 MP3 帧开始算）`\n`
  3. 设备发一行字节数 N（≤1MB），服务端回 N 字节音频；重复
  4. 读到文件尾服务端回 `close\n` 并断开；设备可随时发 `close` 主动断开
- **极老固件兼容**：早期版本首包返回 `well\n`（不带文件大小）。若现场老设备连上后不拉流，设置
  `adoremix config set MP3Server.legacy_handshake true` 并 `systemctl restart adoremix-mp3server`（其余流程不变）
- 路径会做安全校验（禁止 `../` 和绝对路径，禁止越出 docroot）
- 空闲 10 分钟自动断开；单次请求上限 1MB（与原版一致）
- 日志：`<工作目录>/logs/mp3server.log`（systemd 下也可 `journalctl -u adoremix-mp3server -f`）

> 与 nginx（9876 HTTP 静态）的区别：MP3Server 是**设备主动分块拉流**的老协议（TCP 行协议），
> 适用于只支持该协议的老设备；新设备走 nginx HTTP 即可。

### 多机部署方案
- 内存 ≥3GB 的 Linux 主机：本机装 Audio8（全离线，不依赖云 TTS）
- 小内存/弱 CPU 机器（如 ARM 盒子）：不装 Audio8，`config.ini` 的 `audio8_base_url` 指向局域网内已装的 Audio8 机器（如 `http://192.168.1.114:8024`）
- 都不装时用默认的 xf（讯飞）或 edge（微软云）TTS，无需本地模型

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
| `DevOfflineTimeout` | 设备静默多少秒判定离线（局域网 15，公网 25~40） | 25 |
| `webui` | WebUI 版本（low / high） | low |
| `wbport` | web 后台端口 | 6082 |
| `DataPort` | 媒体数据端口 | 6002 |
| `ManagePort` | 管理端口 | 6007 |
| `task_ip` | MySQL 主机 | 127.0.0.1 |
| `sqltask_port` | MySQL 端口 | 3307 |
| `task_username` | MySQL 用户名 | root |
| `task_passwd` | MySQL 密码 | (空) |
| `basename` | MySQL 数据库名 | adore |
| `dbk` | 数据库类型：3=SQLite（默认）/ 1=MySQL | 3 |
| ~~`EnableRedis`~~ / ~~`RedisIP`~~ / ~~`RedisPort`~~ / ~~`RedisAUTH`~~ | **已废弃**（Redis 代码已移除，配置被忽略） | — |
| `ttsxfAPPID` / `ttsxfAPISecret` / `ttsxfAPIKey` | 讯飞 TTS 凭证 | (空) |

#### [TTS] 段

| 键 | 说明 |
|---|---|
| `provider` | TTS provider（`xf` / `minimax` / `edge`） |
| `minimax_token` | MiniMax API token |

#### [MP3Server] 段（选装 MP3Server 音频分块服务）

| 键 | 说明 | 默认值 |
|---|---|---|
| `port` | MP3Server 监听端口（改后需重启服务，设备侧同步修改） | 6665 |
| `docroot` | 媒体文件根目录（空 = 工作目录 `etc/docroot`） | (空) |
| `legacy_handshake` | 极老设备固件兼容：首包回 `well\n` 而不是文件大小 | false |

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
| 6665 | MP3Server 分块推流（选装，可改 `[MP3Server] port`） |
| 9876 | nginx 静态加速（选装，`adoremix nginx install`） |
| 9877 | 设备配置管理 UI（选装，`adoremix config-manager install`） |
| 8024 | Audio8 本地 TTS（选装，`adoremix audio8 install`） |

> 设备内部通信端口与协议不在公开文档中说明，请在私有部署环境中按需配置防火墙。
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
│   ├── svc.log / svc.err           ← 主服务输出
│   └── mp3server.log               ← MP3Server 输出（装了选装时）
├── mp3server-winservice.js         ← Windows 服务包装脚本（仅 Windows 装了 MP3Server）
├── tty/                            ← TTS 临时音频
├── dmp/                            ← 崩溃转储
├── temp/                           ← 临时文件
└── package.json                    ← Node 协作依赖
```

---

## 升级与卸载

### 升级

```bash
# 1. 升级主包（务必用官方源：npmmirror 子包同步有延迟）
npm install -g @oxiaom/adoremix@latest --registry https://registry.npmjs.org

# 2. 检查版本一致性（主包与平台子包必须是同一版本）
adoremix version
```

如果 `adoremix version` 提示「平台子包版本不一致」（例如主包 1.0.67、子包 1.0.64），说明 npm 复用了缓存的旧子包：

```bash
# 一键修复（按主包版本用官方源重装子包）
adoremix doctor --fix

# 或手动指定子包版本（Linux x64 示例，其他平台换成对应子包名）
npm install -g @oxiaom/adoremix@1.0.67 @oxiaom/adoremix-linux-x64@1.0.67 \
  --registry https://registry.npmjs.org --prefer-online --force
```

然后刷新工作目录里的二进制和资源：

```bash
# 覆盖二进制/资源，config.ini、.Adore.db、docroot 媒体文件都会保留
adoremix install --force

# 重启主服务（systemd 托管时自动走 systemctl）
adoremix restart

# 选装组件按需重启（代码随主包升级，重启即生效）
systemctl restart adoremix-mp3server   # 装了 MP3Server
systemctl restart audio8-tts          # 装了 Audio8
systemctl restart nginx               # 装了 nginx 加速

# 最终体检
adoremix doctor
```

`--force` 会覆盖二进制和资源，但**不会覆盖 config.ini**（已存在时保留）。

平台子包名对照：`@oxiaom/adoremix-win32-x64`、`-linux-x64`、`-linux-arm64`、`-linux-arm`、`-darwin-arm64`。

> 回滚到指定版本：把上面命令里的 `@latest` 换成 `@1.0.60` 即可，同样需要 `adoremix install --force` 刷新工作目录。

### 卸载

推荐用内置命令（自动停服务 + 卸系统服务）：

```bash
# 只卸服务，保留工作目录（config.ini / .Adore.db / docroot 媒体文件都在）
adoremix uninstall

# 连工作目录一起删（不可恢复，会删所有配置和用户数据）
adoremix uninstall --purge

# 最后卸 npm 包
npm uninstall -g @oxiaom/adoremix
```

选装组件需要单独卸（主包卸载不会自动处理）：

```bash
adoremix mp3server uninstall
adoremix audio8 uninstall
adoremix nginx uninstall
adoremix config-manager uninstall
```

> `adoremix uninstall --purge` 等价于以前的「停服务 + 删 /opt/adoremix」手工步骤；
> 反复做干净环境测试时用 `--purge` 最省事。

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

### Windows 启动即崩（0xc000007b / 64 位 exe + 32 位 Qt DLL）

v1.0.22 及更早的 win32-x64 包内 `AdoreMixV8X.exe` 是 64 位，但 Qt5*.dll 是 32 位 Qt 5.9.0，64 位 exe 加载 32 位 DLL → 启动即崩。**v1.0.23 起已统一为 64 位 Qt 5.15.2。** 老版本升级：

```bash
npm install -g @oxiaom/adoremix@latest
adoremix install --force     # 刷新工作目录新二进制（不覆盖 config.ini）
adoremix restart
```

### Linux Ubuntu 运行中崩溃（库不兼容）

多为系统库版本不兼容，最典型三种：

- **libstdc++ 太旧**：捆绑 Qt 5.15 需 `GLIBCXX_3.4.29`（GCC 9 时代符号，Ubuntu 20.04+），太旧会在运行中 undefined symbol 崩溃（"启动一会儿就崩"）。
- **glibc 太旧**：需 `GLIBC_2.34`（二进制在 Ubuntu 22.04 编译，Ubuntu < 22.04 直接加载失败）。
- **缺 libicu70 / 其他库**：Debian 12 / 树莓派 OS / Armbian 等 apt 只有 libicu72，缺 libicu70。

排查：

```bash
adoremix doctor        # v1.0.24 起逐项核对所有依赖版本（libstdc++/glibc/Qt 捆绑/缺库）
adoremix doctor --fix  # 自动装 ICU70 + apt 可装缺库
```

若仍崩，抓启动错误回传：

```bash
dmesg | tail
# 或前台跑看 stderr：
./AdoreMixV8.0.17_console_linuxx64 config.ini
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

### MP3Server（选装）

**设备连不上 / 拉流超时**

```bash
adoremix mp3server status                  # 服务 + 端口 + docroot 一次看全
ss -ltnp | grep 6665                       # 确认端口在监听
journalctl -u adoremix-mp3server -n 50     # 服务日志
```

常见原因：端口被改但设备侧没同步、防火墙未放行端口、消费端连的 IP 不对。

**拉流报 `error: File not found or cannot open`**

- 设备发的是**相对于 docroot 的路径**（`music/a.mp3`，不是 `/data/music/a.mp3`）
- 检查服务运行用户对文件是否有读权限：`ls -l <docroot>/<路径>`
- `docroot` 配置与文件实际位置不一致（`adoremix config get MP3Server.docroot`）

**换了同名文件但播放的还是旧内容**

MP3 起始帧位置按文件路径缓存，替换文件后重启服务：`systemctl restart adoremix-mp3server`。

### Audio8（选装）

**服务起不来 / 600 秒内未就绪**

```bash
adoremix doctor --fix                 # 会检查单元/venv/模型/音色/内存
journalctl -u audio8-tts -n 50
```

最常见原因：模型没下载（`adoremix audio8-fetch-model`）、内存不足（模型常驻约 1.8GB）、onnxruntime 版本不符合 `<1.24` 约束。

**合成很慢**

CPU int8 推理，2 核赛扬实测约 15 秒生成 1 秒音频。弱 CPU 建议只用定时广播预生成，或换云端 TTS（xf/edge）。

## 常见问题

### Q: 必须装 Node.js 吗？

是的。AdoreMix 的 CLI 工具和 TTS dispatcher 都是 Node.js 写的。但**客户机器只需要装 Node.js，不需要装 Qt / python / 编译器**（除非用 edge TTS 才需要 python）。

### Q: 可以不用 npm 吗？

可以。从 GitHub release 下载对应平台的 tarball，解压到工作目录，直接跑二进制。但失去 CLI 的便利（配置向导 / 开机自启 / doctor 等）。

### Q: macOS 支持吗？

**支持 Apple Silicon（arm64）**（v1.0.19+）。macOS **Intel（x64）已放弃支持**（自 v1.0.28 起不再提供 Intel 包）。首次启动若被 Gatekeeper 拦截，运行 `xattr -d com.apple.quarantine <二进制路径>` 即可。

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
- **完全离线**：audio8（本地部署，不依赖任何云服务；需 Linux + 约 1.8GB 内存 + 423MB 模型，弱 CPU 合成慢，适合定时广播预生成）

建议：先用 edge 测试跑通，正式部署用 minimax；内网/无外网环境用 audio8。

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

- **v1.0.76**: 设备接入 P1 泄漏修复（转发节点/喊话通道/按键通道）；MP3 通道 ACK 粘包按个数消费、队列溢出丢最旧包、写失败不再卡流；移除已淘汰的 WiFi 机型（`leixing==2`）专用通道
- **v1.0.74**: 设备连接生命周期改造（会话代际/指针纪律/探活）；默认 `DevOfflineTimeout=25`；文档补齐设备协议、WAL 备份、端口清单
- **v1.0.72**: 设备在线判定改用心跳 OKOK + 可配置 `DevOfflineTimeout`（默认 20s）；文档补充 SQLite 默认/Redis 已移除
- **v1.0.71**: 新增 `DevOfflineTimeout` 配置项 + 「设备在线判定」章节
- **v1.0.68**: 文档补全（MP3Server 改端口/改目录步骤、配置项表、端口清单、故障排查、卸载命令）+ CLI 帮助
- **v1.0.67**: MP3Server 关闭连接后的输入保护
- **v1.0.66**: MP3Server 尾块发出后立即回 `close`（对齐 C++ 原版）
- **v1.0.65**: **MP3Server 选装**（全平台 TCP 分块推流，Node 实现，`adoremix mp3server`）
- **v1.0.64**: 修复 audio8 服务探测在 Windows 必误报不可达
- **v1.0.63**: doctor 新增 Audio8 本机部署体检（单元/venv/模型/音色/健康/内存/磁盘）
- **v1.0.62**: Audio8 重跑 install 不再删除已下载的 423MB 模型
- **v1.0.61**: 修复 audio8 写 config.ini 的路径与工作目录
- **v1.0.60**: Audio8 0.1B INT8 端到端适配（正确 runtime、uvicorn 启动、线程按核数自适应、默认音色、WAV→MP3）
- **v1.0.58 ~ 1.0.59**: fetch-model 三处修复（307 重定向/真实文件清单/模型目录）+ 安装链路（双层目录平仓/venv 对齐/清华镜像）
- **v1.0.57**: 新增 `audio8-fetch-model`（模型下载与 install 解耦）
- **v1.0.56**: Audio8 内置离线源码 tarball（不依赖 GitHub 可达）
- **v1.0.42 ~ 1.0.55**: Audio8 TTS 选装探索与各发行版环境适配（包管理器嗅探、python3.11、systemd 绝对路径）
- **v1.0.40**: `PackSize` 默认 1024→2048，修复 mp3 流播放卡死
- **v1.0.38**: 设备配置管理 UI 选装（`config-manager`，端口 9877）
- **v1.0.36**: doctor 校验所有捆绑库均从 `lib/` 加载
- **v1.0.34**: 平台子包版本一致性校验（识别镜像同步滞后）
- **v1.0.32**: 新增 `adoremix uninstall`（`--purge` 删工作目录）
- **v1.0.30**: Linux ARM 包 etc 扁平化 + 捆绑 lame
- **v1.0.29**: 补齐 `.Adore.db` 默认数据库
- **v1.0.28**: 放弃 macOS Intel（x64）支持
- **v1.0.27**: 系统要求补充 Linux 发行版兼容矩阵
- **v1.0.26**: 安装路径非 ASCII 拦截
- **v1.0.24**: doctor 增加所有依赖库版本兼容性检查
- **v1.0.23**: Windows 统一 Qt 5.15.2（修复 64 位 exe + 32 位 DLL 崩溃）
- **v1.0.18**: WebUI 切换保留用户数据（mp3 等）
- **v1.0.17**: WebUI 多版本（low 16k / high 44.1k）
- **v1.0.15**: TTS dispatcher 完整版（xf / minimax / edge + CLI 命令）
- **v1.0.10**: doctor 集成 TTS 检查
- **v1.0.7**: 新增 doctor 健康检查命令
- **v1.0.6**: 日志开关默认 false（避免占磁盘）
- **v1.0.5**: config network / preurl 子命令
- **v1.0.3**: 完整依赖打包（libdouble-conversion + libpcre2-16 + .Adore.db）
- **v1.0.0**: 首版发布（4 平台 + CLI + systemd / Windows Service）
