'use strict';

const fs = require('fs');
const path = require('path');
const { spawn } = require('child_process');

const pidMgr = require('./pid');
const paths = require('../paths');
const logger = require('../logger');

function ensureLogFiles(workdirPaths) {
  fs.mkdirSync(workdirPaths.varDir, { recursive: true });
  fs.mkdirSync(workdirPaths.logsDir, { recursive: true });
}

function startForeground(opts) {
  const native = opts.native;
  const workdir = opts.workdir;
  const configPath = opts.configPath;
  const wp = paths.workdirPaths(workdir);

  ensureLogFiles(wp);
  if (!fs.existsSync(configPath)) {
    throw new Error(`配置不存在 ${configPath}，请先运行 adoremix install`);
  }
  if (!fs.existsSync(native.bin)) {
    throw new Error(`原生二进制不存在 ${native.bin}`);
  }

  const args = [path.basename(configPath)];
  logger.info(`spawn ${native.binName} ${args.join(' ')} (cwd=${workdir})`);
  const child = spawn(native.bin, args, {
    cwd: workdir,
    stdio: ['ignore', 'pipe', 'pipe'],
    windowsHide: false
  });

  child.stdout.on('data', (d) => process.stdout.write(d));
  child.stderr.on('data', (d) => process.stderr.write(d));

  pidMgr.writePid(wp.pidfile, child.pid);
  logger.ok(`已启动 PID=${child.pid}（前台模式，Ctrl+C 退出）`);

  const forward = (sig) => {
    if (!child.killed) {
      try { process.kill(child.pid, sig); } catch (e) {}
    }
  };
  process.on('SIGINT', () => forward('SIGINT'));
  process.on('SIGTERM', () => forward('SIGTERM'));

  child.on('exit', (code, signal) => {
    pidMgr.clearPid(wp.pidfile);
    logger.log(`子进程退出 code=${code} signal=${signal}`);
    process.exit(code == null ? 0 : code);
  });

  return child;
}

function startDaemon(opts) {
  const native = opts.native;
  const workdir = opts.workdir;
  const configPath = opts.configPath;
  const wp = paths.workdirPaths(workdir);

  ensureLogFiles(wp);
  if (!fs.existsSync(configPath)) {
    throw new Error(`配置不存在 ${configPath}，请先运行 adoremix install`);
  }
  if (!fs.existsSync(native.bin)) {
    throw new Error(`原生二进制不存在 ${native.bin}`);
  }

  const running = pidMgr.readPid(wp.pidfile);
  if (running && pidMgr.isRunning(running)) {
    logger.warn(`已在运行 PID=${running}`);
    return { alreadyRunning: true, pid: running };
  }

  const out = fs.openSync(wp.logfile, 'a');
  const err = fs.openSync(wp.logfile, 'a');
  const args = [path.basename(configPath)];
  logger.info(`spawn ${native.binName} ${args.join(' ')} (cwd=${workdir}, daemon)`);
  const child = spawn(native.bin, args, {
    cwd: workdir,
    stdio: ['ignore', out, err],
    detached: true,
    windowsHide: false
  });
  child.unref();
  pidMgr.writePid(wp.pidfile, child.pid);
  logger.ok(`已启动 PID=${child.pid}（后台模式，日志：${path.relative(workdir, wp.logfile)}`);
  return { pid: child.pid };
}

async function stop(opts) {
  const workdir = opts.workdir;
  const wp = paths.workdirPaths(workdir);
  const pid = pidMgr.readPid(wp.pidfile);
  if (!pid) {
    logger.warn(`未找到 PID 文件 ${wp.pidfile}`);
    return 1;
  }
  if (!pidMgr.isRunning(pid)) {
    logger.warn(`PID=${pid} 已不在运行，清理 pidfile`);
    pidMgr.clearPid(wp.pidfile);
    return 0;
  }
  logger.info(`停止 PID=${pid} ...`);
  const ok = await pidMgr.killPid(pid, opts.timeout || 10000);
  if (ok) {
    pidMgr.clearPid(wp.pidfile);
    logger.ok('已停止');
    return 0;
  }
  logger.error(`无法停止 PID=${pid}，请用系统工具手动结束`);
  return 1;
}

async function status(opts) {
  const workdir = opts.workdir;
  const wp = paths.workdirPaths(workdir);
  const pid = pidMgr.readPid(wp.pidfile);
  if (!pid) {
    logger.log('状态：未运行');
    return 2;
  }
  if (!pidMgr.isRunning(pid)) {
    logger.log(`状态：未运行（残留 pidfile，PID=${pid}）`);
    pidMgr.clearPid(wp.pidfile);
    return 2;
  }
  const s = await pidMgr.stat(pid);
  const cpu = s ? s.cpu.toFixed(1) + '%' : '?';
  const mem = s ? Math.round(s.memory / 1024 / 1024) + ' MB' : '?';
  logger.log(`状态：运行中  PID=${pid}  CPU=${cpu}  MEM=${mem}`);
  return 0;
}

async function restart(opts) {
  await stop(opts);
  await new Promise((r) => setTimeout(r, 500));
  return opts.daemon ? startDaemon(opts) : startForeground(opts);
}

module.exports = {
  startForeground,
  startDaemon,
  stop,
  status,
  restart
};
