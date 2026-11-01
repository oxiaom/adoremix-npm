'use strict';

/**
 * 端口系列（port series）
 *
 * 一套服务会占用十几个端口（设备控制、MP3 通道、喊话、运维命令、HTTP…）。
 * 如果一台机器上要跑多套，或者要和别的服务避让，逐个改端口很痛苦。
 *
 * 这里引入"端口系列"概念：给一个系列号（如 117），所有端口都从 117xx 里取，
 * 同一台机器上不同实例用不同系列号即可完全隔离。
 *
 *   系列 117 → 11733(主控制) 11731 11730 11700 11701 11702 11703
 *             11704 11706 11707 11708 11782 11783 11790 11780 11765
 *
 * 端口在系列内的位置 = 「默认端口去掉万位/千位后的尾数」，
 * 所以系列 117 时 DPort(3333) → 11733、DataPort(6002) → 11702、
 * listener(12080) → 11780。这样同一个系列号下端口互不冲突，
 * 且和默认端口的相对关系保持一致。
 *
 * 只覆盖**本机要监听**的端口；Fport（上游服务器的端口，来自
 * snupdatareload.json）不属于本机，不在系列内。
 */

// 各端口在系列内的偏移量（= 默认端口去掉前面的高位后的尾数）
const PORT_OFFSETS = {
  // [Settings]
  DPort: 33,             // 设备主控制通道        3333
  DataPortBack3: 31,      // 设备备用控制通道      6031
  OPort0: 0,              // MP3 跨接 1            6000
  OPort1: 1,              // MP3 跨接 2            6001
  Netcross_Port0: 0,      // 同 OPort0
  Netcross_Port1: 1,      // 同 OPort1
  DataPort: 2,            // 喊话裸流入口 1       6002
  DataPortBack2: 30,      // 喊话裸流入口 2       6030
  PS1: 3,                 // 运维命令通道 1       6003
  BjPort: 4,              // fcr 指令通道         6004
  PS2: 6,                 // 运维命令通道 2       6006
  ManagePort: 7,          // 管理端口             6007
  Pastcmd: 8,             // 过去命令             6008
  wbport: 82,             // WebSocket 喊话       6082
  cuteport: 83,           // 录音端口            12083
  RDDATAPORT: 90,         // 二级数据端口         7636
  // [listener]
  listener_port: 80,       // HTTP 主服务         12080
  // [MP3Server]
  MP3Server_port: 65,     // MP3Server            6665
};

// 系列号 → 各端口的实际值
// series=117 → base 11700，DPort=11700+33=11733
function portsForSeries(series) {
  const s = Number(series) || 0;
  const base = s * 100;    // 117 → 11700
  const out = { Settings: {}, listener: {}, MP3Server: {} };
  for (const [key, off] of Object.entries(PORT_OFFSETS)) {
    const port = base + off;
    if (key === 'listener_port') out.listener.port = port;
    else if (key === 'MP3Server_port') out.MP3Server.port = port;
    else out.Settings[key] = port;
  }
  // preurl 里的 HTTP 端口要跟着变
  out.Settings.preurl = `http://127.0.0.1:${out.listener.port}/`;
  return out;
}

// 判断一个端口值是否属于某个系列（用于校验配置是否成套）
function isPortInSeries(port, series) {
  const s = Number(series) || 0;
  const base = s * 100;
  return Number(port) >= base && Number(port) < base + 100;
}

// 从现有配置反推系列号（取主控制端口去掉尾数后的部分）
// DPort=11733 → 117；DPort=3333 → 33
function seriesFromConfig(cfg) {
  if (!cfg) return null;
  const s = cfg.Settings || {};
  const dport = Number(s.DPort);
  if (!dport) return null;
  return Math.floor(dport / 100);
}

// 把一个配置对象里的端口全部替换成某个系列的端口
// 只替换属于"本机监听"的端口，不动 MySQL(3307)/Redis 等外部依赖端口
function applySeries(cfg, series) {
  const p = portsForSeries(series);
  const out = JSON.parse(JSON.stringify(cfg || {}));
  out.Settings = Object.assign({}, out.Settings, p.Settings);
  out.listener = Object.assign({}, out.listener, { port: p.listener.port });
  out.MP3Server = Object.assign({}, out.MP3Server, { port: p.MP3Server.port });
  return out;
}

// 校验配置里的端口是否成套（同属一个系列）
// 返回 { ok, series, problems }
function checkSeries(cfg) {
  const problems = [];
  const series = seriesFromConfig(cfg);
  if (series === null) return { ok: false, series: null, problems: ['读不到 DPort，无法判断系列'] };

  const check = (section, key, label) => {
    const v = cfg[section] && cfg[section][key];
    if (v === undefined || v === null || v === '') return;
    if (!isPortInSeries(v, series)) {
      problems.push(`${label}=${v} 不属于 ${series}xx 系列`);
    }
  };
  check('Settings', 'DPort', 'DPort');
  check('Settings', 'DataPortBack3', 'DataPortBack3');
  check('Settings', 'OPort0', 'OPort0');
  check('Settings', 'OPort1', 'OPort1');
  check('Settings', 'DataPort', 'DataPort');
  check('Settings', 'DataPortBack2', 'DataPortBack2');
  check('Settings', 'PS1', 'PS1');
  check('Settings', 'PS2', 'PS2');
  check('Settings', 'BjPort', 'BjPort');
  check('Settings', 'ManagePort', 'ManagePort');
  check('Settings', 'Pastcmd', 'Pastcmd');
  check('Settings', 'wbport', 'wbport');
  check('Settings', 'cuteport', 'cuteport');
  check('Settings', 'RDDATAPORT', 'RDDATAPORT');
  check('listener', 'port', 'listener.port');
  check('MP3Server', 'port', 'MP3Server.port');

  return { ok: problems.length === 0, series, problems };
}

module.exports = {
  PORT_OFFSETS,
  portsForSeries,
  isPortInSeries,
  seriesFromConfig,
  applySeries,
  checkSeries
};
