# Changelog

本文件记录 @oxiaom/adoremix 各版本变更。版本号同步主包 + 4-6 个平台子包。

## 1.0.97 — 2026-11-12

### 修复：Windows 客户"运行起来不能正常登录"

客户现场：服务端口都监听着、网页也能打开，但**登录一律被拒**。
页面 200、登录返回 `ER_REJECT` —— 极难联想到是数据库问题。

根因是 SQLite 的一个特性：**打开不存在的文件会自动创建一个空库**，
`open()` 成功、服务正常起来，但里面**一张表都没有** → 登录查询失败 → 全被拒。

#### 种子库兜底（两级）

包内新增 `AdoreSeed.db`（22 张表结构 + 默认账号 `admin/123123123`）：

| 情况 | 行为 |
|---|---|
| 目录**没有** `.Adore.db` | 用种子库初始化一份，程序照常启动 |
| 目录**有** `.Adore.db` 但**一个账号都没有** | 只把 admin 账号补进 `sbox_users`，**其他数据一张不碰** |
| 目录**有** `.Adore.db` 且有账号 | 完全不动 —— 客户自己的库一个字节都不碰 |

第二级是客户现场实测出来的：他们的 `.Adore.db` 表都在，但 `sbox_users` 是空的
（SQLite 自动建空壳 + `schema_repair` 只补表不补账号，必然如此）。

#### 报错说准

之前只说"数据库是空的"，现场会以为"库在、就是没账号"，方向还是跑偏。
现在区分两种情况：
- **表不存在** → "数据库里连表都没有（是全新空库）" → 你没拷库
- **表在但 0 行** → "数据库里没有账号" → 库被清空过

#### 其他修复

- `httplistener` 端口默认值 12080 —— 缺 `[listener]` 段时不再 `listen(0)`（HTTP 服务根本没起来）
- `staticfilecontroller` docroot 默认 `etc/docroot` —— 缺段时不再 404
- 端口没监听时，**npm install --force** 会把客户正在用的库覆盖掉（设备、计费、录音记录全丢）。
  现在检测到已有 `.Adore.db` 就跳过复制并告警。

### 设备在线判定：默认改成 TCP

客户反馈加了心跳超时踢出后**上线率明显下降**。

查证发现：`app` 模式（心跳静默超时 25 秒）是后来加的，
**在加它之前判离线只看 TCP socket 状态** —— 设备只要 TCP 还连着就一直算在线。
弱网/4G 链路回包慢 → 被误踢 → 重连 → 又被踢。

**现在默认 `DevOfflineMode=tcp`**，等同于加超时踢出之前的逻辑，老客户升级不用改任何配置。

| `DevOfflineMode` | 判定依据 |
|---|---|
| `tcp`（**默认**） | 只看 TCP 状态，socket 断开才算离线 |
| `app` | 心跳静默超时（`DevOfflineTimeout` 秒，默认 25）—— 能快速发现断电，但弱网会误踢 |
| `off` | 不做主动判定 |

配套还有 `DevHeartbeatSend`（on/off，要不要主动发心跳）和
`DevHeartbeatMode`（okok/jxxx/alt，心跳内容）。

实测（模拟"连上就不回心跳"的设备）：
- 旧版 30 秒被踢（`Dev silent 29999 ms, mark offline`）
- 新版 75 秒存活，心跳照发

### 其他

- `AdoreMix.pro` 的 `QMAKE_POST_LINK` 写死了 `AdoreMixV8X`，Linux 构建时 TARGET 不同 → patchelf 找不到文件 → make 失败。改成 `$$TARGET`。
- Windows 升级包补上 `rsa_private_key.pem` / `rsa_public_key.pem`（之前漏了，启动报 `device not open`）。
- 打包脚本加三道校验：exe 必须含种子库逻辑、种子库只能有 1 个账号、exe 版本必须与参数一致 —— 防止再发出"看着正常、跑起来登不上"的包。

### 二进制

5 个平台全部重建：win32-x64 / linux-x64 / linux-arm64 / linux-arm / darwin-arm64。

## 1.0.95 — 2026-11-06

### 性能：任务系统查询优化

广播/喊话的任务调度器有两个定时器在高频访问数据库（每秒一次重建任务表）。
实测发现它查询的几张表原本**一个索引都没有**，查询计划全是全表扫描。

**加索引**（启动时自动建好，升级后无需手动干预）：
task / taskpop / taskseed / taskfile / warning 各加一个，
覆盖任务调度每秒跑的查询。查询计划从全表扫描变成索引查找。

**减少多余的列读取**：把几条"遍历全部行"的查询从读取整表所有列
改成只读取实际用到的列。

实机验证：升级前无索引，升级后自动建好 5 个，查询计划全部变为索引查找。

## 1.0.94 — 2026-11-05

### 性能：静态文件请求不再打开数据库连接

加载页面资源（js/css/图片）时不再白开数据库连接。

之前每个 HTTP 请求都会建立线程专属的数据库连接，而页面资源根本不用数据库
—— SQLite 的 open 要开文件、读 WAL 头、分配页缓存，线程退出时还要再关一次。
改成按需建立：只有真正查询数据的接口才会建连接。

Linux 实测（数进程打开的数据库文件句柄）：
  改动前：100 次静态文件请求 → 句柄 +2（开了连接）
  改动后：100 次静态文件请求 → 句柄 +0

## 1.0.93 — 2026-11-05

### 修复：darwin-arm64 子包发布卡住

1.0.92 的 darwin-arm64 在 npm 侧停在"已暂存"状态，既没发布成功也无法覆盖，
导致该版本 darwin 平台不可用。本版重新发布。

## 1.0.92 — 2026-11-04

### 前端页面更新（三套码率变体）

前端换成新构建，并补齐三套码率变体：

| 变体 | 参数 | 适用场景 |
|---|---|---|
| `ultra` | 16kHz / 16kbps | 带宽极差的环境（新增） |
| `low` | 16kHz / 32kbps | WiFi 音响、互联网环境（默认） |
| `high` | 44.1kHz / 64kbps | 局域网、音质要求高 |

切换：`adoremix config webui`（交互式选择）或
`adoremix config webui --variant ultra|low|high`

Windows 升级包里的前端同步到 `low` 变体，与 npm 安装保持一致。

### 修掉一个打包错配

打包脚本现在会校验：打包用的前端与 npm 包里的必须是同一套
（比对 index.html 的主入口 js 文件名），不一致就中止打包。
避免 Windows 客户和 npm 客户看到不同页面却无从察觉。

## 1.0.91 — 2026-11-04

### CI 发布凭据修复

自动发布流程之前失败（npm 报 404 认证失败）。根因是仓库里配置的
`NPM_TOKEN` 用的账号开了两步验证，而该 token 不是绕过 2FA 的类型 ——
CI 里拿不到一次性验证码，发布会被 2FA 拦下。

现在换成可绕过 2FA 的发布凭据，自动发布流程恢复正常。

## 1.0.90 — 2026-11-04

### 修复：HTTP 响应头出现互斥的两个头

压测发现每轮固定有一次请求失败，报 `HPE_INVALID_TRANSFER_ENCODING`，
而且**永远发生在服务启动后的第一个请求**。

原因：读静态文件时已经明确知道响应长度（设了 `Content-Length`），
写响应时又按"非最后一段"加上了 `Transfer-Encoding: chunked`。
这两个头是互斥的：

- 浏览器能容忍 → 很难被发现
- 严格客户端（Node / Python requests / curl --http1.1）直接报错

修复：已知长度时不再加 chunked（连接收尾逻辑本来就正确 ——
长度已知，客户端能自己判断响应结束）。

### 1.0.89 延续

- 设备卡号晚到时纠正档位（原先只更新卡号、不更新档位）

### 测试

- 压测新增断言：响应头不能同时出现 `Content-Length`/`Transfer-Encoding`
- 7 个套件 101 项全绿；压测 22 项全绿

## 1.0.89 — 2026-11-04

### 修复：设备卡号晚到时档位纠正

压测（2000+ 次设备连接）发现一个档位没纠正的缺陷。

**现象**：一批 4G 设备的记录里，档位停在较低档，卡号字段也是空的。

**原因**：设备上线后服务端会先按"非 4G"处理（有一段等待窗口，等设备回
J 应答）。如果设备回得比窗口晚（网络慢、4G 模块刚启动），就会先按非 4G
建档；等它后来报上卡号，只更新了卡号、没更新档位 → 4G 设备一直按低档。

**修复**：拿到卡号时，如果这条记录原来**没有卡号**（说明是按非 4G 建的），
把档位纠正成 4G。判据用"原来没有卡号"，所以管理员手工调整过的
档位不受影响。

### 崩溃修复（1.0.88 延续）

- 线程专属数据库连接回收时崩溃（客户现场 dump 定位，已在 1.0.88 修复）
- Linux 二进制补上 RPATH —— 客户机上装的是自带的 Qt，
  没有 RPATH 会报 `error while loading shared libraries: libQt5WebSockets.so.5`

### 测试

- 新增 `tools/stress_test.js`（21 项）：HTTP 混合读写压测、4G 设备连接风暴、
  换卡风暴、连接反复建立/断开、设备重连风暴、数据完整性、进程健康
- 新增 `tools/pricing_test.js`（6 项）：晚到卡号的档位纠正、窗口内直接按 4G、
  纯非 4G 保持原档
- 修掉测试工具里三个会伪装成产品故障的问题：设备 SN 用了非十六进制字符、
  健康探测用 GET /（返回 404）、curl 输出重定向用了 Windows 专有的 NUL

## 1.0.88 — 2026-11-04

### 崩溃修复（客户现场 dump 定位）
Windows 客户现场偶发崩溃，dump 分析结论：

```
EXCEPTION_ACCESS_VIOLATION 读 0xFFFFFFFFFFFFFFFF
崩在 Qt5Sql.dll+0x2c65 = QSqlQuery::~QSqlQuery()
this 指针 = 0x68632c22697a7567   ← 一段 JSON 文本（已释放内存被复用）
```

根因：线程专属的数据库连接被回收时，挂在它上面的查询对象有两个
**从未被初始化过**（构造函数和初始化函数都漏了），于是析构时对野指针
做了 `delete`。这类崩溃跟堆布局有关，不崩的时候是运气。

已修：构造函数把三个查询指针置空、初始化函数把三个都建齐
（保留多查询并行以同时持有多个结果集的设计）、相关调用加空指针保护。

### 顺带修掉的同类隐患（一次跨线程全面复盘）
- 重建连接时用了固定连接名，Qt 遇到同名会销毁旧连接，
  而旧连接上的查询对象还引用着它 → 改成唯一连接名
- 重建连接时关闭了**共用**的主连接 → 那些地方手里的查询对象变成野句柄
  → 改成只销毁查询对象、不动连接
- `Mp3Server` 的缓存表没有加锁，主线程和 HTTP 工作线程会并发写
  → 同一个 `QMap` 并发插入会破坏内部结构 → 加互斥锁
- 线程专属连接的缓存原来是进程级全局的，只按线程区分、不区分是哪个实例要的连接
  → 同一线程里两个不同实例会串库 → 改成每个实例一份
- MySQL 部署下 HTTP 路径直接用了主线程创建的连接 → 改成每线程一条
- 两个非 void 函数没有 return（未定义行为）→ 显式返回 false

### ICCID 自动采集的开关
- 4G 设备开机会上报 SIM 卡号（ICCID），服务端自动采集落库。
- 采集到的卡号是否自动进入后续流程，由配置项 `jiefei` 控制：
  - `jiefei=true` 开启
  - 不写或写 `false` 关闭 —— 后台手动管理照常可用
- **私有化部署不用改任何配置**，默认就是关闭的，无感。
- 开启后的默认参数可在 config.ini 里调整（按设备类型分别设置月费和有效期）。
- 非 4G 设备有 8 秒判定窗口（等设备回 J 应答），慢速 4G 设备不会误判。

### Windows zip 升级包
- `AdoreMix-win-x64-1.0.88.zip`：给 Windows 云服务器直接换可执行文件升级用，
  不走 npm（服务器上没有 node 也能升）。
- 包里**不含** `.Adore.db` 和 `config.ini` —— 客户的库和配置不会被覆盖。
- 附 `config.ini.sample` 供新部署参考。

### 测试
- 新增 `tools/iccid_jiefei_test.js`（15 项：开关开/关/未配三种状态、
  4G 与非 4G 分档定价、一年后到期、慢速 4G 不误判、删除后不自动加回）
- 新增 `tools/threaddb_test.js`（4 项）与 `tools/threaddb_probe.js`（2 项）：
  线程专属连接的建立与回收
- 新增 `tools/analyze_dump.py`：分析 Windows 崩溃 dump
  （异常码、寄存器、符号化、崩溃点反汇编）
- 各套件自己重启服务端并注入所需配置，不再依赖执行顺序
- 全量回归 94 项全部通过；Windows / Linux x64 / arm64 / arm 四个平台均重新编译

## 1.0.87 — 2026-11-01

### darwin-arm64 二进制重建
- 1.0.86 的 darwin 包沿用了 1.0.85 的二进制（当时 macOS CI 排队慢，先跳过）。
- 本版重新构建 darwin-arm64，补上：
  - 数据库 schema 启动自检修复（升级不丢老数据）
  - ICCID 按 ITU-T E.118 严格校验（纯数字 19~22 位）
  - 其余 1.0.86 特性（端口系列是 npm 侧，不涉及二进制）

### 其余平台
- Windows x64 / linux-x64 / linux-arm64 / linux-arm 与 1.0.86 相同（二进制未变）。

## 1.0.86 — 2026-11-01

### 数据库 schema 启动自检修复（升级不丢数据）
- 客户升级 exe / Linux 可执行文件时，库是老版本建的，缺表缺列会让程序读写异常。
- 现在服务启动第一件事核对 schema：缺表建表、缺列补列，**已有的表列一个不动，老数据不丢**。
- 幂等：重复启动零改动。修复内容打日志便于现场排查。
- 标准结构覆盖 21 张业务表。

### 端口系列（安装时指定）
- `adoremix install --port-series 117` → 所有端口用 117xx
  （11733 主控制 / 11702 喊话 / 11703 运维命令 / 11780 HTTP …）
- `adoremix config set-port-series 117` → 已装的实例切换
- 只改本机监听的端口，MySQL/Redis 等外部依赖不动；改完要重启生效。

### ICCID 校验收紧
- ICCID 按 ITU-T E.118 校验：纯数字、19~22 位。
- 原来只挡 SQL 危险字符，垃圾值（纯字母、1 位）会被写进数据库，
  设备先报垃圾值再报真卡号时会在换卡历史里留下假记录。
- `edit_skdeviccid` 人工改卡号接口原来直接拼 SQL（注入风险 + 无校验），已一并修。

### 测试
- 新增 `tools/schemarepair_test.js`（13 项：缺表缺列被补、老数据一条不少一字不、重复启动零改动）
- 新增 `tools/iccid_random_test.js`（29 项：随机真实格式 ICCID + 12 种非法值）
- 全量回归 75 项 + schema 13 项全部通过

### 平台
- Windows x64 / linux-x64 / linux-arm64 / linux-arm 重建
- **darwin-arm64 本版未重建**（macOS CI 太慢），沿用 1.0.85 的二进制

## 1.0.85 — 2026-11-01

> 1.0.84 的二进制不含下面的代码审查修复（帧粘连吞帧、卡号同步问题、
> 配置路径不一致），已废弃，请用 1.0.85。

### 修复（代码审查发现）
- **帧粘连吞帧**：J 应答和下一个协议帧粘在同一段 TCP 里时（`J{...}UA2`），
  JSON 后面的尾巴会留在缓冲区里，之后每一帧（`UA1`/`UA2`/`Y`/`K`/`DEIF`/`WOK`/`SWOK`）
  都被当成 J 续包吞掉 —— 播放控制、对讲应答、设备状态全失效，且缓冲区无限增长。
- **卡号同步问题**：设备表有卡号、另一张表没有（或反之）时，原先用同一个条件门控
  整块逻辑，会导致两处状态不同步（一个更新了另一个没更新）。
- **配置路径不一致**：读配置硬编码 `config.ini`，但服务支持 `argv[1]` 指定绝对路径 ——
  用绝对路径启动时相关设置项静默失效。

### 其余内容同 1.0.84
- 4G 设备卡号（ICCID）自动采集与落库
- 修建表默认值（`DEFAULT iccid` → `DEFAULT ''`）与重建表的 6 个数据丢失隐患

### 验证
- 3 个自动化测试套件共 46 项断言全通过（`tools/iccidtest_suite.js` 32 项、
  `iccid_variants_test.js` 9 项、`iccid_edge_test.js` 5 项）
- 并发 30 台同时上报、soak 200 台上下线无异常
- 5 个平台二进制全部重建并逐一验证：
  Windows x64、Linux x64、Linux arm64（QEMU）、Linux arm32（QEMU）、macOS arm64（CI）
- 测试有效性已验证：退回旧逻辑后对应断言立即失败

## 1.0.84 — 2026-11-01（已废弃：二进制不含审查修复）

### 4G 设备卡号自动采集
- 4G 设备（AIR780EHV）开机 J 应答自报 SIM 卡号，服务端自动采集并落库。
- 卡号按 ITU-T E.118 校验（纯数字、19~22 位），非法值拒绝入库。

### 修复
- 数据库建表默认值写成 `DEFAULT iccid`（漏引号），SQLite 当成字符串 `'iccid'`，
  导致未填卡号的行带上占位串。迁移修正为 `DEFAULT ''` 并清理占位串。
- 重建表的 6 个数据丢失隐患：动态保留所有列（不丢自定义列）、
  重复主键不被 `ON CONFLICT IGNORE` 静默吞行、行数校验、15 位合法卡号不被长度启发式误清、
  清理动作纳入事务、`sqlite_sequence` 保留原 seq。
- J 应答 JSON 边界识别改为**字符串感知**（原先字符串里的 `{`/`}` 会截断 JSON，卡号丢失）。
- J 应答与下一个协议帧粘连时，尾巴交回正常处理链（原先会毒化缓冲区，
  导致播放控制/对讲应答/设备状态全被吞掉）。
- 读配置统一走实际配置文件路径（原先硬编码 `config.ini`，用绝对路径启动时设置静默失效）。

### 验证
- 新增 3 个自动化测试套件（`tools/iccidtest_suite.js` 32 项、
  `iccid_variants_test.js` 9 项、`iccid_edge_test.js` 5 项），
  另有并发 30 台、soak 200 台无异常。
- 测试有效性已验证：退回旧逻辑后对应断言立即失败。
- 5 个平台二进制全部重建。

## 1.0.83 — 2026-10-27

### 修复（严重，仅 darwin-arm64）：1.0.82 的包仍含 Homebrew 绝对路径
- 1.0.82 虽然打出了 `AdoreMix.app`，但有两处依赖没改写：
  - `Frameworks/libsqlitecipher.dylib` 从 Homebrew 原目录复制，依赖 `/opt/homebrew/opt/qt@5/...`（客户机必崩）
  - `lame` 依赖 `/opt/homebrew/opt/mpg123/...`，且 `libwebp*` 依赖未打包的 `libsharpyuv.0.dylib`
- 修复：sqlitecipher 改为从 macdeployqt 已改写的 `PlugIns/sqldrivers/` 副本复制；补带 `libmpg123.0.dylib`、`libsharpyuv.0.dylib` 并改写依赖。
- CI 增加**全量 Mach-O 依赖解析**：遍历 app 内所有二进制/框架/插件，`@rpath` 必须能解析到实际文件，且禁止 `/opt`、`/usr/local`、`/Users` 绝对路径，构建不通过则失败。
- **macOS 用户请使用 1.0.83（1.0.82 的 darwin 包已标记 deprecated）。** 其他平台 1.0.82/1.0.83 二进制相同。

## 1.0.82 — 2026-10-27（darwin 包有缺陷，已被 1.0.83 取代）

### 二进制更新：darwin-arm64（macOS Apple Silicon）正式可用
- 重写 macOS CI：`macos-15` runner + Homebrew 原生 arm64 Qt 5.15.19，构建成功（旧的 macos-14 + `brew update` 会退化为源码编译 python 而失败）。
- 修复历史遗留的 mac 打包错误：旧流程把裸二进制传给 `macdeployqt`，报 `Could not find bundle binary`，**Qt 框架和 sqldrivers 插件从未进入安装包**，客户机上无法启动。
- 现在产物是标准 `AdoreMix.app`（Qt Frameworks + PlugIns + sqlitecipher 驱动），launcher 指向 `AdoreMix.app/Contents/MacOS/AdoreMixV8.0.17_console_darwinarm64`。
- npm 打包会丢弃符号链接：CI 中把 framework 的软链全部实体化，并断言包内无符号链接。
- 附带 `lame` + `libmp3lame.0.dylib`，macOS 同样走进程内转码，不要求客户安装 lame。
- CI 新增依赖存在性检查 + 实际启动 5 秒的 dyld 冒烟测试，本版通过。
- 移除 darwin 包内开发测试上传的 `etc/docroot/mp3`（约 57MB），tar 体积 110MB → 51MB。

### 其他平台
- Windows x64 / linux-x64 / linux-arm64 / linux-arm 与 1.0.81 相同（已包含 libmp3lame 进程内转码、上传 SIGSEGV 修复、精确时长）。

## 1.0.81 — 2026-10-26

### 二进制更新：ARM 架构
- **linux-arm64 / linux-arm**：重新编译（复用原有 ARM builder 镜像，跳过 apt 源问题），首次包含 libmp3lame 进程内转码、上传崩溃修复、精确时长。
- QEMU 实测：上传 MP3 时长 21 秒、WAV 3 秒、损坏文件返回 `TRANSCODE_ERROR`，服务稳定。
- Windows x64 / Linux x64 沿用 1.0.80 的修复二进制。
- **darwin-arm64**：二进制仍为旧版（GitHub macOS runner 的 Homebrew 安装耗时过长，构建未在本次发版前完成），版本号同步；完成后单独发版更新。

## 1.0.80 — 2026-10-26

### 修复/完善：音频时长与 TTS 路径
- 转码后的时长由“向上取整”改为**四舍五入到秒**：179.018s→179、20.533s→21、3.0s→3（更贴近实际播放长度）。
- 文字转语音（`user_save_ttsfile` / `user_play_tts`）使用同一进程内转码器；用 22.05kHz（MPEG-2，模拟 edge）和 16kHz 单声道（MPEG-2.5，模拟讯飞）MP3 在 Windows/Linux 验证保存、播放接口均成功。
- 数据库仍为默认 **SQLite（dbk=3）**，本版未改动任何数据库配置或结构。

## 1.0.79 — 2026-10-26

### 新特性：进程内 libmp3lame 转码 + 精确时长
- 上传音频 / TTS 转码不再调用外部 `lame` 进程，改为内置 libmp3lame：
  - 解码：`hip_decode`（mpglib）；编码：`lame_encode_buffer*`，支持重采样（如 48k→24k）
  - 支持 MP3、16-bit PCM WAV；损坏文件返回 `TRANSCODE_ERROR`，不崩溃、不生成空文件
- 时长按解码样本数精确计算，替换原来的 `filesize/码率+2` 估算（实测：179.018s→180，20.533s→21）
- Windows 静态链接 LAME 3.100 x64（`LIB/libmp3lame.a`）；Linux 使用包内 `libmp3lame.so.0`
- macOS 无 dylib 时回退外部 lame

### 修复
- 上传音频导致主进程 SIGSEGV（线程 sqlite 未继承 Mp3Server）——1.0.78 已修，本版沿用
- `hip_decode` 一次解出多帧导致 PCM 缓冲越界（本次开发中发现并修复）

### 验证
- Windows 与 Linux 容器：普通 MP3、客户 7.3MB/179s MP3、16-bit WAV、随机损坏文件均符合预期

## 1.0.78 — 2026-10-26

### 修复（严重）：上传音频导致服务 SIGSEGV
- **根因**：线程专属 sqlite（`forCurrentThread()`）没有继承主实例的 `Mp3Server` 指针；上传完成后 `findFirstAudioFrame()` 在空指针上访问 `casemap`（偏移 0x10）→ `segfault at 10`。dmesg：`QThread[...] segfault at 10 ... in AdoreMixV8.0.17_console_linuxx64`。
- **修复**：线程 sqlite 复制 `Mp3Server`、`init_s`；成员初始化为 `nullptr`；调用前判空并返回 `MP3SERVER_NULL`。
- **验证**：客户 Ubuntu 22.04 热更新后上传返回 `res:true / SUC`，服务进程持续存活，dmesg 无新 segfault。

### 修复：systemd 服务 203/EXEC / 启动即退出
- Node 装在 `/root/.nvm` 下时，服务用户 `adoremix` 无法执行 node（203/EXEC）→ 自动回退为 root 运行并打印提示。
- 服务单元增加 `Environment=ADOREMIX_UNDER_SYSTEMD=1`，避免 CLI 在 systemd 内再次 `systemctl start` 自己导致主进程退出、服务显示 deactivated。

## 1.0.77 — 2026-10-23

### 二进制更新
- **Windows x64**：重新构建（sha256 `4c7b6fce…1e361e1`），包含 sa_snlist 读写锁、未登记 SN 24h 回收、`user_LIST` 空指针修复、端口绑定失败退出码 1。
- **Linux x64**：用 `docker/build-linux-x64.sh` 从最新源码重新构建（Qt 5.15 / Debian 11），首次包含本轮全部设备接入与 MP3 通道修复。
- linux-arm / linux-arm64 / darwin-arm64 二进制未变，仅版本号同步。

### Linux x64 验证（Docker，容器内 2000 台）
- 2000 台 10 分钟：2000/2000 接入，心跳 234,825 次，0 错误。
- 50 台每 2s 反复重连：14,800 次，0 错误。
- 内存稳定 486~488MB（约 2050 台在线），CPU 5~9%，无崩溃。
- `POST /user/olist`（2000 台、350KB 响应）4 并发：151 rps，p50 26ms。

## 1.0.76 — 2026-10-23

> 1.0.75 是首次发布版本，因 npm registry 异步发布延迟，主包 `latest` 标签与 tarball 未及时同步，已用 1.0.76 重新发布并对齐 7 个包的 `latest`。

### 修复：设备接入内存泄漏（P1）
- 转发节点 `QVdev::fuckedup()` 由空实现改为真正释放：停定时器、断开信号、关闭两个 socket 并删除对象；构造补指针初始化，`set_status()` 补判空。
- 喊话接收 `juice_sv` 错误分支关闭并释放 socket。
- MP3 通道握手时未知 SN 的连接关闭释放。
- 按键通道 `fcr_sev` 同一 `skn` 重连改为“新连接替换旧连接”；无效握手/无数据超时关闭。
- `Dps_` 构造初始化、`clear()` 判空（每个喊话会话仍是独立本地 IPC，支持多人并发喊话）。

### 修复：MP3 / 音频推流
- ACK 粘包：一次收到多个 ACK（如 10 字节 = 两个 5 字节）按 ACK 个数继续取包，不再只取一包导致节拍变慢。
- 队列溢出改为丢最旧包（`removeFirst`），不再整队清空造成断音。
- 写失败（socket 断开）清除“发送中”标记，重连后可继续推流，不再永久卡队列。

### 变更
- 移除已淘汰的 WiFi 机型（`leixing==2`）专用音频通道，统一走标准通道；设备若上报 2 仅打印废弃日志。

### 验证
- Windows x64：2000 台模拟设备并发 120s，0 错误，内存 88MB/145MB（含句柄 2272），断开后回落至 37MB/27MB。
- 断电模拟（不回心跳）：30s 判定离线（`DevOfflineTimeout=25` + 5s 轮询）。
- 200 台反复上下线 30s：11388 次握手，进程稳定；同 SN 双连接旧连接关闭、新连接保留。

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
