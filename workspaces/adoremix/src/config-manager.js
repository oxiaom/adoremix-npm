'use strict';

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');
const logger = require('./logger');

const SERVICE_NAME = 'config-manager';
const SYSTEM_UNIT_PATH = `/etc/systemd/system/${SERVICE_NAME}.service`;
const PORT = 9877;

function which(cmd) {
  try { return execSync(`command -v ${cmd}`, { encoding: 'utf8', stdio: ['pipe', 'pipe', 'pipe'] }).trim(); }
  catch (e) { return null; }
}

function run(cmd) {
  try { return execSync(cmd, { encoding: 'utf8', stdio: ['pipe', 'pipe', 'pipe'] }).trim(); }
  catch (e) { return null; }
}

// 复制主包内置的 config-manager 代码（app.py + templates）到工作目录
function copyCode(workdir) {
  const srcDir = path.join(__dirname, '..', 'config-manager');
  const dstDir = path.join(workdir, 'config-manager');
  fs.mkdirSync(dstDir, { recursive: true });
  fs.copyFileSync(path.join(srcDir, 'app.py'), path.join(dstDir, 'app.py'));
  fs.mkdirSync(path.join(dstDir, 'templates'), { recursive: true });
  fs.copyFileSync(path.join(srcDir, 'templates', 'index.html'), path.join(dstDir, 'templates', 'index.html'));
  return dstDir;
}

function buildUnit(workdir, pythonBin) {
  const codeDir = path.join(workdir, 'config-manager');
  return `# AdoreMix 设备配置管理 UI（由 adoremix config-manager install 生成）
[Unit]
Description=AdoreMix Config Manager (设备配置管理 UI)
After=network.target

[Service]
Type=simple
WorkingDirectory=${codeDir}
Environment=ADOREMIX_WORKDIR=${workdir}
ExecStart=${pythonBin} app.py
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
`;
}

function install(workdir) {
  if (process.platform !== 'linux') {
    logger.error('config-manager 仅支持 Linux（依赖 systemd）');
    return 1;
  }

  // 1. 检测 Python3
  const pythonBin = which('python3');
  if (!pythonBin) {
    logger.error('未检测到 python3，请先安装：sudo dnf/apt install python3');
    return 1;
  }
  logger.ok(`python3: ${pythonBin}`);

  // 2. 检测/安装 Flask
  if (!run(`${pythonBin} -c "import flask"`)) {
    logger.info('未检测到 Flask，尝试安装...');
    try {
      execSync(`${pythonBin} -m pip install flask`, { stdio: 'inherit' });
      logger.ok('Flask 已安装');
    } catch (e) {
      logger.error(`Flask 安装失败：${(e.message || '').split('\n')[0]}`);
      logger.warn(`  请手动安装：${pythonBin} -m pip install flask`);
      return 1;
    }
  } else {
    logger.ok('Flask 已就绪');
  }

  // 3. 复制代码
  try {
    copyCode(workdir);
    logger.ok(`复制 config-manager 代码到 ${path.join(workdir, 'config-manager')}`);
  } catch (e) {
    logger.error(`复制代码失败：${(e.message || '').split('\n')[0]}`);
    return 1;
  }

  // 4. 写 systemd 服务（开机自启）
  try {
    fs.writeFileSync(SYSTEM_UNIT_PATH, buildUnit(workdir, pythonBin), 'utf8');
    logger.ok(`写入 ${SYSTEM_UNIT_PATH}`);
  } catch (e) {
    logger.error(`写服务失败：${(e.message || '').split('\n')[0]}（可能需要 root）`);
    return 1;
  }

  // 5. 启动 + 开机自启
  try {
    execSync('systemctl daemon-reload', { stdio: 'inherit' });
    execSync(`systemctl enable ${SERVICE_NAME}`, { stdio: 'inherit' });
    execSync(`systemctl restart ${SERVICE_NAME}`, { stdio: 'inherit' });
    logger.ok('config-manager 已启动并设为开机自启');
  } catch (e) {
    logger.warn(`systemctl 操作失败：${(e.message || '').split('\n')[0]}（可能非 systemd，请手动启动）`);
  }

  logger.log('');
  logger.log(`访问 UI：http://<本机IP>:${PORT}/`);
  logger.log(`功能：配置 IP 地址 / 修改 config.ini / 查看运行日志`);
  return 0;
}

function uninstall(workdir) {
  if (process.platform !== 'linux') return 0;
  try { execSync(`systemctl disable ${SERVICE_NAME}`, { stdio: 'ignore' }); } catch (e) {}
  try { execSync(`systemctl stop ${SERVICE_NAME}`, { stdio: 'ignore' }); } catch (e) {}
  try { fs.unlinkSync(SYSTEM_UNIT_PATH); logger.ok('已删除 systemd 服务'); } catch (e) {}
  try { execSync('systemctl daemon-reload', { stdio: 'ignore' }); } catch (e) {}
  const codeDir = path.join(workdir, 'config-manager');
  if (fs.existsSync(codeDir)) {
    fs.rmSync(codeDir, { recursive: true, force: true });
    logger.ok(`已删除 ${codeDir}`);
  }
  logger.ok('config-manager 已卸载');
  return 0;
}

function status() {
  if (process.platform !== 'linux') { logger.warn('仅 Linux 支持'); return 1; }
  const out = run(`systemctl is-active ${SERVICE_NAME}`);
  if (out === 'active') { logger.ok('config-manager 运行中'); return 0; }
  logger.warn(`config-manager 状态：${out || '未运行'}`);
  return 1;
}

module.exports = { install, uninstall, status, PORT };
