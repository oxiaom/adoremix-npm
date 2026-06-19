#!/usr/bin/env node
'use strict';

// 顶层 tts.js wrapper（Qt 调用入口）
// Qt 调：node tts.js <vol> <speed> <voice> <mp3> <txt> [appid] [apiSecret] [apiKey]
// 这里转发给 adoremix-tts/ 目录的 dispatcher

const path = require('path');
const dispatcherPath = path.join(__dirname, 'adoremix-tts', 'tts.js');
const fs = require('fs');

if (!fs.existsSync(dispatcherPath)) {
  console.error('[tts] 错误：adoremix-tts/ 目录不存在，请重新运行 adoremix install');
  process.exit(1);
}

// 让 dispatcher 看到正确的 argv（保留 Qt 传入的所有参数）
process.argv[1] = dispatcherPath;
require(dispatcherPath);
