'use strict';

const path = require('path');
const { Command } = require('commander');
const pkg = require('../package.json');
const paths = require('./paths');
const logger = require('./logger');

function resolveWorkdir(option) {
  if (option) return option;
  return paths.defaultWorkdir();
}

function buildProgram() {
  const program = new Command();
  program
    .name('adoremix')
    .description('AdoreMix 广播服务器 - 跨平台安装、运行与服务管理')
    .version(pkg.version, '-v, --version');

  program
    .command('version')
    .description('打印主包、平台子包和原生二进制信息')
    .action(() => {
      logger.log(`adoremix CLI       v${pkg.version}`);
      logger.log(`platform/arch      ${paths.PLATFORM_KEY}`);
      logger.log(`platform pkg       ${paths.PLATFORM_PKG || '(none)'}`);
      try {
        const n = paths.loadNative();
        logger.log(`native root        ${n.root}`);
        logger.log(`native bin         ${n.binName}  (exists: ${n.exists() ? 'yes' : 'no'})`);
        if (n.notice) logger.warn(`notice             ${n.notice}`);
      } catch (e) {
        logger.warn(`native             未加载：${e.message.split('\n')[0]}`);
      }
    });

  program
    .command('install')
    .description('初始化工作目录、复制资源、安装协作依赖、生成 config.ini')
    .option('--workdir <path>', '工作目录路径')
    .option('--force', '覆盖已有安装')
    .option('--skip-npm-install', '跳过工作目录内 npm install（tts.js 等协作脚本依赖）')
    .option('--no-interactive', '跳过配置向导，使用默认值')
    .action(async (opts) => {
      const install = require('./install');
      const code = await install.runInstall({
        workdir: resolveWorkdir(opts.workdir),
        force: !!opts.force,
        skipNpmInstall: !!opts.skipNpmInstall,
        interactive: opts.interactive !== false
      });
      process.exitCode = code || 0;
    });

  const config = program
    .command('config')
    .description('读取或修改 config.ini');

  config
    .command('get <key>')
    .description('读取配置项（支持 dotted：Settings.LocalIP）')
    .option('--workdir <path>')
    .action((key, opts) => {
      const cfg = require('./config');
      const workdir = resolveWorkdir(opts.workdir);
      const v = cfg.getConfigValue(workdir, key);
      if (v === undefined) {
        logger.warn(`键不存在：${key}`);
        process.exitCode = 1;
        return;
      }
      logger.log(`${key} = ${v}`);
    });

  config
    .command('set <key> <value>')
    .description('写入配置项')
    .option('--workdir <path>')
    .action((key, value, opts) => {
      const cfg = require('./config');
      const workdir = resolveWorkdir(opts.workdir);
      cfg.setConfigValue(workdir, key, value);
      logger.ok(`${key} = ${value}`);
    });

  config
    .command('list')
    .description('打印全部配置')
    .option('--workdir <path>')
    .action((opts) => {
      const cfg = require('./config');
      const workdir = resolveWorkdir(opts.workdir);
      const obj = cfg.listConfig(workdir);
      if (!obj) {
        process.exitCode = 1;
        return;
      }
      const flat = require('./config/ini').flatten(obj);
      for (const k of Object.keys(flat)) {
        logger.log(`${k} = ${flat[k]}`);
      }
    });

  config
    .command('init')
    .description('生成默认 config.ini（已存在需 --force）')
    .option('--workdir <path>')
    .option('--force', '覆盖已有 config.ini')
    .option('--no-interactive', '跳过向导')
    .action(async (opts) => {
      const cfg = require('./config');
      const workdir = resolveWorkdir(opts.workdir);
      await cfg.ensureConfig(workdir, {
        force: !!opts.force,
        interactive: opts.interactive !== false
      });
    });

  const runner = require('./runner');
  const nativeRef = () => {
    try { return paths.loadNative(); }
    catch (e) { logger.error(e.message); process.exit(1); }
  };
  const runnerOpts = (opts) => ({
    workdir: resolveWorkdir(opts.workdir),
    native: nativeRef(),
    configPath: path.join(resolveWorkdir(opts.workdir), 'config.ini'),
    daemon: opts.daemon === true
  });

  program
    .command('start')
    .description('启动 AdoreMix（默认前台，加 --daemon 后台）')
    .option('--workdir <path>')
    .option('--daemon', '后台运行（nohup 风格）')
    .action((opts) => {
      try {
        if (opts.daemon) runner.startDaemon(runnerOpts(opts));
        else runner.startForeground(runnerOpts(opts));
      } catch (e) {
        logger.error(e.message);
        process.exitCode = 1;
      }
    });

  program
    .command('stop')
    .description('停止 AdoreMix（读 pidfile 并 kill）')
    .option('--workdir <path>')
    .option('--timeout <ms>', 'SIGTERM 超时后 SIGKILL 的毫秒数', parseInt)
    .action(async (opts) => {
      process.exitCode = await runner.stop(runnerOpts(opts));
    });

  program
    .command('status')
    .description('查看运行状态')
    .option('--workdir <path>')
    .action(async (opts) => {
      process.exitCode = await runner.status(runnerOpts(opts));
    });

  program
    .command('restart')
    .description('重启')
    .option('--workdir <path>')
    .option('--daemon', '后台模式重启')
    .action(async (opts) => {
      const r = await runner.restart(runnerOpts(opts));
      if (r && r.alreadyRunning === false && r.pid) {
        // ok
      }
    });

  program
    .command('logs')
    .description('查看日志（默认 var/app.log）')
    .option('--workdir <path>')
    .option('-f, --follow', '实时跟随')
    .option('--file <path>', '指定日志文件')
    .option('-n, --lines <n>', '初始打印行数', parseInt, 50)
    .action((opts) => {
      const wp = paths.workdirPaths(resolveWorkdir(opts.workdir));
      const file = opts.file || wp.logfile;
      const fs = require('fs');
      const { spawn } = require('child_process');
      if (!fs.existsSync(file)) {
        logger.warn(`日志文件不存在 ${file}`);
        process.exitCode = 1;
        return;
      }
      if (!opts.follow) {
        const tail = spawn(process.platform === 'win32' ? 'more' : 'tail', process.platform === 'win32' ? [file] : ['-n', String(opts.lines), file], { stdio: 'inherit' });
        tail.on('exit', (c) => process.exit(c || 0));
        return;
      }
      if (process.platform === 'win32') {
        logger.warn('Windows 不支持 -f，请用 PowerShell 自行 Get-Content -Wait');
        const tail = spawn('more', [file], { stdio: 'inherit' });
        tail.on('exit', (c) => process.exit(c || 0));
        return;
      }
      const tail = spawn('tail', ['-n', String(opts.lines), '-f', file], { stdio: 'inherit' });
      process.on('SIGINT', () => tail.kill('SIGINT'));
      tail.on('exit', (c) => process.exit(c || 0));
    });

  const service = program
    .command('service')
    .description('系统服务管理（开机自启）');

  service
    .command('install')
    .description('注册系统服务并启动（Linux: systemd / Windows: node-windows）')
    .option('--workdir <path>')
    .action((opts) => {
      const svc = require('./service');
      try {
        process.exitCode = svc.install({ workdir: resolveWorkdir(opts.workdir) });
      } catch (e) {
        logger.error(e.message);
        process.exitCode = 1;
      }
    });

  service
    .command('uninstall')
    .description('卸载系统服务')
    .option('--workdir <path>')
    .action((opts) => {
      const svc = require('./service');
      try {
        process.exitCode = svc.uninstall({ workdir: resolveWorkdir(opts.workdir) });
      } catch (e) {
        logger.error(e.message);
        process.exitCode = 1;
      }
    });

  service
    .command('status')
    .description('查看系统服务状态')
    .action(() => {
      const svc = require('./service');
      try {
        process.exitCode = svc.status();
      } catch (e) {
        logger.error(e.message);
        process.exitCode = 1;
      }
    });

  return program;
}

async function run(argv) {
  const program = buildProgram();
  await program.parseAsync(argv, { from: 'user' });
  return process.exitCode || 0;
}

module.exports = { run, buildProgram };
