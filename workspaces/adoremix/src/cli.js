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
    .command('doctor')
    .description('健康检查：node 版本、二进制、缺库、config.ini、.Adore.db、服务状态')
    .option('--workdir <path>')
    .option('--fix', '自动 apt install 缺的库（需要 root / sudo）')
    .action((opts) => {
      const doctor = require('./doctor');
      process.exitCode = doctor.runDoctor(resolveWorkdir(opts.workdir), { fix: !!opts.fix });
    });

  const ttsCmd = program
    .command('tts')
    .description('TTS 文字转语音（支持 xf 讯飞 / minimax / edge 三种 provider）');

  ttsCmd
    .command('list')
    .description('列出 3 个 provider + 当前激活 + 凭证/依赖状态')
    .option('--workdir <path>')
    .action((opts) => {
      const tts = require('./tts-cli');
      process.exitCode = tts.cmdList(resolveWorkdir(opts.workdir));
    });

  ttsCmd
    .command('config')
    .description('交互式配置：选 provider + 填凭证')
    .option('--workdir <path>')
    .action(async (opts) => {
      const tts = require('./tts-cli');
      process.exitCode = await tts.cmdConfig(resolveWorkdir(opts.workdir), {});
    });

  ttsCmd
    .command('test [text]')
    .description('用当前 provider 测试 TTS（生成 _cli_test.mp3）')
    .option('--workdir <path>')
    .option('-v, --voice <name>', 'voice 短名（默认 xiaoxiao）')
    .option('--volume <n>', '音量 0-100', '50')
    .option('--speed <n>', '语速 0-100', '50')
    .action(async (text, opts) => {
      const tts = require('./tts-cli');
      process.exitCode = await tts.cmdTest(resolveWorkdir(opts.workdir), text, opts);
    });

  ttsCmd
    .command('voices')
    .description('列出所有 voice 短名 + 当前 provider 的映射')
    .option('--workdir <path>')
    .action((opts) => {
      const tts = require('./tts-cli');
      process.exitCode = tts.cmdVoices(resolveWorkdir(opts.workdir));
    });

  ttsCmd
    .command('deps')
    .description('检查当前 provider 的依赖（python/edge-tts/ffmpeg/npm 包/凭证）')
    .option('--workdir <path>')
    .option('--fix', '自动修复缺的依赖（apt install / pip install / npm install）')
    .action((opts) => {
      const tts = require('./tts-cli');
      process.exitCode = tts.cmdDeps(resolveWorkdir(opts.workdir), { fix: !!opts.fix });
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

  config
    .command('network')
    .description('交互式配置 IP（内网选网卡 / 外网手动输入），同时设 LocalIP/Meida_ip/Fip')
    .option('--workdir <path>')
    .option('--ip <addr>', '直接指定 IP（非交互）')
    .option('--no-interactive', '自动选第一个网卡')
    .action(async (opts) => {
      const net = require('./config/network');
      const code = await net.setupNetwork(resolveWorkdir(opts.workdir), {
        ip: opts.ip,
        interactive: opts.interactive !== false
      });
      process.exitCode = code || 0;
    });

  config
    .command('preurl')
    .description('配置设备拉资源用的 URL（默认 http://IP:12080/，CDN 加速改成域名）')
    .option('--workdir <path>')
    .option('--url <url>', '直接指定 URL（如 http://cdn.your.com/）')
    .option('--no-interactive', '用本机 IP 自动生成')
    .action(async (opts) => {
      const net = require('./config/network');
      const code = await net.setupPreurl(resolveWorkdir(opts.workdir), {
        url: opts.url,
        interactive: opts.interactive !== false
      });
      process.exitCode = code || 0;
    });

  config
    .command('log')
    .description('日志开关 isopenrizhi（开启会保存播放日志 + mp3，长期会占存储）')
    .option('--workdir <path>')
    .option('--enable', '开启日志')
    .option('--disable', '关闭日志（默认）')
    .option('--no-interactive', '不询问')
    .action(async (opts) => {
      const net = require('./config/network');
      let enable;
      if (opts.enable) enable = true;
      else if (opts.disable) enable = false;
      const code = await net.setupLog(resolveWorkdir(opts.workdir), {
        enable,
        interactive: opts.interactive !== false
      });
      process.exitCode = code || 0;
    });

  config
    .command('webui')
    .description('切换 WebUI 版本（low=16k 互联网 / high=44.1k 局域网）')
    .option('--workdir <path>')
    .option('--variant <v>', '直接指定: low | high')
    .option('--no-interactive', '用当前配置部署')
    .action(async (opts) => {
      const webui = require('./config/webui');
      const code = await webui.setupWebui(resolveWorkdir(opts.workdir), {
        variant: opts.variant,
        interactive: opts.interactive !== false
      });
      process.exitCode = code || 0;
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

  // systemd 管理本服务时，start/stop/restart 委托 systemctl（避免手动 spawn/kill 脱离
  // systemd 管理——尤其 restart 的 stop+手动start 会让服务脱离 systemd）。
  // status 不委托（pidfile 检查已与 systemctl 一致）。仅 Linux + 服务 active 时生效。
  function systemdDelegate(cmd) {
    if (process.platform !== 'linux') return false;
    const { execSync } = require('child_process');
    let active;
    try {
      active = execSync('systemctl is-active adoremix 2>/dev/null', { encoding: 'utf8', stdio: ['pipe', 'pipe', 'pipe'] }).trim();
    } catch (e) { return false; }
    if (active !== 'active') return false;
    logger.info(`检测到 systemd 管理，执行 systemctl ${cmd} adoremix`);
    try {
      execSync(`systemctl ${cmd} adoremix`, { stdio: 'inherit' });
      return true;
    } catch (e) {
      logger.error(`systemctl ${cmd} 失败：${(e.message || '').split('\n')[0]}（可能需要 sudo，或用 systemctl --user）`);
      return false;
    }
  }

  program
    .command('start')
    .description('启动 AdoreMix（默认前台，加 --daemon 后台）')
    .option('--workdir <path>')
    .option('--daemon', '后台运行（nohup 风格）')
    .action((opts) => {
      if (systemdDelegate('start')) return;
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
      if (systemdDelegate('stop')) return;
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
      if (systemdDelegate('restart')) return;
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
      const workdir = resolveWorkdir(opts.workdir);
      const wp = paths.workdirPaths(workdir);
      const fs = require('fs');
      const { spawn } = require('child_process');
      // 默认日志文件：选最近更新的。
      //   systemd 模式 → logs/svc.log（unit 模板 StandardOutput=append 写这里）
      //   前台/daemon 模式 → var/app.log（spawn 重定向）
      // 用户可用 --file 覆盖。
      let file = opts.file;
      if (!file) {
        const candidates = [
          path.join(workdir, 'logs', 'svc.err'),   // systemd 模式：二进制实时输出（stderr，更新最频繁）
          path.join(workdir, 'logs', 'svc.log'),   // systemd 模式：node logger（stdout）
          wp.logfile                                 // 前台/daemon 模式：var/app.log
        ];
        let bestMtime = 0;
        for (const f of candidates) {
          try {
            const m = fs.statSync(f).mtimeMs;
            if (m > bestMtime) { bestMtime = m; file = f; }
          } catch (e) {}
        }
      }
      if (!file || !fs.existsSync(file)) {
        logger.warn(`日志文件不存在（找了 logs/svc.err、logs/svc.log、${wp.logfile}）`);
        logger.log('提示：systemd 模式也可用 journalctl -u adoremix -f');
        process.exitCode = 1;
        return;
      }
      if (file !== wp.logfile && !opts.file) {
        logger.log(`（自动选中 ${path.relative(workdir, file)}，--file 可指定其他）`);
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
