#!/usr/bin/env bash
#
# 在 x64 主机上用 docker buildx + QEMU 跨架构编译 Linux ARM (armhf / armv7) AdoreMix。
# 比 ARM64 还慢一点（armv7 是 32 位，寄存器少）。

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

SRC_DIR="${SRC_DIR:-D:/zhuangyi/vbox/Adore_mix2}"
IMAGE_TAG="adoremix-arm-builder:latest"
EXTRACT=1

while [[ $# -gt 0 ]]; do
  case "$1" in
    --src) SRC_DIR="$2"; shift 2 ;;
    --tag) IMAGE_TAG="$2"; shift 2 ;;
    --no-extract) EXTRACT=0; shift ;;
    -h|--help) sed -n '2,15p' "$0"; exit 0 ;;
    *) echo "未知参数: $1"; exit 1 ;;
  esac
done

echo "==> 源码目录：$SRC_DIR"
echo "==> 镜像 tag：$IMAGE_TAG"

[ -d "$SRC_DIR" ] || { echo "错误：源码目录不存在" >&2; exit 1; }
command -v docker >/dev/null 2>&1 || { echo "错误：未找到 docker" >&2; exit 1; }

docker buildx use desktop-linux 2>/dev/null || docker buildx use default 2>/dev/null || true

# QEMU 验证（arm/v7 模拟）
if ! docker run --rm --platform linux/arm/v7 arm32v7/ubuntu:22.04 uname -m >/dev/null 2>&1; then
  echo "==> QEMU 未就绪，注册..."
  docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
fi
ARCH=$(docker run --rm --platform linux/arm/v7 arm32v7/ubuntu:22.04 uname -m)
if [ "$ARCH" != "armv7l" ]; then
  echo "错误：ARM 模拟返回 $ARCH，预期 armv7l" >&2
  exit 1
fi
echo "==> ARM (armhf) 模拟 OK ($ARCH)"

DOCKERIGNORE="$SRC_DIR/.dockerignore"
cat > "$DOCKERIGNORE" <<'EOF'
debug release build-* *.o *.obj *.pdb *.zip *.rar *.tgz *.tar.gz *.7z *.img
*.exe.debug *.dll.debug node_modules node_modules.rar package-lock.json
logs temp dmp tty var *.log reqhttp.log .git .gitignore .DS_Store Thumbs.db
a.out Makefile Makefile.Debug Makefile.Release
**/moc_*.cpp **/qrc_*.cpp **/ui_*.h **/*.pro.user*
AdoreMixNSP.pro.user ForAvderMediaCore.pro.user ForAvderMediaCoremut.pro.user
AdoreMixV8*_console_* AdoreMix64_V8* **/build-*/**/*
EOF

echo ""
echo "==> 构建 ARM (armhf) 镜像（首次约 20-40 分钟，QEMU 模拟）..."
cd "$REPO_ROOT"

if [ "$EXTRACT" -eq 0 ]; then
  trap 'rm -f "$DOCKERIGNORE"' EXIT
  docker buildx build --platform linux/arm/v7 --tag "$IMAGE_TAG" \
    --file docker/Dockerfile.linux-arm --load "$SRC_DIR"
  exit 0
fi

TMP_CID=$(docker create "${IMAGE_TAG}:placeholder" 2>/dev/null || echo "")
trap 'rm -f "$DOCKERIGNORE"; [ -n "$TMP_CID" ] && docker rm -f "$TMP_CID" >/dev/null 2>&1 || true' EXIT

docker buildx build --platform linux/arm/v7 --tag "$IMAGE_TAG" \
  --file docker/Dockerfile.linux-arm --load "$SRC_DIR"

NATIVE_DIR="$REPO_ROOT/workspaces/linux-arm/native"
echo ""
echo "==> 提取 /out -> $NATIVE_DIR"

TMP_CID=$(docker create "$IMAGE_TAG")
mkdir -p "$NATIVE_DIR"
find "$NATIVE_DIR" -mindepth 1 ! -name README.md -delete 2>/dev/null || true
docker cp "$TMP_CID:/out/." "$NATIVE_DIR/"

chmod 0755 "$NATIVE_DIR"/AdoreMix* 2>/dev/null || true
chmod 0755 "$NATIVE_DIR/lame" 2>/dev/null || true

echo ""
echo "==> 产物清单："
ls -lh "$NATIVE_DIR" | head -20
TOTAL=$(du -sh "$NATIVE_DIR" 2>/dev/null | cut -f1)
echo "==> 总大小：$TOTAL"
echo "完成。"
