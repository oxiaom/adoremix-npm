(function () {
    'use strict';

    importScripts('lame.min.js');

    var mp3Encoder, maxSamples = 1152, samplesMono, lame, config;

    var init = function (prefConfig) {
        config = prefConfig || {};
        lame = new lamejs();
        // 使用输入采样率创建编码器，输出采样率与输入相同
        // 单声道：与原始可用实现/服务器协议一致（Mp3Encoder(1,...)）
        var inSampleRate = config.inSampleRate || 44100;
        var bitRate = config.bitRate || 32;

        mp3Encoder = new lame.Mp3Encoder(1, inSampleRate, bitRate);
        console.log('[Worker] MP3编码器初始化: sampleRate=' + inSampleRate + ', bitRate=' + bitRate);
        self.postMessage({ cmd: 'init' });
    };

    var floatTo16BitPCM = function (input, output) {
        for (var i = 0; i < input.length; i++) {
            var s = Math.max(-1, Math.min(1, input[i]));
            output[i] = (s < 0 ? s * 0x8000 : s * 0x7FFF);
        }
    };

    var convertBuffer = function (arrayBuffer) {
        var data = new Float32Array(arrayBuffer);
        var out = new Int16Array(arrayBuffer.length);
        floatTo16BitPCM(data, out);
        return out;
    };

    /**
     * 流式编码：收到单声道 PCM → 编码为 MP3 帧 → 立即 postMessage 回主线程
     * 单声道编码（与原始可用实现一致）
     */
    var encodeChunk = function (arrayBuffer) {
        samplesMono = convertBuffer(arrayBuffer);
        var chunks = [];
        var remaining = samplesMono.length;
        for (var i = 0; remaining >= 0; i += maxSamples) {
            var left = samplesMono.subarray(i, i + maxSamples);
            if (left.length === 0) break;
            var mp3buf = mp3Encoder.encodeBuffer(left);
            if (mp3buf.length > 0) {
                chunks.push(new Uint8Array(mp3buf));
            }
            remaining -= maxSamples;
        }
        // 立即把这一批编码结果发回主线程
        if (chunks.length > 0) {
            self.postMessage({ cmd: 'chunk', buf: chunks });
        }
    };

    /** flush 编码器剩余数据 */
    var flush = function () {
        var mp3buf = mp3Encoder.flush();
        if (mp3buf.length > 0) {
            self.postMessage({ cmd: 'chunk', buf: [new Uint8Array(mp3buf)] });
        }
        self.postMessage({ cmd: 'end' });
    };

    self.onmessage = function (e) {
        switch (e.data.cmd) {
            case 'init':
                init(e.data.config);
                break;
            case 'open':
                encodeChunk(e.data.buf);
                break;
            case 'close':
                flush();
                break;
        }
    };
})();
