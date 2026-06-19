#!/usr/bin/env node
'use strict';

const cli = require('../src/cli');
cli.run(process.argv.slice(2)).then((code) => {
  process.exit(code || 0);
}).catch((err) => {
  const logger = require('../src/logger');
  logger.error('未捕获的错误：', err);
  process.exit(1);
});
