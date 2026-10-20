'use strict';

/**
 * MP3Server 协议服务（Node 版，与 Adore_mix2/MP3Server C++ 版逐条对齐）
 *
 * 协议：
 *   1. 客户端连上后发一行相对路径（music/a.mp3\n）
 *   2. 服务端回一行音频字节数（已跳过 ID3v2 标签）+"\n"
 *   3. 客户端发一行字节数 N，服务端回 N 字节音频；重复
 *   4. 读到文件尾：服务端回 "close\n" 并断开；客户端可随时发 "close"
 *
 * 与原 C++ 版差异（仅健壮性，不改变线协议）：
 *   - 路径按行读取（原版 readAll().trimmed()，路径分包时会出错）
 *   - 空闲 10 分钟自动断开（原版无超时，掉线客户端会挂住）
 *   - 错误响应 "error: ...\n" 与原版一致
 */

const fs = require('fs');
const net = require('net');
const path = require('path');

const MAX_CHUNK = 1024 * 1024;       // 单次最多 1MB（与原版一致）
const IDLE_TIMEOUT_MS = 10 * 60 * 1000;

// MP3 帧头校验（与 C++ isValidMp3Header 完全一致）
function isValidMp3Header(buf, i) {
  if (buf[i] !== 0xFF || (buf[i + 1] & 0xE0) !== 0xE0) return false;
  const versionBits = (buf[i + 1] >> 3) & 0x03;
  if (versionBits === 0x01) return false;
  const layerBits = (buf[i + 1] >> 1) & 0x03;
  if (layerBits === 0x00) return false;
  const bitrateBits = (buf[i + 2] >> 4) & 0x0F;
  if (bitrateBits === 0x00 || bitrateBits === 0x0F) return false;
  const samplerateBits = (buf[i + 2] >> 2) & 0x03;
  if (samplerateBits === 0x03) return false;
  return true;
}

// 查找首个 MP3 音频帧位置（跳过 ID3v2 标签 + 扫描帧同步字），带缓存
function findFirstAudioFrame(fd, fileSize, cachePath, cache) {
  if (cache.has(cachePath)) return cache.get(cachePath);

  const header = Buffer.alloc(10);
  let audioStart = 0;
  const hn = fs.readSync(fd, header, 0, 10, 0);
  if (hn >= 10 && header.toString('latin1', 0, 3) === 'ID3') {
    audioStart = 10 + (
      ((header[6] & 0x7F) << 21) |
      ((header[7] & 0x7F) << 14) |
      ((header[8] & 0x7F) << 7) |
      (header[9] & 0x7F)
    );
  } else {
    audioStart = 0;
  }

  const BUF = 4096;
  const buf = Buffer.alloc(BUF);
  let found = false;
  let pos = audioStart;
  while (!found && pos < fileSize) {
    const n = fs.readSync(fd, buf, 0, BUF, pos);
    if (n < 4) break;
    for (let i = 0; i <= n - 4; i++) {
      if (isValidMp3Header(buf, i)) { audioStart = pos + i; found = true; break; }
    }
    if (!found) pos += Math.max(1, n - 3); // 回退 3 字节防帧头跨块
  }

  const result = found ? audioStart : 0;
  cache.set(cachePath, result);
  return result;
}

function validateRelPath(rel, root) {
  if (!rel || rel.indexOf('../') >= 0 || rel.startsWith('/')) return null;
  const abs = path.resolve(root, rel);
  const rootAbs = path.resolve(root);
  if (abs !== rootAbs && !abs.startsWith(rootAbs + path.sep)) return null;
  return abs;
}

function startServer(opts) {
  const root = path.resolve(opts.docroot);
  const port = opts.port || 6665;
  const host = opts.host || '0.0.0.0';
  const log = opts.log || ((m) => console.log(m));
  const frameCache = new Map();

  const server = net.createServer((sock) => {
    const peer = `${sock.remoteAddress}:${sock.remotePort}`;
    let fd = null;
    let audioStart = 0;
    let fileSize = 0;
    let filePath = '';
    let state = 'path';             // path → chunks
    let pending = Buffer.alloc(0);
    let closed = false;

    const cleanup = () => {
      if (closed) return;
      closed = true;
      if (fd !== null) { try { fs.closeSync(fd); } catch (e) {} fd = null; }
    };
    const fail = (msg) => {
      log(`[warn] ${peer} ${msg}`);
      try { sock.write('error: ' + msg + '\n'); } catch (e) {}
      try { sock.end(); } catch (e) {}
      cleanup();
    };

    sock.setTimeout(IDLE_TIMEOUT_MS, () => { log(`[info] ${peer} 空闲超时`); sock.destroy(); });
    sock.on('error', (err) => { log(`[warn] ${peer} socket: ${err.message}`); cleanup(); });
    sock.on('close', () => { cleanup(); log(`[info] ${peer} 断开`); });

    const handleLine = (lineRaw) => {
      const line = lineRaw.trim();
      if (state === 'path') {
        const abs = validateRelPath(line, root);
        if (!abs) return fail('Invalid file path');
        let st;
        try { st = fs.statSync(abs); } catch (e) { return fail('File not found or cannot open'); }
        if (!st.isFile()) return fail('File not found or cannot open');
        try { fd = fs.openSync(abs, 'r'); } catch (e) { return fail('File not found or cannot open'); }
        try {
          audioStart = findFirstAudioFrame(fd, st.size, abs, frameCache);
        } catch (e) {
          return fail('Invalid MP3 file format');
        }
        filePath = line;
        fileSize = st.size - audioStart;
        state = 'chunks';
        log(`[info] ${peer} 推送 ${line} 起始=${audioStart} 大小=${fileSize}`);
        sock.write(String(fileSize) + '\n');
        return;
      }

      // chunks 状态
      if (line.toLowerCase() === 'close') {
        try { sock.end(); } catch (e) {}
        cleanup();
        return;
      }
      let n = parseInt(line, 10);
      if (!isFinite(n) || n <= 0) return fail('Invalid chunk size');
      n = Math.min(n, MAX_CHUNK);

      const buf = Buffer.alloc(n);
      let got;
      try { got = fs.readSync(fd, buf, 0, n, null); } catch (e) { return fail('File read error'); }
      if (got === 0) {
        // 到文件尾：回 close 并断开（与 C++ 一致）
        try { sock.write('close\n', () => sock.end()); } catch (e) {}
        cleanup();
        log(`[info] ${peer} 完成 ${filePath}`);
        return;
      }
      if (!sock.write(buf.subarray(0, got))) {
        // 背压：等 drain 再继续读下一行（简单起见暂停处理）
        sock.pause();
        sock.once('drain', () => sock.resume());
      }
    };

    sock.on('data', (chunk) => {
      pending = Buffer.concat([pending, chunk]);
      let idx;
      while ((idx = pending.indexOf(0x0A)) >= 0) {
        const line = pending.subarray(0, idx);
        pending = pending.subarray(idx + 1);
        handleLine(line.toString('utf8'));
        if (closed) return;
      }
    });
  });

  server.on('error', (err) => log(`[error] ${err.message}`));
  server.listen(port, host, () => {
    log(`[ok] MP3Server 监听 ${host}:${port}，docroot=${root}`);
  });
  return server;
}

module.exports = { startServer, findFirstAudioFrame, isValidMp3Header, validateRelPath };
