#!/usr/bin/env bash
#
# 一键发版：bump 版本 + commit + tag + push（触发 GitHub Actions release.yml）
#
# 用法：
#   ./scripts/release.sh 1.0.2              # 发 v1.0.2
#   ./scripts/release.sh 1.0.2 --yes        # 跳过确认
#   ./scripts/release.sh patch              # 自动 1.0.1 → 1.0.2
#   ./scripts/release.sh minor              # 自动 1.0.1 → 1.1.0
#   ./scripts/release.sh major              # 自动 1.0.1 → 2.0.0
#   ./scripts/release.sh 1.0.2 --dry-run    # 预览不执行

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$REPO_ROOT"

# ---- 解析参数 ----
VERSION=""
BUMP_KIND=""
DRY_RUN=0
ASSUME_YES=0

for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=1 ;;
    --yes|-y) ASSUME_YES=1 ;;
    patch|minor|major) BUMP_KIND="$arg" ;;
    -h|--help)
      sed -n '2,15p' "$0"
      exit 0
      ;;
    *) VERSION="$arg" ;;
  esac
done

# ---- 计算目标版本 ----
CURRENT=$(node -p "require('./workspaces/adoremix/package.json').version")
echo "当前版本：v$CURRENT"

if [ -n "$BUMP_KIND" ] && [ -z "$VERSION" ]; then
  VERSION=$(node -e "
    const v = '$CURRENT'.split('.').map(Number);
    const kind = '$BUMP_KIND';
    if (kind === 'patch') v[2]++;
    else if (kind === 'minor') { v[1]++; v[2] = 0; }
    else if (kind === 'major') { v[0]++; v[1] = 0; v[2] = 0; }
    console.log(v.join('.'));
  ")
  echo "Bump $BUMP_KIND → v$VERSION"
elif [ -n "$VERSION" ]; then
  # 验证 semver
  if ! echo "$VERSION" | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+$'; then
    echo "❌ 版本号格式错误（应为 X.Y.Z）：$VERSION" >&2
    exit 1
  fi
else
  echo "用法：$0 <版本号|patch|minor|major> [--yes] [--dry-run]" >&2
  exit 1
fi

if [ "$VERSION" = "$CURRENT" ]; then
  echo "❌ 新版本跟当前一样" >&2
  exit 1
fi

# ---- git 状态检查 ----
if [ "$DRY_RUN" -eq 0 ]; then
  if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "❌ 当前目录不是 git 仓库" >&2
    exit 1
  fi
  if [ -n "$(git status --porcelain --untracked-files=no 2>/dev/null)" ]; then
    echo "⚠️  工作区有未提交改动："
    git status --short
    if [ "$ASSUME_YES" -ne 1 ]; then
      read -p "继续会把这些一起 commit，是否继续？(y/N) " ans
      [ "$ans" = "y" ] || { echo "已取消"; exit 0; }
    fi
  fi
  BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "")
  if [ "$BRANCH" != "main" ] && [ "$BRANCH" != "master" ]; then
    echo "⚠️  当前分支：$BRANCH（建议在 main 上发版）"
    [ "$ASSUME_YES" -ne 1 ] && { read -p "继续？(y/N) " ans; [ "$ans" = "y" ] || exit 0; }
  fi
fi

# ---- 同步 7 个 package.json 版本（dry-run 跳过）----
if [ "$DRY_RUN" -eq 1 ]; then
  echo ""
  echo "[dry-run] 预览模式：不修改文件，不 push"
  echo "  将修改 8 个 package.json 的 version: $CURRENT → $VERSION"
  echo "  将 git commit -m 'release: v$VERSION' + tag v$VERSION + push"
  exit 0
fi

echo ""
echo "==> 同步版本号到 v$VERSION ..."
node -e "
  const fs = require('fs');
  const path = require('path');
  const ROOT = process.cwd();
  const targets = [
    'package.json',
    'workspaces/adoremix/package.json',
    'workspaces/win32-x64/package.json',
    'workspaces/linux-x64/package.json',
    'workspaces/linux-arm64/package.json',
    'workspaces/linux-arm/package.json',
    'workspaces/darwin-x64/package.json',
    'workspaces/darwin-arm64/package.json'
  ];
  for (const rel of targets) {
    const p = path.join(ROOT, rel);
    const obj = JSON.parse(fs.readFileSync(p, 'utf8'));
    obj.version = '$VERSION';
    fs.writeFileSync(p, JSON.stringify(obj, null, 2) + '\n', 'utf8');
    console.log('  ' + rel);
  }
"

# ---- 预览 ----
echo ""
echo "=== git diff 预览 ==="
git diff --stat package.json workspaces/*/package.json 2>/dev/null || true

# ---- 确认 ----
if [ "$ASSUME_YES" -ne 1 ]; then
  echo ""
  read -p "确认发布 v$VERSION（将 push 并触发 CI 发 npm）？(y/N) " ans
  [ "$ans" = "y" ] || { echo "已取消"; exit 0; }
fi

# ---- 执行 ----
echo ""
echo "==> git commit + tag + push"
git add -A
git commit -m "release: v$VERSION"

# 强制 tag（如果之前不小心创建过）
git tag -f "v$VERSION"
git push origin "$BRANCH"
git push origin "v$VERSION"

echo ""
echo "✅ 完成。GitHub Actions 会自动触发 release.yml，发布 7 个包到 npm。"
echo ""
echo "查看进度："
REMOTE=$(git config --get remote.origin.url 2>/dev/null | sed 's|.*github.com[:/]||; s|\.git$||')
[ -n "$REMOTE" ] && echo "  https://github.com/$REMOTE/actions"
echo ""
echo "等 CI 跑完后（约 5-10 分钟），客户即可安装："
echo "  npm install -g @oxiaom/adoremix"
