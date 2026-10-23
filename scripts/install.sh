#!/usr/bin/env bash
# AdoreMix 一键安装脚本（Linux x64/arm64/armv7、macOS arm64）
#
# 用法：
#   curl -fsSL https://raw.githubusercontent.com/oxiaom/adoremix-npm/main/scripts/install.sh | bash
#   curl -fsSL .../install.sh | bash -s -- --version 1.0.76
#
# 环境变量：
#   ADOREMIX_VERSION       指定 @oxiaom/adoremix 版本（默认 latest）
#   ADOREMIX_SKIP_START    1 = 安装后不启动
#   ADOREMIX_SERVICE       auto(默认，root/systemd 时注册服务) | yes | no
#   ADOREMIX_NPM_REGISTRY  可选 npm 源，如 https://registry.npmmirror.com
#   ADOREMIX_NODE_MAJOR    自动安装 Node 的大版本（默认 20）
#   ADOREMIX_DRY_RUN       1 = 只打印将执行的操作
set -euo pipefail

VERSION="${ADOREMIX_VERSION:-latest}"
SKIP_START="${ADOREMIX_SKIP_START:-0}"
SERVICE="${ADOREMIX_SERVICE:-auto}"
NPM_REGISTRY="${ADOREMIX_NPM_REGISTRY:-}"
NODE_MAJOR="${ADOREMIX_NODE_MAJOR:-20}"
DRY_RUN="${ADOREMIX_DRY_RUN:-0}"

NODE_DIR="$HOME/.local/adoremix-node"
MARK_BEGIN="# >>> adoremix installer >>>"
MARK_END="# <<< adoremix installer <<<"

if [ -t 1 ]; then
  C_G="\033[32m"; C_Y="\033[33m"; C_R="\033[31m"; C_C="\033[36m"; C_0="\033[0m"
else
  C_G=""; C_Y=""; C_R=""; C_C=""; C_0=""
fi
ok()   { printf "${C_G}✓${C_0} %s\n" "$*"; }
info() { printf "${C_C}→${C_0} %s\n" "$*"; }
warn() { printf "${C_Y}!${C_0} %s\n" "$*" >&2; }
die()  { printf "${C_R}✗ %s${C_0}\n" "$*" >&2; exit 1; }
run()  { if [ "$DRY_RUN" = "1" ]; then echo "  [dry-run] $*"; else "$@"; fi; }

need_root_hint() {
  warn "需要管理员权限。请用 sudo 重新执行，或手动安装后重试："
  warn "  sudo bash install.sh"
}

# ---------- 基础探测 ----------
OS="$(uname -s)"
case "$OS" in
  Linux)  NODE_PLAT="linux" ;;
  Darwin) NODE_PLAT="darwin" ;;
  *) die "不支持的系统：$OS（仅支持 Linux / macOS arm64）" ;;
esac

ARCH="$(uname -m)"
case "$ARCH" in
  x86_64|amd64)        NODE_ARCH="x64";   ADOREMIX_PLAT="linux-x64" ;;
  aarch64|arm64)       NODE_ARCH="arm64"; ADOREMIX_PLAT="linux-arm64" ;;
  armv7l|armv6l)       NODE_ARCH="armv7l";ADOREMIX_PLAT="linux-arm" ;;
  *) die "不支持的 CPU 架构：$ARCH" ;;
esac

if [ "$OS" = "Darwin" ]; then
  [ "$NODE_ARCH" = "arm64" ] || die "macOS 仅支持 Apple Silicon（arm64），Intel Mac 已不再提供安装包"
  ADOREMIX_PLAT="darwin-arm64"
fi

if command -v curl >/dev/null 2>&1; then
  fetch() { curl -fsSL --retry 3 --connect-timeout 15 "$1"; }
  download() { curl -fL --retry 3 --connect-timeout 15 -o "$2" "$1"; }
elif command -v wget >/dev/null 2>&1; then
  fetch() { wget -q -O - "$1"; }
  download() { wget -q -O "$2" "$1"; }
else
  die "缺少 curl/wget。请先安装：apt install -y curl 或 yum install -y curl"
fi

version_ge() { # $1 = 当前版本，$2 = 要求版本（awk 实现，兼容 macOS）
  awk -v a="$1" -v b="$2" 'BEGIN{
    n=split(a,x,"."); m=split(b,y,".");
    for(i=1;i<=3;i++){ if((x[i]+0)>(y[i]+0)) exit 0; if((x[i]+0)<(y[i]+0)) exit 1 }
    exit 0
  }'
}

sha256_of() { # 兼容 Linux(sha256sum) / macOS(shasum)
  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum "$1" | awk '{print $1}'
  else
    shasum -a 256 "$1" | awk '{print $1}'
  fi
}

node_ok() {
  command -v node >/dev/null 2>&1 || return 1
  local v
  v="$(node -p 'process.versions.node' 2>/dev/null || true)"
  [ -n "$v" ] || return 1
  version_ge "$v" "18.0.0"
}

persist_path() {
  local rc
  for rc in "$HOME/.bashrc" "$HOME/.profile" "$HOME/.zshrc"; do
    [ -e "$rc" ] || continue
    grep -qF "$MARK_BEGIN" "$rc" 2>/dev/null && continue
    {
      echo ""
      echo "$MARK_BEGIN"
      echo 'export PATH="$HOME/.local/adoremix-node/bin:$HOME/.local/bin:$PATH"'
      echo "$MARK_END"
    } >> "$rc"
  done
}

install_node_portable() {
  local mirror sums file url tmp
  if [ "$DRY_RUN" = "1" ]; then
    echo "  [dry-run] 将安装 Node.js v${NODE_MAJOR}.x 到 $NODE_DIR"
    return 0
  fi
  info "未检测到 Node.js 18+，开始自动安装 Node.js v${NODE_MAJOR}.x（用户目录，无需 root）"
  for mirror in "${ADOREMIX_NODE_MIRROR:-https://npmmirror.com/mirrors/node}" "https://nodejs.org/dist"; do
    info "尝试下载源：$mirror"
    sums="$(fetch "$mirror/latest-v${NODE_MAJOR}.x/SHASUMS256.txt" 2>/dev/null || true)"
    [ -n "$sums" ] || continue
    file="$(printf '%s\n' "$sums" | grep -o "node-v[0-9.]*-${NODE_PLAT}-${NODE_ARCH}\.tar\.gz" | head -n1 || true)"
    [ -n "$file" ] || continue
    url="$mirror/latest-v${NODE_MAJOR}.x/$file"
    tmp="$(mktemp -d)"
    info "下载 $file"
    download "$url" "$tmp/$file" || { rm -rf "$tmp"; continue; }
    local want got
    want="$(printf '%s\n' "$sums" | grep " $file\$" | awk '{print $1}')"
    got="$(sha256_of "$tmp/$file" 2>/dev/null || true)"
    if [ -n "$want" ] && [ "$want" != "$got" ]; then
      rm -rf "$tmp"; warn "校验失败：$file"; continue
    fi
    mkdir -p "$NODE_DIR"
    run rm -rf "$NODE_DIR"
    run mkdir -p "$NODE_DIR"
    run tar -xzf "$tmp/$file" -C "$NODE_DIR" --strip-components=1
    rm -rf "$tmp"
    export PATH="$NODE_DIR/bin:$PATH"
    persist_path
    ok "Node.js $(node -v) 安装到 $NODE_DIR"
    return 0
  done
  die "Node.js 自动安装失败。请手动安装 Node 18+（https://nodejs.org）后重试"
}

ensure_node() {
  if node_ok; then
    ok "Node.js $(node -v) 已就绪"
    return
  fi
  if command -v node >/dev/null 2>&1; then
    warn "检测到 $(node -v)，低于 18，将安装独立的新版本（不影响系统 Node）"
  fi
  install_node_portable
}

ensure_npm_prefix() {
  local prefix
  prefix="$(npm config get prefix 2>/dev/null || echo /usr/local)"
  if [ "$(id -u)" = "0" ]; then
    ok "npm 全局目录：$prefix（root）"
    return
  fi
  if [ -w "$prefix" ]; then
    ok "npm 全局目录可写：$prefix"
    return
  fi
  info "npm 全局目录 $prefix 不可写，切换到 ~/.local（无需 sudo）"
  run npm config set prefix "$HOME/.local"
  run mkdir -p "$HOME/.local/bin"
  export PATH="$HOME/.local/bin:$PATH"
  persist_path
}

start_or_service() {
  local root=0 systemd=0
  [ "$(id -u)" = "0" ] && root=1
  if command -v systemctl >/dev/null 2>&1 && [ -d /run/systemd/system ]; then
    systemd=1
  fi

  if [ "$SKIP_START" = "1" ]; then
    warn "已跳过启动（ADOREMIX_SKIP_START=1）"
    return
  fi

  if [ "$SERVICE" != "no" ] && [ "$root" = "1" ] && [ "$systemd" = "1" ]; then
    info "注册开机自启服务（systemd）"
    if run "$ADOREMIX_BIN" service install; then
      ok "服务已注册并启动：systemctl status adoremix"
      return
    fi
    warn "服务注册失败，改为后台启动"
  elif [ "$SERVICE" = "yes" ]; then
    warn "非 root 或非 systemd 环境，无法注册系统服务"
  fi

  info "后台启动 AdoreMix"
  run "$ADOREMIX_BIN" start --daemon || warn "启动失败，请查看：adoremix logs"
}

main() {
  echo ""
  echo "=============================================="
  echo "  AdoreMix 一键安装（$OS $ARCH）"
  echo "=============================================="
  echo ""

  ensure_node
  ensure_npm_prefix

  local npm_args=(-g "@oxiaom/adoremix@${VERSION}")
  if [ -n "$NPM_REGISTRY" ]; then
    npm_args+=(--registry "$NPM_REGISTRY")
  fi
  info "安装 @oxiaom/adoremix@${VERSION}（平台包 ${ADOREMIX_PLAT}）"
  run npm install "${npm_args[@]}"

  if [ "$DRY_RUN" = "1" ]; then
    echo "  [dry-run] 到此为止（ADOREMIX_DRY_RUN=1）"
    return
  fi

  ADOREMIX_BIN="$(command -v adoremix || true)"
  if [ -z "$ADOREMIX_BIN" ]; then
    local prefix
    prefix="$(npm config get prefix 2>/dev/null)"
    [ -x "$prefix/bin/adoremix" ] && ADOREMIX_BIN="$prefix/bin/adoremix"
  fi
  [ -n "$ADOREMIX_BIN" ] || die "安装完成但未找到 adoremix 命令，请检查 PATH（$HOME/.local/bin 或 npm 全局 bin）"
  ok "adoremix 已安装：$ADOREMIX_BIN"

  info "初始化工作目录与默认配置"
  "$ADOREMIX_BIN" install --no-interactive || warn "初始化返回非 0，继续"

  local cur_ip
  cur_ip="$("$ADOREMIX_BIN" config get Settings.LocalIP 2>/dev/null | awk -F' = ' '{print $2}' | tr -d '\r' || true)"
  if [ -z "$cur_ip" ] || [ "$cur_ip" = "127.0.0.1" ]; then
    info "自动选择网卡 IP（设备连接地址）"
    run "$ADOREMIX_BIN" config network --no-interactive || warn "网络配置失败，可稍后执行：adoremix config network"
  else
    ok "设备连接 IP：$cur_ip"
  fi

  info "环境体检"
  run "$ADOREMIX_BIN" doctor || warn "doctor 有告警，请按提示处理"

  start_or_service

  local ip
  ip="$("$ADOREMIX_BIN" config get Settings.LocalIP 2>/dev/null | awk -F' = ' '{print $2}' | tr -d '\r' || true)"
  [ -n "$ip" ] || ip="127.0.0.1"
  echo ""
  ok "安装完成！"
  echo "  WebUI：   http://${ip}:12080/"
  echo "  状态：    adoremix status"
  echo "  日志：    adoremix logs -f"
  echo "  配置：    adoremix config"
  echo ""
}

main "$@"
