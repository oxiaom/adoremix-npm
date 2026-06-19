#!/usr/bin/env bash
#
# 在 x64 主机（Windows/Mac/Linux）上用 docker buildx + QEMU 跨架构编译 ARM64 AdoreMix，
# 并把产物 /out 从镜像里提取到 workspaces/linux-arm64/native/。
#
# 前置：
#   - Docker Desktop 4.x（自带 buildx + QEMU）或 Linux Docker + qemu-user-static
#   - Adore_mix2 源码目录可读
#
# 用法：
#   ./docker/build-linux-arm64.sh                          # 用默认源码路径
#   ./docker/build-linux-arm64.sh --src /path/to/Adore_mix2
#   ./docker/build-linux-arm64.sh --tag v1.0.0             # 镜像 tag
#   ./docker/build-linux-arm64.sh --no-extract             # 只构建不提取

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

SRC_DIR="${SRC_DIR:-D:/zhuangyi/vbox/Adore_mix2}"
IMAGE_TAG="adoremix-arm64-builder:latest"
EXTRACT=1

while [[ $# -gt 0 ]]; do
  case "$1" in
    --src) SRC_DIR="$2"; shift 2 ;;
    --tag) IMAGE_TAG="$2"; shift 2 ;;
    --no-extract) EXTRACT=0; shift ;;
    -h|--help)
      sed -n '2,20p' "$0"; exit 0 ;;
    *) echo "未知参数: $1"; exit 1 ;;
  esac
done

echo "==> 源码目录：$SRC_DIR"
echo "==> 镜像 tag：$IMAGE_TAG"

if [ ! -d "$SRC_DIR" ]; then
  echo "错误：源码目录不存在：$SRC_DIR" >&2
  exit 1
fi

# 1) 检查 docker
if ! command -v docker >/dev/null 2>&1; then
  echo "错误：未找到 docker，请先安装 Docker Desktop" >&2
  exit 1
fi

# 2) 检查 buildx
if ! docker buildx version >/dev/null 2>&1; then
  echo "错误：未启用 docker buildx。Docker Desktop 自带，Linux 需手动安装。" >&2
  exit 1
fi

# 3) 使用默认 builder（desktop-linux 已支持 arm64，避免拉额外 buildkit 镜像）
if docker buildx inspect --builder desktop-linux >/dev/null 2>&1; then
  docker buildx use desktop-linux
  echo "==> 使用 docker desktop-linux builder（已支持 arm64）"
else
  echo "==> desktop-linux 不可用，回退 default"
  docker buildx use default 2>/dev/null || true
fi

# 4) 检查 QEMU 是否注册 arm64（Docker Desktop 自带 binfmt；若没注册，尝试拉一次 qemu-user-static）
if ! docker run --rm --platform linux/arm64 arm64v8/ubuntu:22.04 uname -m >/dev/null 2>&1; then
  echo "==> QEMU 未就绪，尝试注册（需访问 Docker Hub）..."
  docker run --rm --privileged multiarch/qemu-user-static --reset -p yes || {
    echo "错误：QEMU 注册失败。请配置 Docker 镜像加速器后重试。" >&2
    exit 1
  }
fi

# 5) 验证能跑 ARM64 容器
echo "==> 验证 ARM64 模拟..."
ARCH=$(docker run --rm --platform linux/arm64 arm64v8/ubuntu:22.04 uname -m)
if [ "$ARCH" != "aarch64" ]; then
  echo "错误：ARM64 模拟返回 $ARCH，预期 aarch64" >&2
  exit 1
fi
echo "    ARM64 模拟 OK ($ARCH)"

# 6) 构建
echo ""
echo "==> 构建 ARM64 镜像（首次约 15-30 分钟）..."

# 在源码目录临时生成 .dockerignore，避免拷贝无关大文件（.o/.zip/build-*/debug/release）
DOCKERIGNORE="$SRC_DIR/.dockerignore"
cat > "$DOCKERIGNORE" <<'EOF'
# AdoreMix Docker 构建忽略列表（构建脚本自动生成/删除）
debug
release
build-*
*.o
*.obj
*.pdb
*.zip
*.rar
*.tgz
*.tar.gz
*.7z
*.img
*.exe.debug
*.dll.debug
node_modules
node_modules.rar
package-lock.json
logs
temp
dmp
tty
var
*.log
reqhttp.log
.git
.gitignore
.DS_Store
Thumbs.db
a.out
Makefile
Makefile.Debug
Makefile.Release
**/moc_*.cpp
**/qrc_*.cpp
**/ui_*.h
**/*.pro.user*
AdoreMixNSP.pro.user
ForAvderMediaCore.pro.user
ForAvderMediaCoremut.pro.user
# 这些是已经编译好的二进制，不需要带进构建
AdoreMixV8*_console_*
AdoreMix64_V8*
**/build-*/**/*
EOF

function cleanup_dockerignore() {
  if [ -f "$DOCKERIGNORE" ]; then
    rm -f "$DOCKERIGNORE"
  fi
}
trap cleanup_dockerignore EXIT

cd "$REPO_ROOT"
docker buildx build \
  --platform linux/arm64 \
  --tag "$IMAGE_TAG" \
  --file docker/Dockerfile.linux-arm64 \
  --load \
  "$SRC_DIR"

if [ "$EXTRACT" -eq 0 ]; then
  echo ""
  echo "==> 完成（未提取产物）。手工提取："
  echo "    docker create --name tmp $IMAGE_TAG"
  echo "    docker cp tmp:/out ./workspaces/linux-arm64/native"
  exit 0
fi

# 7) 提取产物
NATIVE_DIR="$REPO_ROOT/workspaces/linux-arm64/native"
echo ""
echo "==> 提取 /out -> $NATIVE_DIR"

TMP_CID=$(docker create "$IMAGE_TAG")
function cleanup() {
  docker rm -f "$TMP_CID" >/dev/null 2>&1 || true
}
trap cleanup EXIT

# 清空旧产物（保留 README.md）
mkdir -p "$NATIVE_DIR"
find "$NATIVE_DIR" -mindepth 1 ! -name README.md -delete 2>/dev/null || true

docker cp "$TMP_CID:/out/." "$NATIVE_DIR/"

# 8) 修正权限（Linux 二进制 +x）
chmod 0755 "$NATIVE_DIR"/AdoreMix* 2>/dev/null || true
chmod 0755 "$NATIVE_DIR/lame" 2>/dev/null || true

# 9) 校验
echo ""
echo "==> 产物清单："
ls -lh "$NATIVE_DIR" | head -20
echo ""
TOTAL=$(du -sh "$NATIVE_DIR" 2>/dev/null | cut -f1)
echo "==> 总大小：$TOTAL"
echo ""
echo "完成。下一步："
echo "  1. 验证架构：file workspaces/linux-arm64/native/AdoreMixV8.0.17_console_linuxarm64"
echo "  2. 本地 install 测试（需要在 ARM64 Linux 主机上）"
echo "  3. npm publish（CI 自动）"
