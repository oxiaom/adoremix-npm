#!/usr/bin/env node
'use strict';

const cli = require('../src/cli');
// 注意：不能在 run() resolve 后强制 process.exit —— 前台模式 `adoremix start`
// spawn 出的二进制是 active handle，node 会自然挂起等待它运行（Ctrl+C 退出）。
// 无脑 process.exit 会把 node 杀掉，二进制成孤儿后收 SIGHUP 被终止，表现为"启动即退"。
// 普通命令（version/install/config 等）action 完成后事件循环空了会自然退出，
// 退出码由各命令自己设 process.exitCode（doctor/doctor --fix 等已设）。
cli.run(process.argv.slice(2)).catch((err) => {
  const logger = require('../src/logger');
  logger.error('未捕获的错误：', err);
  process.exit(1);
});
