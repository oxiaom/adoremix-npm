'use strict';

/**
 * MP3Server 选装组件：TCP 分块推流 MP3 文件（默认端口 6665）
 *
 * 协议见 mp3server-server.js（与 Adore_mix2/MP3Server C++ 版线协议一致）。
 * 实现用 Node（跨平台零编译，与 AdoreMix 主包同一套分发），
 * 由 systemd（Linux）/ node-windows（Windows）托管，开机自启。
 *
 * 配置：config.ini [MP3Server] port=6665 docroot=（空=工作目录/etc/docroot，与 nginx 共用）
 */

const fs = require('fs');
const path = require('path');
const net = require('net');
const os = require('os');
const { execSync } = require('child_process');
const logger = require('./logger');
const paths = require('./paths');

const UNIT_NAME = 'adoremix-mp3server';
const SYSTEM_UNIT_PATH = `/etc/systemd/system/${UNIT_NAME}.service`;
const WINSVC_NAME = 'AdoreMp3Server';
const DEFAULT_PORT = 6665;

function readSettings(workdir) {
  const cfg = require('./config');
  const obj = cfg.readConfig(workdir) || {};
  const s = obj.MP3Server || {};
  return {
    port: parseInt(s.port, 10) || DEFAULT_PORT,
    docroot: s.docroot && String(s.docroot).trim()
      ? String(s.docroot).trim()
      : path.join(workdir, 'etc', 'docroot')
  };
}

function portOpen(port, host) {
  return new Promise((resolve) => {
    const sock = net.connect({ port, host: host || '127.0.0.1' });
    const done = (ok) => { try { sock.destroy(); } catch (e) {} resolve(ok); };
    sock.setTimeout(2000);
    sock.once('connect', () => done(true));
    sock.once('timeout', () => done(false));
    sock.once('error', () => done(false));
  });
}

// 前台运行（systemd / Windows 服务 / 手动调试都走这个入口）
function serve(opts) {
  opts = opts || {};
  const workdir = opts.workdir || paths.defaultWorkdir();
  const { port, docroot } = readSettings(workdir);
  if (!fs.existsSync(docroot)) {
    try { fs.mkdirSync(docroot, { recursive: true }); } catch (e) {}
  }
  const { startServer } = require('./mp3server-server');
  startServer({
    port,
    host: opts.host || '0.0.0.0',
    docroot,
    log: (m) => logger.log(m)
  });
  return null; // 常驻，不返回
}

function buildSystemdUnit(workdir, port) {
  const user = process.getuid && process.getuid() === 0 ? 'root' : os.userInfo().username;
  return `[Unit]
Description=AdoreMix MP3Server (TCP chunked MP3 streaming)
Documentation=https://github.com/oxiaom/adoremix-npm
After=network.target

[Service]
Type=simple
User=${user}
Group=${user}
WorkingDirectory=${workdir}
ExecStart=${paths.nodeExecutable()} ${paths.cliBin()} mp3server serve --workdir ${workdir}
Restart=on-failure
RestartSec=5
StandardOutput=append:${path.join(workdir, 'logs', 'mp3server.log')}
StandardError=append:${path.join(workdir, 'logs', 'mp3server.log')}
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
`;
}

function installWindowsService(workdir) {
  let hasNodeWindows = false;
  try { require.resolve('node-windows'); hasNodeWindows = true; } catch (e) {}
  if (!hasNodeWindows) {
    logger.warn('node-windows 未安装，尝试在工作目录安装...');
    try {
      execSync('npm install --no-save node-windows', { cwd: workdir, stdio: 'inherit' });
    } catch (e) {
      logger.error(`node-windows 安装失败（需管理员权限）：${(e.message || '').split('\n')[0]}`);
      return false;
    }
  }
  const tpl = fs.readFileSync(path.join(__dirname, '..', 'templates', 'mp3server-winservice.js.tmpl'), 'utf8');
  const wrapper = path.join(workdir, 'mp3server-winservice.js');
  fs.writeFileSync(wrapper, tpl
    .replace(/__NODE__/g, paths.nodeExecutable().replace(/\\/g, '\\\\'))
    .replace(/__CLI__/g, paths.cliBin().replace(/\\/g, '\\\\'))
    .replace(/__WORKDIR__/g, workdir.replace(/\\/g, '\\\\'))
    .replace(/__SVC_NAME__/g, WINSVC_NAME), 'utf8');
  try {
    execSync(`node "${wrapper}" install`, { cwd: workdir, stdio: 'inherit' });
    return true;
  } catch (e) {
    logger.error(`Windows 服务注册失败（需管理员权限）：${(e.message || '').split('\n')[0]}`);
    logger.log(`可前台运行：adoremix mp3server serve --workdir "${workdir}"`);
    return false;
  }
}

async function install(opts) {
  opts = opts || {};
  const workdir = opts.workdir || paths.defaultWorkdir();
  const { port, docroot } = readSettings(workdir);

  fs.mkdirSync(workdir, { recursive: true });
  fs.mkdirSync(path.join(workdir, 'logs'), { recursive: true });
  fs.mkdirSync(docroot, { recursive: true });

  // 写 config.ini（已有配置保留用户值）
  try {
    const cfg = require('./config');
    const obj = cfg.readConfig(workdir) || {};
    if (!obj.MP3Server) {
      cfg.setConfigValue(workdir, 'MP3Server.port', port);
      cfg.setConfigValue(workdir, 'MP3Server.docroot', docroot);
    }
    logger.ok(`config.ini [MP3Server] port=${port} docroot=${docroot}`);
  } catch (e) {
    logger.warn(`config.ini 写入失败：${e.message}`);
  }

  let ok = false;
  if (process.platform === 'linux') {
    try {
      fs.writeFileSync(SYSTEM_UNIT_PATH, buildSystemdUnit(workdir, port), 'utf8');
      execSync('systemctl daemon-reload', { stdio: 'pipe' });
      execSync(`systemctl enable ${UNIT_NAME}`, { stdio: 'pipe' });
      execSync(`systemctl restart ${UNIT_NAME}`, { stdio: 'pipe' });
      logger.ok(`systemd 服务已注册并启动：${UNIT_NAME}`);
      ok = true;
    } catch (e) {
      logger.error(`systemd 配置失败：${(e.message || '').split('\n')[0]}`);
      logger.log(`可前台运行：adoremix mp3server serve --workdir "${workdir}"`);
    }
  } else if (process.platform === 'win32') {
    ok = installWindowsService(workdir);
  } else {
    logger.warn('macOS 不支持注册系统服务，可手动前台运行：adoremix mp3server serve');
  }

  if (ok) {
    let up = false;
    for (let i = 0; i < 6; i++) {
      if (await portOpen(port)) { up = true; break; }
      await new Promise(r => setTimeout(r, 800));
    }
    if (up) logger.ok(`端口 ${port} 已监听`);
    else logger.warn(`端口 ${port} 暂不可连接（journalctl -u ${UNIT_NAME} -n 30）`);
  }
  logger.ok(`MP3Server 安装完成 → tcp://0.0.0.0:${port}（docroot: ${docroot}）`);
  return 0;
}

function uninstall(opts) {
  opts = opts || {};
  const workdir = opts.workdir || paths.defaultWorkdir();
  if (process.platform === 'linux') {
    try {
      execSync(`systemctl disable --now ${UNIT_NAME} 2>/dev/null; true`, { stdio: 'pipe', shell: '/bin/bash' });
      execSync(`rm -f ${SYSTEM_UNIT_PATH} && systemctl daemon-reload`, { stdio: 'pipe', shell: '/bin/bash' });
    } catch (e) { logger.warn(`卸载服务部分出错：${e.message}`); }
  } else if (process.platform === 'win32') {
    const wrapper = path.join(workdir, 'mp3server-winservice.js');
    if (fs.existsSync(wrapper)) {
      try { execSync(`node "${wrapper}" uninstall`, { cwd: workdir, stdio: 'inherit' }); } catch (e) {
        logger.warn(`Windows 服务卸载失败（需管理员）：${(e.message || '').split('\n')[0]}`);
      }
      try { fs.rmSync(wrapper, { force: true }); } catch (e) {}
    }
  }
  logger.ok('MP3Server 已卸载（config.ini 配置与 docroot 媒体文件保留）');
  return 0;
}

async function status(opts) {
  opts = opts || {};
  const workdir = opts.workdir || paths.defaultWorkdir();
  const { port, docroot } = readSettings(workdir);
  let problems = 0;

  logger.log(`配置：port=${port}  docroot=${docroot}`);
  if (!fs.existsSync(docroot)) {
    logger.warn(`docroot 不存在：${docroot}`);
    problems++;
  } else {
    let count = 0;
    try {
      count = execSync(`find "${docroot}" -type f 2>/dev/null | wc -l`, { encoding: 'utf8', shell: '/bin/bash' }).trim();
    } catch (e) {}
    logger.ok(`docroot 存在（${count} 个文件）`);
  }

  if (process.platform === 'linux') {
    const active = (function () {
      try { return execSync(`systemctl is-active ${UNIT_NAME} 2>/dev/null`, { encoding: 'utf8' }).trim(); }
      catch (e) { return 'inactive'; }
    })();
    const enabled = (function () {
      try { return execSync(`systemctl is-enabled ${UNIT_NAME} 2>/dev/null`, { encoding: 'utf8' }).trim(); }
      catch (e) { return 'disabled'; }
    })();
    if (active === 'active') logger.ok(`systemd：active（开机自启：${enabled}）`);
    else { logger.warn(`systemd：${active}（journalctl -u ${UNIT_NAME} -n 30）`); problems++; }
  } else if (process.platform === 'win32') {
    try {
      const out = execSync(`sc query ${WINSVC_NAME}`, { encoding: 'utf8', stdio: ['pipe', 'pipe', 'pipe'], windowsHide: true });
      if (/RUNNING/.test(out)) logger.ok(`Windows 服务：RUNNING（${WINSVC_NAME}）`);
      else { logger.warn(`Windows 服务未运行（${WINSVC_NAME}）`); problems++; }
    } catch (e) {
      logger.warn(`Windows 服务未注册（${WINSVC_NAME}）`);
      problems++;
    }
  }

  const open = await portOpen(port);
  if (open) logger.ok(`端口 ${port} 可连接`);
  else { logger.warn(`端口 ${port} 不可连接`); problems++; }
  return problems ? 1 : 0;
}

module.exports = { install, uninstall, status, serve, DEFAULT_PORT, UNIT_NAME, WINSVC_NAME };
