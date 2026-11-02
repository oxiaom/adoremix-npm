# 服务器部署手册（Linux / Windows）

面向自建服务器的用户：怎么把 AdoreMix 装到服务器上、怎么升级、出问题怎么查。

---

## 一、两种部署方式

| 方式 | 适合 | 特点 |
|---|---|---|
| **npm 安装**（推荐） | 大多数场景 | 一条命令装好，自带开机自启、配置向导、跨平台 |
| **手动部署** | 服务器上没有 node、或需要自定义 | 自己下二进制、配 systemd |

npm 方式见 [完整使用文档](USAGE.md)。本文讲手动部署和升级。

---

## 二、Linux 手动部署

### 1. 准备目录

```bash
sudo mkdir -p /opt/adoremix
cd /opt/adoremix
```

需要放进去的文件（从 npm 包的 `native` 目录取）：

```
AdoreMixV8.0.17_console_linuxx64    主程序（按架构选 linuxx64 / linuxarm64 / linuxarm）
lib/                Qt 运行库
platforms/          Qt 平台插件
sqldrivers/         数据库驱动（必须含 sqlitecipher）
imageformats/ iconengines/ bearer/ audio/ mediaservice/
etc/                业务资源（docroot、templates）
qt.conf  find.js  findsc.js  tts.js  lame
```

```bash
sudo chmod +x AdoreMixV8.0.17_console_linuxx64
```

> ⚠️ `sqldrivers/` 里**必须有 `libsqlitecipher.so`** —— Qt 自带的驱动包里没有，
> 缺了连不上数据库。
>
> ⚠️ 架构要对：`file AdoreMixV8.0.17_console_linuxx64` 看是 x86_64 / aarch64 / arm。

### 2. 配置 config.ini

```bash
sudo cp config.ini.sample config.ini
sudo nano config.ini
```

最少要改这几项：

```ini
[Settings]
dbk = 3                      ; 3=SQLite（默认），1=MySQL
LocalIP = 192.168.1.100      ; 本机实际 IP
Meida_ip = 192.168.1.100
Fip = 192.168.1.100
preurl = http://192.168.1.100:12080/    ; 端口要和 [listener] port 一致

[listener]
port = 12080
```

完整的配置项见 [配置项详解](USAGE.md#配置项详解)。

### 3. 配 systemd 开机自启

```bash
sudo tee /etc/systemd/system/adoremix.service >/dev/null <<'EOF'
[Unit]
Description=AdoreMix Media Server
Documentation=https://github.com/oxiaom/adoremix-npm
After=network.target
Wants=network.target

[Service]
Type=simple
User=root
Group=root
WorkingDirectory=/opt/adoremix
ExecStart=/opt/adoremix/AdoreMixV8.0.17_console_linuxx64 config.ini
Restart=always
RestartSec=5
StandardOutput=append:/opt/adoremix/logs/adoremix.log
StandardError=append:/opt/adoremix/logs/adoremix.log
LimitNOFILE=65536
TimeoutStopSec=30
KillSignal=SIGTERM

[Install]
WantedBy=multi-user.target
EOF

sudo mkdir -p /opt/adoremix/logs
sudo systemctl daemon-reload
sudo systemctl enable adoremix.service
sudo systemctl start adoremix.service
```

> **两个容易踩的坑**：
>
> 1. `WorkingDirectory` 必须设成安装目录 —— 主程序用相对路径找 `config.ini`、
>    数据库和 `etc/`。不设会从 `/` 找不到文件。
> 2. `Description` 必须是**纯 ASCII**。非 UTF-8 会报
>    `Failed to enable unit: Invalid argument`，错误信息很不直观。

### 4. 验证

```bash
systemctl is-active adoremix.service       # active
systemctl is-enabled adoremix.service      # enabled
curl -s -o /dev/null -w '%{http_code}\n' http://127.0.0.1:12080/   # 200
ss -lntp | grep AdoreMix                   # 端口都在
sudo tail -50 /opt/adoremix/logs/adoremix.log
```

---

## 三、数据库自动修复（升级不丢数据）

主程序启动的第一件事就是核对数据库结构：

- 缺表 → 按标准结构建表
- 缺列 → `ALTER TABLE ADD COLUMN` 补上
- **已有的表和列一个都不动**，老数据一条不少

所以**直接换二进制升级就行**，不需要手动跑 SQL。日志里会看到：

```
schema repair: created tables: ("...")
schema repair: added columns: ("...")
```

这是正常输出，不是报错。整个过程幂等，每次启动都跑，重复执行没有副作用。

标准结构覆盖 21 张业务表（设备表、用户表、任务表、音频文件表等）。

---

## 四、升级

### ⚠️ 两条铁律

1. **绝不能覆盖数据库**（`.Adore.db`）—— 设备和音频记录都在里面
2. **绝不能覆盖 `config.ini`** —— 端口和 IP 是现场配置

### Linux 升级步骤

```bash
# 1. 备份
TS=$(date +%Y%m%d-%H%M%S)
sudo cp -a /opt/adoremix/.Adore.db   /opt/adoremix/.Adore.db.bak-$TS
sudo cp -a /opt/adoremix/config.ini  /opt/adoremix/config.ini.bak-$TS
sudo cp -a /opt/adoremix/AdoreMixV8.0.17_console_linuxx64 \
           /opt/adoremix/AdoreMixV8.0.17_console_linuxx64.bak

# 2. 传新二进制到 /tmp，先校验 sha256 再替换
sudo systemctl stop adoremix.service
sudo cp /tmp/AdoreMixV8.0.17_console_linuxx64.new \
        /opt/adoremix/AdoreMixV8.0.17_console_linuxx64
sudo chmod +x /opt/adoremix/AdoreMixV8.0.17_console_linuxx64

# 3. 启动，看日志确认 schema 修复
sudo systemctl start adoremix.service
sleep 8
grep -i 'schema repair' /opt/adoremix/logs/adoremix.log
```

> 用 npm 方式部署的话，直接 `npm install -g @oxiaom/adoremix@<新版本>` 即可，
> 它不会动 `config.ini` 和数据库。

### Windows 升级包

给 Windows 云服务器客户准备的 zip（不需要服务器上有 node）：

```
AdoreMix-win-x64-<版本>.zip
```

**包里没有** `.Adore.db` 和 `config.ini`（客户的库和配置不会被覆盖）。
解压覆盖到安装目录，重启进程即可。包里带 `UPGRADE-NOTES.txt` 说明。

---

## 五、端口系列（一套服务跑多个实例）

一套服务要占十几个端口。给一个**系列号**，所有端口都从这个系列里取，
同一台机器上就能跑多套互不冲突。

```bash
adoremix install --port-series 117     # 安装时指定
adoremix config set-port-series 117    # 已装的实例切换
```

| 配置项 | 默认 | 117 系列 | 用途 |
|---|---|---|---|
| `DPort` | 3333 | 11733 | 设备主控制通道 |
| `DataPortBack3` | 6031 | 11731 | 设备备用控制通道 |
| `OPort0` / `Netcross_Port0` | 6000 | 11700 | MP3 跨接 |
| `OPort1` / `Netcross_Port1` | 6001 | 11701 | MP3 跨接 2 |
| `DataPort` | 6002 | 11702 | 喊话裸流入口 |
| `DataPortBack2` | 6030 | 11730 | 喊话裸流入口 2 |
| `PS1` | 6003 | 11703 | 运维命令通道 |
| `BjPort` | 6004 | 11704 | fcr 指令通道 |
| `PS2` | 6006 | 11706 | 运维命令通道 2 |
| `ManagePort` | 6007 | 11707 | 管理端口 |
| `Pastcmd` | 6008 | 11708 | 过去命令 |
| `wbport` | 6082 | 11782 | WebSocket 喊话 |
| `cuteport` | 12083 | 11783 | 录音端口 |
| `RDDATAPORT` | 7636 | 11790 | 二级数据端口 |
| `[listener] port` | 12080 | 11780 | HTTP 主服务 |
| `MP3Server.port` | 6665 | 11765 | MP3Server |

- **只改本机监听的端口**；MySQL、Redis 等外部依赖端口不动
- 改完**重启服务**才生效
- `install` 完成后会打印实际端口系列，配置不成套时会告警

---

## 六、故障排查

### 启动就退 / 端口被占

```bash
ss -lntp | grep -E '3333|12080'     # 谁占着
ps aux | grep AdoreMix               # 有没有残留进程
```

手工起过的进程和 systemd 会抢端口。统一用 systemd 后不要再 `nohup ./AdoreMix &`。

### systemd 装不上：`Failed to enable unit: Invalid argument`

unit 文件不是合法 UTF-8（`Description` 里有中文/乱码）。改成纯 ASCII。

### 看不到数据库的最新改动

数据库是 SQLite WAL 模式。服务运行中另开连接读主库文件，读到的是
**checkpoint 之前的旧快照**。三种正确读法：

```bash
# 1. 停服务后再读
sudo systemctl stop adoremix.service && sudo sqlite3 .Adore.db "select ..."

# 2. 把 -wal / -shm 一起拷走再读
cp .Adore.db .Adore.db-wal .Adore.db-shm /tmp/chk/ && sqlite3 /tmp/chk/.Adore.db "..."

# 3. 在服务内部查
```

### sqlite3 报 `attempt to write a readonly database`

库文件是 root 权限，普通用户跑 `sqlite3` 写不了。加 `sudo`。

### 非交互执行 sudo 报 `a terminal is required`

用 `echo '密码' | sudo -S 命令`。

### 找不到 sqlitecipher 驱动

`sqldrivers/libsqlitecipher.so` 缺失或架构不对（x86_64 vs aarch64）。
用 `file sqldrivers/libsqlitecipher.so` 确认架构。

### 启动日志没有输出

Windows 控制台程序输出重定向到文件时可能不落盘。直接前台跑看输出。

Linux 上正常，日志在 `/opt/adoremix/logs/adoremix.log`。

---

## 七、相关文档

- [完整使用文档](USAGE.md) —— 安装、配置、后台使用
- [配置项详解](USAGE.md#配置项详解)
- [故障排查](USAGE.md#故障排查)
- [常见问题](USAGE.md#常见问题)
