'use strict';

const isatty = process.stdout.isTTY;

function ts() {
  return new Date().toISOString();
}

function fmt(level, args) {
  return [`${ts()} [${level}]`].concat(Array.from(args));
}

module.exports = {
  log(...args) {
    console.log(...args);
  },
  info(...args) {
    console.log(...(isatty ? ['\x1b[36m[info]\x1b[0m'] : ['[info]']).concat(args));
  },
  warn(...args) {
    console.warn(...(isatty ? ['\x1b[33m[warn]\x1b[0m'] : ['[warn]']).concat(args));
  },
  error(...args) {
    console.error(...(isatty ? ['\x1b[31m[err ]\x1b[0m'] : ['[err ]']).concat(args));
  },
  ok(...args) {
    console.log(...(isatty ? ['\x1b[32m[ok  ]\x1b[0m'] : ['[ok  ]']).concat(args));
  }
};
