'use strict';

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');
const logger = require('./logger');
const config = require('./config');

const NGINX_PORT = 9876;
const NGINX_CONF = '/etc/nginx/conf.d/adoremix.conf';

function whichNginx() {
  try { return execSync('which nginx', { encoding: 'utf8', stdio: ['pipe', 'pipe', 'pipe'] }).trim(); }
  catch (e) { return null; }
}

function buildConfig(workdir) {
  const docroot = path.join(workdir, 'etc', 'docroot');
  return `# AdoreMix 静态加速（由 adoremix nginx install 生成）
# 用途：媒体文件（mp3 等）走 nginx 直接出，减轻 AdoreMix 设备服务压力。
server {
    listen ${NGINX_PORT};
    server_name _;

    root ${docroot};
    index index.html;

    client_max_body_size 100m;
    access_log off;

    # 媒体文件：mp3 等大文件长缓存
    location ~* \\.(mp3|wav|m4a|aac|ogg|opus|flac)$ {
        expires 30d;
        add_header Cache-Control "public, immutable";
    }

    # 静态资源缓存
    location ~* \\.(js|css|png|jpg|jpeg|gif|svg|woff2?|ttf|ico)$ {
        expires 7d;
        add_header Cache-Control "public";
    }

    location / {
        try_files $uri $uri/ =404;
    }
}
`;
}

function install(workdir) {
  if (process.platform !== 'linux') {
    logger.error('NGINX 静态加速仅支持 Linux');
    return 1;
  }

  // 1. 检测/安装 nginx
  if (!whichNginx()) {
    logger.info('未检测到 nginx，尝试 apt 安装...');
    try {
      execSync('apt-get update && apt-get install -y nginx', { stdio: 'inherit' });
    } catch (e) {
      logger.error(`nginx 安装失败：${(e.message || '').split('\n')[0]}`);
      logger.warn('  请手动安装：sudo apt-get install -y nginx');
      return 1;
    }
  }
  logger.ok('nginx 已就绪');

  // 2. 写配置
  try {
    fs.mkdirSync('/etc/nginx/conf.d', { recursive: true });
    fs.writeFileSync(NGINX_CONF, buildConfig(workdir), 'utf8');
    logger.ok(`写入 ${NGINX_CONF}`);
  } catch (e) {
    logger.error(`写 nginx 配置失败：${(e.message || '').split('\n')[0]}（可能需要 root）`);
    return 1;
  }

  // 3. 测试配置
  try {
    execSync('nginx -t', { stdio: 'inherit' });
  } catch (e) {
    logger.error('nginx 配置校验失败，请检查');
    return 1;
  }

  // 4. 开机自启 + 启动
  try {
    execSync('systemctl enable nginx', { stdio: 'inherit' });
    execSync('systemctl restart nginx', { stdio: 'inherit' });
    logger.ok('nginx 已启动并设为开机自启');
  } catch (e) {
    logger.warn(`systemctl 操作失败：${(e.message || '').split('\n')[0]}（可能非 systemd 环境，请手动启动）`);
  }

  // 5. preurl 自动改为 IP:9876
  const ip = config.getConfigValue(workdir, 'Settings.LocalIP') || '127.0.0.1';
  const preurl = `http://${ip}:${NGINX_PORT}/`;
  config.setConfigValue(workdir, 'Settings.preurl', preurl);
  logger.ok(`preurl 已更新为 ${preurl}（媒体文件走 nginx）`);
  logger.log('改完后记得：adoremix restart');
  return 0;
}

function uninstall(workdir) {
  if (process.platform !== 'linux') return 0;
  try { execSync('systemctl disable nginx', { stdio: 'ignore' }); } catch (e) {}
  try { execSync('systemctl stop nginx', { stdio: 'ignore' }); } catch (e) {}
  try { fs.unlinkSync(NGINX_CONF); logger.ok('已删除 nginx 配置'); } catch (e) {}

  // 还原 preurl 到原 HTTP 端口
  const ip = config.getConfigValue(workdir, 'Settings.LocalIP') || '127.0.0.1';
  const port = config.getConfigValue(workdir, 'listener.port') || 12080;
  config.setConfigValue(workdir, 'Settings.preurl', `http://${ip}:${port}/`);
  logger.ok(`preurl 已还原为 http://${ip}:${port}/`);
  logger.log('改完后记得：adoremix restart');
  return 0;
}

function status() {
  if (process.platform !== 'linux') { logger.warn('仅 Linux 支持'); return 1; }
  try {
    const out = execSync('systemctl is-active nginx', { encoding: 'utf8', stdio: ['pipe', 'pipe', 'pipe'] }).trim();
    if (out === 'active') { logger.ok('nginx 运行中'); return 0; }
    logger.warn(`nginx 状态：${out}`); return 1;
  } catch (e) {
    logger.warn('nginx 未运行');
    return 1;
  }
}

module.exports = { install, uninstall, status, NGINX_PORT };
