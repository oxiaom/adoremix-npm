'use strict';

const fs = require('fs');
const ini = require('ini');

function read(configPath) {
  if (!fs.existsSync(configPath)) return {};
  const txt = fs.readFileSync(configPath, 'utf8');
  return ini.parse(txt);
}

function write(configPath, obj) {
  const txt = ini.stringify(obj, {
    section: '',
    whitespace: true,
    align: false,
    sort: false
  });
  fs.writeFileSync(configPath, txt, { encoding: 'utf8' });
}

function get(obj, dottedKey) {
  const parts = dottedKey.split('.');
  let cur = obj;
  for (const p of parts) {
    if (cur == null || typeof cur !== 'object') return undefined;
    cur = cur[p];
  }
  return cur;
}

function set(obj, dottedKey, value) {
  const parts = dottedKey.split('.');
  let cur = obj;
  for (let i = 0; i < parts.length - 1; i++) {
    if (cur[parts[i]] == null || typeof cur[parts[i]] !== 'object') {
      cur[parts[i]] = {};
    }
    cur = cur[parts[i]];
  }
  cur[parts[parts.length - 1]] = value;
  return obj;
}

function flatten(obj, prefix, out) {
  out = out || {};
  prefix = prefix || '';
  for (const k of Object.keys(obj)) {
    const v = obj[k];
    const full = prefix ? `${prefix}.${k}` : k;
    if (v && typeof v === 'object' && !Array.isArray(v)) {
      flatten(v, full, out);
    } else {
      out[full] = v;
    }
  }
  return out;
}

module.exports = { read, write, get, set, flatten };
