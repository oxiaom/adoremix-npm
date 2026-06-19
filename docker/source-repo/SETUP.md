# AdoreMix 私有源码仓库 CI 配置

这个目录的文件应该**复制到私有 GitHub 仓库 `oxiaom/adoremix-source`**（手工创建，跟 Gitee 主仓库做镜像）。

## 为什么需要这个仓库

AdoreMix 主源码在 Gitee（`gitee.com/iot-mxi/Adoremix2`），但 Gitee Go CI 不提供 macOS runner。
为了用 GitHub Actions 的 `macos-13` / `macos-14` runner 编译 darwin 二进制，需要在 GitHub 上有源码镜像。

公开 npm 仓库 `oxiaom/adoremix-npm` **不包含源码**，只通过 PAT 拉取私有 GitHub 仓库的 release 产物。

## 一次性配置流程

### 1. 在 GitHub 创建私有仓库

- 访问 https://github.com/new
- Repository name: `adoremix-source`
- Visibility: **Private**（必须私有，保护源码）
- 不要勾选 Initialize（保持空仓库）

### 2. 把 Gitee 源码同步过来

最简单的方式（一次性）：

```bash
# 在本地 Adore_mix2 目录操作
cd D:/zhuangyi/vbox/Adore_mix2

# 添加 GitHub 作为新 remote
git remote add github https://github.com/oxiaom/adoremix-source.git

# 推送所有历史（保留 Gitee 为 origin）
git push github master:main
```

后续持续同步方式（二选一）：

**方式 A：手工推送**（推荐，最简单）
```bash
# 平时在 Gitee 工作，需要触发 darwin CI 时手工 push 一次
git push github master:main
```

**方式 B：自动镜像**（用 Gitee 的 webhook）
- Gitee 仓库 → 管理 → Webhooks → 添加
- URL: `https://api.github.com/repos/oxiaom/adoremix-source/dispatches`
- 触发事件: push
- 需要在 GitHub 仓库的 Settings → Secrets 加 `MIRROR_PAT`（一个有 admin 权限的 PAT）

### 3. 把 CI 配置文件复制进 GitHub 仓库

```bash
# 在 adoremix-npm 仓库的 docker/source-repo/ 目录
cd D:/zhuangyi/vbox/adoremix-npm/docker/source-repo

# 复制到 GitHub 源码镜像仓库的本地 clone
cp -r .github /path/to/adoremix-source-mirror/
cp .gitignore /path/to/adoremix-source-mirror/

# 推到 GitHub
cd /path/to/adoremix-source-mirror
git add .github .gitignore
git commit -m "ci: add build-darwin workflow"
git push origin main
```

### 4. 在 `adoremix-npm` 仓库配置 PAT

`pull-darwin-artifacts.yml` 需要读取 `adoremix-source` 仓库的 release，所以需要一个 PAT：

1. 访问 https://github.com/settings/tokens（Fine-grained tokens 推荐）
2. 生成新 token：
   - Resource owner: `oxiaom`
   - Repository access: Only select repositories → `adoremix-source`
   - Permissions: Contents = Read-only
3. 复制 token 值（只显示一次）
4. 到 `adoremix-npm` 仓库 Settings → Secrets and variables → Actions → New repository secret
   - Name: `SOURCE_REPO_TOKEN`
   - Value: 粘贴 token

### 5. 触发首次编译

到 `oxiaom/adoremix-source` 仓库 Actions 页面：
1. 左侧选 `build-darwin`
2. 点 `Run workflow`
3. 输入版本号 `1.0.19`（与 npm 包版本同步）
4. Run

约 15-30 分钟后完成，会在该仓库的 Releases 看到：
- `adoremix-darwin-x64-1.0.19.tar.gz`
- `adoremix-darwin-arm64-1.0.19.tar.gz`

### 6. 把二进制拉到 npm 仓库

到 `oxiaom/adoremix-npm` 仓库 Actions 页面：
1. 选 `pull-darwin-artifacts`
2. Run workflow，输入版本号 `1.0.19`
3. CI 会自动下载两个 tarball、解压到 `workspaces/darwin-{x64,arm64}/native/`、commit、push

### 7. 发布到 npm

```bash
cd D:/zhuangyi/vbox/adoremix-npm
node scripts/publish-all.js --version 1.0.19
```

## 首次编译预期会失败

`build-darwin.yml` 写得尽量完整，但 macOS 上的实际编译可能因为以下原因失败：

1. **QtCipherSqlitePlugin 嵌套目录**：源码里是 `QtCipherSqlitePlugin-develop/QtCipherSqlitePlugin-develop/`，workflow 已处理双层嵌套
2. **AdoreMix.pro 硬编码路径**：`/opt/qt5.9.1-arm/...` 之类的残留路径需要清理（workflow 已 sed 移除）
3. **TARGET 名硬编码为 linuxarm0**：workflow 已 sed 替换为 `darwinx64` / `darwinarm64`
4. **opus / hiredis / mariadb 链接**：workflow 已追加 `macx {}` 块用 brew 路径
5. **multimedia 模块**：`.pro` 里挂着 `QT += multimedia`（虽然代码可能不调用），brew qt@5 自带 multimedia 模块，应该能链接

第一次失败时：
- 看 Actions 日志，定位失败步骤
- 把日志贴出来我调
- 大概率是 1-2 个小问题，迭代 2-3 轮就能跑通

## 文件清单

```
docker/source-repo/
├── .github/workflows/
│   └── build-darwin.yml      # macOS CI 主 workflow
├── .gitignore                 # 排除 build 产物、*.o、moc_* 等
└── SETUP.md                   # 本文档
```

## 注意事项

- **源码绝不进公开仓库**：`adoremix-npm` 仓库的 `.gitignore` 已排除 `docker/source-repo/` 以外的源码相关文件
- **PAT 权限最小化**：Fine-grained token 只给 `adoremix-source` 仓库的 Contents Read 权限
- **macOS runner 分钟消耗**：每次约 15-30 分钟 × 2 架构 = 30-60 分钟，按 10x 倍率扣 300-600 分钟/次。免费 2000 分钟/月，约 3-6 次编译。不够用再考虑 self-hosted runner
