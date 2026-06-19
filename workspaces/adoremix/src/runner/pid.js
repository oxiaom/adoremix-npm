'use strict';

const fs = require('fs');
const path = require('path');
const pidusage = require('pidusage');

function readPid(pidfile) {
  if (!fs.existsSync(pidfile)) return null;
  const txt = fs.readFileSync(pidfile, 'utf8').trim();
  if (!txt) return null;
  const n = parseInt(txt, 10);
  return Number.isFinite(n) ? n : null;
}

function writePid(pidfile, pid) {
  fs.mkdirSync(path.dirname(pidfile), { recursive: true });
  fs.writeFileSync(pidfile, String(pid), 'utf8');
}

function clearPid(pidfile) {
  if (fs.existsSync(pidfile)) fs.unlinkSync(pidfile);
}

function isRunning(pid) {
  if (!pid) return false;
  try {
    process.kill(pid, 0);
    return true;
  } catch (e) {
    return e.code === 'EPERM';
  }
}

async function stat(pid) {
  if (!pid) return null;
  try {
    const s = await pidusage(pid);
    return s;
  } catch (e) {
    return null;
  }
}

async function killPid(pid, timeout) {
  timeout = timeout || 8000;
  if (!isRunning(pid)) return true;
  const sig = process.platform === 'win32' ? 'SIGTERM' : 'SIGTERM';
  try {
    process.kill(pid, sig);
  } catch (e) {
    if (e.code !== 'ESRCH') throw e;
  }
  const deadline = Date.now() + timeout;
  while (Date.now() < deadline) {
    await new Promise((r) => setTimeout(r, 200));
    if (!isRunning(pid)) return true;
  }
  if (process.platform !== 'win32') {
    try { process.kill(pid, 'SIGKILL'); } catch (e) {}
    await new Promise((r) => setTimeout(r, 300));
  }
  return !isRunning(pid);
}

module.exports = { readPid, writePid, clearPid, isRunning, stat, killPid };
