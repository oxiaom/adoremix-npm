'use strict';

/**
 * TTS provider 依赖检查（最硬核版）
 *
 * 检查每个 provider 需要的所有东西：
 *   xf:     crypto-js, ws, log4node (Node 包) + appid/apiSecret/apiKey (凭证)
 *   minimax: token (凭证) - Node 内置 https，无外部依赖
 *   edge:   python3, edge-tts (pip 包), ffmpeg (系统) - 完全免费但依赖多
 *
 * 用法：
 *   const issues = checkDeps(workdir);
 *   // issues: [{severity, msg, fixCmd, autoFixable}]
 *   if (opts.fix) fixDeps(workdir, issues);
 */

const { execSync, execFileSync } = require('child_process');
const fs = require('fs');
const path = require('path');

const PROVIDER_DEPENDENCIES = {
  xf: {
    nodeModules: ['crypto-js', 'ws', 'log4node'],
    creds: [
      { key: 'TTS.xf_appid', name: 'appid' },
      { key: 'TTS.xf_apiSecret', name: 'apiSecret' },
      { key: 'TTS.xf_apiKey', name: 'apiKey' }
    ],
    systemPkgs: [],
    pipPkgs: [],
    executables: []
  },
  minimax: {
    nodeModules: [],  // 用 Node 内置 https
    creds: [{ key: 'TTS.minimax_token', name: 'token' }],
    systemPkgs: [],
    pipPkgs: [],
    executables: []
  },
  edge: {
    nodeModules: [],
    creds: [],
    systemPkgs: [
      { name: 'python3', cmd: 'python3', altCmd: 'python' },
      { name: 'ffmpeg', cmd: 'ffmpeg' }
    ],
    pipPkgs: [{ pkg: 'edge-tts', import: 'edge_tts' }],
    executables: [{ name: 'ffmpeg', cmd: 'ffmpeg' }]
  }
};

function which(cmd) {
  try {
    execSync(`command -v ${cmd} 2>/dev/null || which ${cmd} 2>/dev/null`, { stdio: 'pipe' });
    return true;
  } catch (e) { return false; }
}

function findPythonCmd() {
  for (const c of ['python3', 'python']) {
    if (which(c)) {
      try {
        const v = execSync(`${c} --version`, { stdio: 'pipe', encoding: 'utf8' });
        if (/Python 3\./.test(v)) return c;
      } catch (e) {}
    }
  }
  return null;
}

function pythonHasModule(pyCmd, modName) {
  if (!pyCmd) return false;
  try {
    execFileSync(pyCmd, ['-c', `import ${modName}`], { stdio: 'pipe' });
    return true;
  } catch (e) { return false; }
}

function nodeModuleInstalled(workdir, modName) {
  try {
    require.resolve(modName, { paths: [workdir] });
    return true;
  } catch (e) { return false; }
}

function getCredValue(cfg, dottedKey) {
  const parts = dottedKey.split('.');
  let cur = cfg;
  for (const p of parts) {
    if (cur == null || typeof cur !== 'object') return undefined;
    cur = cur[p];
  }
  return cur;
}

function detectAptLike() {
  if (which('apt-get')) return 'apt-get';
  if (which('apt')) return 'apt';
  if (which('yum')) return 'yum';
  if (which('dnf')) return 'dnf';
  if (which('apk')) return 'apk';
  return null;
}

/**
 * 检查指定 provider 的所有依赖
 * @returns {issues: Array, provider: string}
 */
function checkDeps(workdir, providerName, cfg) {
  const issues = [];
  providerName = providerName || (cfg && cfg.TTS && cfg.TTS.provider) || 'xf';
  const deps = PROVIDER_DEPENDENCIES[providerName];
  if (!deps) {
    return { issues: [{ severity: 'error', msg: `未知 provider: ${providerName}`, autoFixable: false }], provider: providerName };
  }

  // 1. 凭证
  for (const c of deps.creds) {
    const val = getCredValue(cfg, c.key);
    if (!val) {
      issues.push({
        severity: 'error',
        category: 'cred',
        msg: `${providerName} 缺凭证 ${c.name}（${c.key}）`,
        fixCmd: `adoremix config set ${c.key} <your_${c.name}>`,
        autoFixable: false
      });
    }
  }

  // 2. Node 模块
  for (const mod of deps.nodeModules) {
    if (!nodeModuleInstalled(workdir, mod)) {
      issues.push({
        severity: 'error',
        category: 'node_module',
        msg: `Node 包未安装: ${mod}`,
        fixCmd: `cd ${workdir} && npm install ${mod}`,
        autoFixable: true,
        fixType: 'npm',
        fixArgs: { cwd: workdir, mod }
      });
    }
  }

  // 3. pip 包
  const pyCmd = findPythonCmd();
  for (const pip of deps.pipPkgs) {
    if (!pythonHasModule(pyCmd, pip.import)) {
      issues.push({
        severity: 'error',
        category: 'pip',
        msg: `Python 包未安装: ${pip.pkg}`,
        fixCmd: 'pip3 install ' + pip.pkg,
        autoFixable: true,
        fixType: 'pip',
        fixArgs: { pkg: pip.pkg, pyCmd }
      });
    }
  }

  // 4. 系统可执行
  for (const exe of deps.execubles || deps.systemPkgs) {
    if (exe.cmd && !which(exe.cmd)) {
      // 推断 apt 包名
      let aptPkg = '';
      if (exe.name === 'python3') aptPkg = 'python3 python3-pip';
      else if (exe.name === 'ffmpeg') aptPkg = 'ffmpeg';
      const pkgMgr = detectAptLike();
      issues.push({
        severity: 'error',
        category: 'system',
        msg: `系统命令未找到: ${exe.name}`,
        fixCmd: aptPkg && pkgMgr ? `sudo ${pkgMgr} install -y ${aptPkg}` : '',
        autoFixable: !!(aptPkg && pkgMgr),
        fixType: 'system',
        fixArgs: { pkgMgr, aptPkg }
      });
    }
  }

  // python3 特殊处理（如果 edge 需要 python3 但只装了 python）
  if (providerName === 'edge' && !pyCmd) {
    const pkgMgr = detectAptLike();
    issues.push({
      severity: 'error',
      category: 'system',
      msg: '需要 python3（未找到 Python 3.x）',
      fixCmd: pkgMgr ? `sudo ${pkgMgr} install -y python3 python3-pip` : '',
      autoFixable: !!pkgMgr,
      fixType: 'system',
      fixArgs: { pkgMgr, aptPkg: 'python3 python3-pip' }
    });
  }

  return { issues, provider: providerName };
}

/**
 * 自动修复（仅 autoFixable=true 的）
 */
function fixDeps(workdir, issues, opts) {
  opts = opts || {};
  const sudo = opts.sudo ? 'sudo ' : '';
  let fixed = 0;
  let failed = 0;
  for (const issue of issues) {
    if (!issue.autoFixable) continue;
    try {
      if (issue.fixType === 'npm') {
        execSync(`npm install ${issue.fixArgs.mod} --no-audit --no-fund`, {
          cwd: issue.fixArgs.cwd,
          stdio: 'inherit'
        });
      } else if (issue.fixType === 'pip') {
        const py = issue.fixArgs.pyCmd || findPythonCmd() || 'python3';
        execSync(`${sudo}${py} -m pip install ${issue.fixArgs.pkg}`, { stdio: 'inherit' });
      } else if (issue.fixType === 'system') {
        if (!issue.fixArgs.pkgMgr) throw new Error('包管理器未识别');
        execSync(`${sudo}${issue.fixArgs.pkgMgr} install -y ${issue.fixArgs.aptPkg}`, { stdio: 'inherit' });
      }
      fixed++;
    } catch (e) {
      console.error(`  ✗ 修复失败 [${issue.msg}]: ${e.message.split('\n')[0]}`);
      failed++;
    }
  }
  return { fixed, failed };
}

/**
 * 列出所有 provider 的依赖（用于 adoremix tts deps 不带 provider 时）
 */
function listAllProviders(workdir, cfg) {
  const result = {};
  for (const name of Object.keys(PROVIDER_DEPENDENCIES)) {
    const r = checkDeps(workdir, name, cfg);
    result[name] = {
      issues: r.issues,
      ok: r.issues.length === 0
    };
  }
  return result;
}

module.exports = {
  PROVIDER_DEPENDENCIES,
  checkDeps,
  fixDeps,
  listAllProviders,
  which,
  findPythonCmd
};
