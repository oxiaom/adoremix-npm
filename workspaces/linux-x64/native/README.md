# AdoreMix linux-x64 原生包

本目录存放 Linux x64 平台的二进制和运行时资源。

## 预期内容

由 `scripts/split-zip.js` 从 `D:/zhuangyi/vbox/AdoreMIXMICV8linux8.10.zip` 拆出并放入：

- `AdoreMix64_V8.06` - C++ 主程序
- `lame` (MP3 编码器)
- Qt5 共享库（`.so`，可能通过 linuxdeployqt 打包到 lib/ 或同级）
- `platforms/`, `sqldrivers/`, `bearer/`, `iconengines/`, `imageformats/`, `translations/` (Qt 插件)
- `etc/`, `conf/`, `html/`
- `tts.js`, `find.js`, `findsc.js`, `xiaoboshu.py`

## 注意

- Linux 二进制在 split 时确保 `chmod 0755`（zip 中可能丢失执行位）
- 调试符号 `*.debug` 应剔除
- `node_modules/` 在 install 时重新安装，不打包
