#!/usr/bin/env bash
#
# 用主机上的 D:/QTS/5.15.2/mingw81_64 直接编译 Windows x64 AdoreMix。
# 不走 Docker，速度快（5-10 分钟）。
#
# 前置：D:/QTS 已安装 5.15.2/mingw81_64 组件

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

SRC_DIR="${SRC_DIR:-D:/zhuangyi/vbox/Adore_mix2}"
QT_ROOT="${QT_ROOT:-D:/QTS/5.15.2/mingw81_64}"
MINGW_BIN="${MINGW_BIN:-D:/QTS/Tools/mingw810_64/bin}"
TARGET_BIN="AdoreMixV8X.exe"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --src) SRC_DIR="$2"; shift 2 ;;
    --qt) QT_ROOT="$2"; shift 2 ;;
    --mingw) MINGW_BIN="$2"; shift 2 ;;
    -h|--help) sed -n '2,15p' "$0"; exit 0 ;;
    *) echo "未知参数: $1"; exit 1 ;;
  esac
done

QMAKE="$QT_ROOT/bin/qmake.exe"
MINGW_MAKE="$MINGW_BIN/mingw32-make.exe"
WINDEPLOYQT="$QT_ROOT/bin/windeployqt.exe"
MINGW_MAKE_WIN=$(cygpath -w "$MINGW_MAKE")

echo "==> 源码目录：$SRC_DIR"
echo "==> Qt root：$QT_ROOT"
echo "==> MinGW：$MINGW_BIN"
echo "==> 目标二进制：$TARGET_BIN"

[ -d "$SRC_DIR" ] || { echo "错误：源码目录不存在" >&2; exit 1; }
[ -f "$QMAKE" ] || { echo "错误：qmake 不存在：$QMAKE" >&2; exit 1; }
[ -f "$MINGW_MAKE" ] || { echo "错误：mingw32-make 不存在：$MINGW_MAKE" >&2; exit 1; }

# 关键：必须用 cmd /c 启动纯净 PATH 跑 mingw32-make
# 否则 Strawberry Perl 的 g++ 4.9.2 / 老 dll 会先被找到，导致 mingw 8.1 g++ 启动 crash 且无错误输出
WIN_PATH="PATH=$MINGW_BIN;C:\\Windows\\System32;C:\\Windows;C:\\Windows\\System32\\Wbem"
echo "==> 用纯净 PATH 跑 mingw32-make（绕开 Strawberry Perl 干扰）"

# 0) 清理残留（Linux ELF 不能给 Windows mingw 用，必须删）
echo ""
echo "==> 清理旧编译产物..."
find "$SRC_DIR" \( \
  -name '.qmake.stash' -o \
  -name '*.pro.user' -o \
  -name '*.pro.user.*' -o \
  -name 'Makefile' -o \
  -name 'Makefile.Debug' -o \
  -name 'Makefile.Release' -o \
  -name '.moc' -o \
  -name '.uic' -o \
  -name '.rcc' -o \
  -name '.obj' -o \
  -name 'mkspecs' -o \
  -name 'build-*' -o \
  -name 'debug' -o \
  -name 'release' -o \
  -name '*.o' -o \
  -name '*.obj' -o \
  -name '*.a' \
\) -prune -exec rm -rf {} + 2>/dev/null || true

# 1) 修复 .pro 的 TARGET + 删硬编码 ARM 路径 + 直接传 -std=gnu++17
#    Qt 5.15.2 的 qmetatype.h 在 C++11 下触发 ContainerCapabilitiesImpl 模板歧义
#    不能用 CONFIG += c++17（qmake 会翻译成 -std=gnu++1z，mingw 8.1 不识别）
echo "==> 修复 AdoreMix.pro..."
cd "$SRC_DIR"
sed -i \
  -e 's|-L/opt/qt5\.[0-9][^ ]*plugins/sqldrivers||g' \
  -e 's|AdoreMixV8\.0\.17_console_linuxarm0|'${TARGET_BIN%.exe}'|g' \
  -e 's|CONFIG += c++11|QMAKE_CXXFLAGS += -std=gnu++17|g' \
  AdoreMix.pro
# 若 .pro 里没有 -std=gnu++17，追加
grep -q 'gnu++17' AdoreMix.pro || echo 'QMAKE_CXXFLAGS += -std=gnu++17' >> AdoreMix.pro
grep -E '^(TARGET|CONFIG|LIBS|QMAKE)' AdoreMix.pro

# 1.5) 修复 main.cpp 的 64 位 cast 错误 + QtWebWeb 的 sslCaCertFileName 笔误
sed -i 's|(uint)record->ExceptionAddress|(quintptr)record->ExceptionAddress|g' main.cpp
sed -i 's|sslCaCertFileName|sslCertFileName|g' httpserver/httpconnectionhandlerpool.cpp
grep -n "quintptr.*ExceptionAddress" main.cpp || echo "(未修改 main.cpp)"
grep -n "sslCertFileName" httpserver/httpconnectionhandlerpool.cpp | head -3

# 2) 先编译 QtCipherSqlitePlugin（生成 sqlitecipher.dll + .dll.a）
echo ""
echo "==> 编译 QtCipherSqlitePlugin..."
CIPHER_DIR="$SRC_DIR/QtCipherSqlitePlugin-develop/QtCipherSqlitePlugin-develop/sqlitecipher"
if [ -d "$CIPHER_DIR" ]; then
  find "$SRC_DIR/QtCipherSqlitePlugin-develop" -name 'Makefile*' -delete 2>/dev/null || true
  cd "$CIPHER_DIR"
  "$QMAKE" sqlitecipher.pro
  # 写死编译器路径
  for mk in Makefile.Release Makefile.Debug Makefile; do
    [ -f "$CIPHER_DIR/$mk" ] || continue
    sed -i \
      -e "s|^CXX\s*= g++|CXX = $MINGW_BIN/g++.exe|g" \
      -e "s|^CC\s*= gcc|CC = $MINGW_BIN/gcc.exe|g" \
      -e "s|^LINK\s*= g++|LINK = $MINGW_BIN/g++.exe|g" \
      "$CIPHER_DIR/$mk"
  done
  CIPHER_BAT=/tmp/adoremix-cipher.bat
  CIPHER_DIR_WIN=$(cygpath -w "$CIPHER_DIR")
  cat > "$CIPHER_BAT" <<EOF
@echo off
set PATH=$MINGW_BIN;C:\Windows\System32;C:\Windows;C:\Windows\System32\Wbem
cd /d "$CIPHER_DIR_WIN"
"$MINGW_MAKE_WIN" -f Makefile.Release
EOF
  cmd //c "$(cygpath -w "$CIPHER_BAT")" 2>&1 | tail -15 || true
  # 拷产物到 mingw lib（link 时用）+ Qt plugins（运行时用）
  QT_PLUGINS_WIN=$("$QMAKE" -query QT_INSTALL_PLUGINS)
  CIPHER_OUT="$CIPHER_DIR/plugins/sqldrivers"
  if [ -f "$CIPHER_OUT/libsqlitecipher.a" ]; then
    # mingw ld 找 -lsqlitecipher 时搜索 $MINGW_BIN/../lib/ 和 x86_64-w64-mingw32/lib/
    mkdir -p "$MINGW_BIN/../lib" "$MINGW_BIN/../x86_64-w64-mingw32/lib"
    cp "$CIPHER_OUT/libsqlitecipher.a" "$MINGW_BIN/../lib/"
    cp "$CIPHER_OUT/libsqlitecipher.a" "$MINGW_BIN/../x86_64-w64-mingw32/lib/"
    echo "==> 拷 libsqlitecipher.a -> mingw lib + x86_64-w64-mingw32/lib"
  fi
  if [ -f "$CIPHER_OUT/sqlitecipher.dll" ]; then
    mkdir -p "$QT_PLUGINS_WIN/sqldrivers/"
    cp "$CIPHER_OUT/sqlitecipher.dll" "$QT_PLUGINS_WIN/sqldrivers/"
    echo "==> 拷 sqlitecipher.dll -> Qt plugins"
  fi
  echo "=== QtCipherSqlitePlugin 产物 ==="
  ls "$CIPHER_OUT/" 2>/dev/null | head -10
  cd "$SRC_DIR"
fi

# 3) qmake 主程序
echo ""
echo "==> qmake AdoreMix..."
"$QMAKE" -spec win32-g++ AdoreMix.pro

# 3.5) 写死编译器路径
for mk in Makefile.Release Makefile.Debug Makefile; do
  [ -f "$SRC_DIR/$mk" ] || continue
  sed -i \
    -e "s|^CXX\s*= g++|CXX = $MINGW_BIN/g++.exe|g" \
    -e "s|^CC\s*= gcc|CC = $MINGW_BIN/gcc.exe|g" \
    -e "s|^LINK\s*= g++|LINK = $MINGW_BIN/g++.exe|g" \
    -e "s|^QMAKE\s*= qmake|QMAKE = $QMAKE|g" \
    "$SRC_DIR/$mk"
done

# 4) 编译主程序
echo ""
echo "==> make AdoreMix（5-10 分钟）..."
MINGW_MAKE_WIN=$(cygpath -w "$MINGW_MAKE")
SRC_DIR_WIN=$(cygpath -w "$SRC_DIR")
BAT=/tmp/adoremix-build.bat
cat > "$BAT" <<EOF
@echo off
set PATH=$MINGW_BIN;C:\Windows\System32;C:\Windows;C:\Windows\System32\Wbem
cd /d "$SRC_DIR_WIN"
"$MINGW_MAKE_WIN" -f Makefile.Release
EOF
cmd //c "$(cygpath -w "$BAT")" 2>&1 || true

# 检查二进制是否生成
EXE_PATH=""
for p in "./release/$TARGET_BIN" "./$TARGET_BIN"; do
  if [ -f "$p" ]; then
    EXE_PATH="$p"
    break
  fi
done
if [ -z "$EXE_PATH" ]; then
  echo "错误：$TARGET_BIN 未生成，请检查 make 输出" >&2
  exit 1
fi
echo ""
echo "==> 编译成功：$EXE_PATH"
ls -la "$EXE_PATH"

# 4) 收集产物
NATIVE_DIR="$REPO_ROOT/workspaces/win32-x64/native"
echo ""
echo "==> 收集到 $NATIVE_DIR ..."
rm -rf "$NATIVE_DIR"
mkdir -p "$NATIVE_DIR"

# 拷 exe + Qt DLL + plugins（windeployqt 自动处理）
cp "$EXE_PATH" "$NATIVE_DIR/"
echo "==> windeployqt 收集依赖..."
"$WINDEPLOYQT" --release --no-translations --no-system-d3d-compiler \
  --compiler-runtime --no-opengl-sw "$NATIVE_DIR/$TARGET_BIN" 2>&1 | tail -20

# Qt5 Multimedia 等额外 plugins
for sub in platforms sqldrivers bearer iconengines imageformats mediaservice audio; do
  if [ -d "$QT_ROOT/plugins/$sub" ]; then
    mkdir -p "$NATIVE_DIR/$sub"
    cp -r "$QT_ROOT/plugins/$sub/"* "$NATIVE_DIR/$sub/" 2>/dev/null || true
  fi
done

# 瘦身：删除 debug 符号（.dll.debug / .pdb）和备份目录
echo "==> 瘦身（删 debug 符号 + 备份）..."
find "$NATIVE_DIR" -name "*.dll.debug" -delete 2>/dev/null || true
find "$NATIVE_DIR" -name "*.pdb" -delete 2>/dev/null || true
find "$NATIVE_DIR" -name "*.exe.debug" -delete 2>/dev/null || true
rm -rf "$NATIVE_DIR/etc/docroot_" 2>/dev/null || true   # 备份目录，非业务用
echo "    清理完成"

# qt.conf
printf '[Paths]\r\nPlugins=./\r\n' > "$NATIVE_DIR/qt.conf"

# 业务资源
for d in etc conf html; do
  if [ -d "$SRC_DIR/$d" ]; then
    cp -r "$SRC_DIR/$d" "$NATIVE_DIR/$d"
  fi
done
for f in tts.js find.js findsc.js xiaoboshu.py; do
  [ -f "$SRC_DIR/$f" ] && cp "$SRC_DIR/$f" "$NATIVE_DIR/"
done

# 元信息
cat > "$NATIVE_DIR/.adoremix-native.json" <<EOF
{"version":"8.0.17","platform":"win32","arch":"x64","bin":"$TARGET_BIN","builtAt":"$(date -u +%Y-%m-%dT%H:%M:%SZ)"}
EOF

# 空目录
for d in var logs dmp tty temp; do
  mkdir -p "$NATIVE_DIR/$d"
done

echo ""
echo "==> 产物清单："
ls -lh "$NATIVE_DIR" | head -20
TOTAL=$(du -sh "$NATIVE_DIR" 2>/dev/null | cut -f1)
echo "==> 总大小：$TOTAL"
echo "完成。"
