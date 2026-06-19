#!/usr/bin/env bash
#
# 在 x64 主机上 native 编译 Linux x64 AdoreMix（无需 QEMU）。
# 比 ARM64 快 5-10 倍（x64 native，不走 QEMU 翻译）。

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

SRC_DIR="${SRC_DIR:-D:/zhuangyi/vbox/Adore_mix2}"
IMAGE_TAG="adoremix-x64-builder:latest"
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

[ -d "$SRC_DIR" ] || { echo "错误：源码目录不存在：$SRC_DIR" >&2; exit 1; }
command -v docker >/dev/null 2>&1 || { echo "错误：未找到 docker" >&2; exit 1; }

docker buildx use desktop-linux 2>/dev/null || docker buildx use default 2>/dev/null || true

# 临时 .dockerignore
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
trap 'rm -f "$DOCKERIGNORE"' EXIT

echo ""
echo "==> 构建 x64 镜像（首次约 5-10 分钟，x64 native 无 QEMU）..."
cd "$REPO_ROOT"
docker buildx build \
  --platform linux/amd64 \
  --tag "$IMAGE_TAG" \
  --file docker/Dockerfile.linux-x64 \
  --load \
  "$SRC_DIR"

if [ "$EXTRACT" -eq 0 ]; then
  echo "完成（未提取产物）"
  exit 0
fi

NATIVE_DIR="$REPO_ROOT/workspaces/linux-x64/native"
echo ""
echo "==> 提取 /out -> $NATIVE_DIR"

TMP_CID=$(docker create "$IMAGE_TAG")
trap 'docker rm -f "$TMP_CID" >/dev/null 2>&1 || true; rm -f "$DOCKERIGNORE"' EXIT

mkdir -p "$NATIVE_DIR"
find "$NATIVE_DIR" -mindepth 1 ! -name README.md -delete 2>/dev/null || true
docker cp "$TMP_CID:/out/." "$NATIVE_DIR/"

chmod 0755 "$NATIVE_DIR"/AdoreMix* 2>/dev/null || true
chmod 0755 "$NATIVE_DIR/lame" 2>/dev/null || true

echo ""
echo "==> 产物清单："
ls -lh "$NATIVE_DIR" | head -20
echo ""
TOTAL=$(du -sh "$NATIVE_DIR" 2>/dev/null | cut -f1)
echo "==> 总大小：$TOTAL"
echo "完成。"
