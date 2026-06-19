# AdoreMix darwin-arm64 原生包

本目录存放 macOS ARM64 (Apple Silicon: M1/M2/M3/M4) 平台的二进制和运行时资源。

## 二进制构建方式（自动化）

本子包的二进制由**私有源码仓库**（`oxiaom/adoremix-source`，未公开）的 GitHub Actions 自动构建：

### 构建流程

1. 源码仓库收到 push 或手动触发 `build-darwin.yml`
2. GitHub Actions 在 `macos-14`（Apple Silicon ARM64）runner 上：
   - `brew install qt@5 lame`
   - 编译 QtCipherSqlitePlugin 到 Qt plugins/sqldrivers
   - `qmake && make` 编译 AdoreMix 主程序
   - `macdeployqt` 把 Qt frameworks + plugins 打包到二进制同级
   - 打 tag 时上传 `adoremix-darwin-arm64-{version}.tar.gz` 到 release
3. 公开 npm 仓库（`oxiaom/adoremix-npm`）的 `pull-darwin-artifacts.yml` workflow：
   - 下载私有仓库的 release artifact
   - 解压到本目录
   - 自动发布到 npm

### 验证产物架构

```bash
file workspaces/darwin-arm64/native/AdoreMixV8.0.17_console_darwinarm64
# 应输出：Mach-O 64-bit executable arm64
```

## 目标运行环境

- macOS 11 Big Sur 及以后（Apple Silicon M1/M2/M3/M4）
- macOS 12 Monterey / 13 Ventura / 14 Sonoma / 15 Sequoia
- 任意 Apple Silicon Mac（MacBook Air/Pro、Mac mini、Mac Studio、iMac）

## 注意事项

- 在 Intel Mac 上无法运行（请用 darwin-x64 子包）
- 首次运行若被 Gatekeeper 拦截：`xattr -d com.apple.quarantine /path/to/AdoreMixV8.0.17_console_darwinarm64`
- 若提示"无法验证开发者"：系统偏好设置 → 安全性与隐私 → 允许打开
