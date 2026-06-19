# AdoreMix linux-arm 原生包

本目录存放 Linux ARM (armv7 / armhf) 平台的二进制和运行时资源。

## 预期内容

由 `scripts/split-zip.js` 从 `D:/zhuangyi/vbox/AdoreMIXMICV8linux8.10_arm.zip` 拆出并放入：

- `AdoreMixV8.0.17_console_linuxarm0` - C++ 主程序（ARM 32 位）
- `lame` (ARM 32 位 MP3 编码器)
- Qt5 共享库（armhf 版本）
- `platforms/`, `sqldrivers/`, `bearer/`, `iconengines/`, `imageformats/`, `translations/` (Qt 插件 armhf)
- `etc/`, `conf/`, `html/`
- `tts.js`, `find.js`, `findsc.js`, `xiaoboshu.py`

## 注意

- ARM 二进制在 split 时确保 `chmod 0755`
- 调试符号 `*.debug` 应剔除
- 树莓派 32 位系统（Raspbian）可直接使用
