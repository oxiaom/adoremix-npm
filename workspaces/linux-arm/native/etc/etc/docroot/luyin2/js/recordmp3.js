(function (exports) {  
  
    var MP3Recorder = function (config) {  
  
        var recorder = this;  
        config = config || {};  
        config.sampleRate = config.sampleRate || 44100;  
        config.bitRate = config.bitRate || 64;  
        config.broadcasttype = config.broadcasttype || 1;//1:为录制，2：为广播
  
        navigator.getUserMedia = navigator.getUserMedia ||  
                                 navigator.webkitGetUserMedia ||  
                                 navigator.mozGetUserMedia ||  
                                 navigator.msGetUserMedia;  
  
        if (navigator.getUserMedia) {  
            navigator.getUserMedia({  
                audio: true  
            },  
            function (stream) {  
                var context = new AudioContext(),  
                    microphone = context.createMediaStreamSource(stream),  
                    processor = context.createScriptProcessor(16384, 2, 2),//bufferSize大小，输入channel数，输出channel数  
                    mp3ReceiveSuccess, currentErrorCallback;  
  
                config.sampleRate = context.sampleRate;  
                processor.onaudioprocess = function (event) {  
                    //边录音边转换  
                    var array = event.inputBuffer.getChannelData(0);  
                    if(config.broadcasttype == 1){
                        realTimeWorker.postMessage({ cmd: 'encode', buf: array });  
                    }else{
                        realTimeWorker.postMessage({ cmd: 'open', buf: array });  
                    }
                };  
  
                var realTimeWorker = new Worker('js/worker-realtime.js');  
                realTimeWorker.onmessage = function (e) {  
                    switch (e.data.cmd) {  
                        case 'init':  
                            log('初始化成功');  
                            if (config.funOk) {  
                                config.funOk();  
                            }  
                            break;  
                        case 'end': 
                            log('MP3大小：', e.data.buf.length);  
                            if (mp3ReceiveSuccess) {  
                                mp3ReceiveSuccess(new Blob(e.data.buf, { type: 'audio/mp3' }));  
                            }  
                            break;  
                        case 'error':  
                            log('错误信息：' + e.data.error);  
                            if (currentErrorCallback) {  
                                currentErrorCallback(e.data.error);  
                            }  
                            break; 
                        case 'close':
							
							if( e.data.buf.length > 0 ){
								var  i =  0 ;
								var senddata = 		"";
								var  dataforsend = e.data.buf[i] ;
								for( i = 1 ; i <e.data.buf.length ; i++ ){
									if(e.data.buf[i].length >0 ){
											dataforsend = dataforsend + ","+ e.data.buf[i];
											console.log("=============================" +  e.data.buf[i].toString("hex")) 	;
											senddata =uintbase64(e.data.buf[i]);											
											ws.send(senddata); 
											//senddata = senddata + uintbase64(e.data.buf[i]) + "|"
									}								
								}														
																
							}
                            break;
                        default:    
                            log('未知信息：', e.data);  
                    }  
                };  
  
                recorder.getMp3Blob = function (onSuccess, onError) {  
                    currentErrorCallback = onError;  
                    mp3ReceiveSuccess = onSuccess;  
                    realTimeWorker.postMessage({ cmd: 'finish' });  
                };  
  
                recorder.start = function () {  
                    if (processor && microphone) {  
                        microphone.connect(processor);  
                        processor.connect(context.destination);  
                        log('开始录音');  
                    } 
                }  
  
                recorder.stop = function () {  
                    if (processor && microphone) {  
                        microphone.disconnect();  
                        processor.disconnect();  
                        log('录音结束');  
                    }  
                }  

                recorder.Ontime = function (broadcasttype) {
                    config.broadcasttype = broadcasttype || 1;
                	if (processor && microphone) {  
                        microphone.connect(processor);  
                        processor.connect(context.destination);  
                        log('开启广播');  
                    }
                }

                recorder.Onstop = function (broadcasttype) {
                    config.broadcasttype = broadcasttype || 1;
                    if (processor && microphone) {  
                        microphone.disconnect();  
                        processor.disconnect();  
                        log('关闭广播');  
                    } 
                }  

                realTimeWorker.postMessage({  
                    cmd: 'init',  
                    config: {  
                        sampleRate: config.sampleRate,  
                        bitRate: config.bitRate  
                    }  
                });
            },  
            function (error) {  
                var msg;  
                switch (error.code || error.name) {  
                    case 'PERMISSION_DENIED':  
                    case 'PermissionDeniedError':  
                        msg = '用户拒绝访问麦客风';  
                        break;  
                    case 'NOT_SUPPORTED_ERROR':  
                    case 'NotSupportedError':  
                        msg = '浏览器不支持麦客风';  
                        break;  
                    case 'MANDATORY_UNSATISFIED_ERROR':  
                    case 'MandatoryUnsatisfiedError':  
                        msg = '找不到麦客风设备';  
                        break;  
                    default:  
                        msg = '无法打开麦克风，异常信息:' + (error.code || error.name);  
                        break;  
                }  
                if (config.funCancel) {  
                    config.funCancel(msg);  
                }  
            });  
        } else {  
            if (config.funCancel) {  
                config.funCancel('当前浏览器不支持录音功能');  
            }  
        }  
  
        function log(str) {  
            if (config.debug) {  
                console.log(str);  
            }  
        }  
    }  
  
    exports.MP3Recorder = MP3Recorder;  
})(window);
 
  
var toBase64 = [
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
    'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
    'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm',
    'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
    '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/'
];
 
function uintbase64(src) {
    let dstLen = Math.ceil(src.length * 4 / 3);
    let dst = new Array(dstLen);
    let pos = 0;
    let dstIndex = 0;
    let nextLeft = 0;
    src.forEach( b => {
        let r = 0;
        if (pos == 0) {
            r = b >> 2;
            dst[dstIndex++] = toBase64[nextLeft + r];
            nextLeft = (b & 0x03) << 4;
        } else if (pos == 1) {
            r = b >> 4;
            dst[dstIndex++] = toBase64[nextLeft + r];
            nextLeft = (b & 0x0F) << 2;
        } else if (pos == 2) {
            r = b >> 6;
            dst[dstIndex++] = toBase64[nextLeft + r];
            dst[dstIndex++] = toBase64[b & 0x3F];
            nextLeft = 0;
        }
 
        pos++;
        if (pos == 3) {
            pos = 0;
        }
    });
 
    if (pos != 0) {
        dst[dstIndex] = toBase64[nextLeft];
    }
 
    return dst.join('');
}
 function uint8arrayToBase64(u8Arr) {
    let CHUNK_SIZE = 0x8000; //arbitrary number
    let index = 0;
    let length = u8Arr.length;
    let result = '';
    let slice;
    while (index < length) {
        slice = u8Arr.subarray(index, Math.min(index + CHUNK_SIZE, length));
        result += String.fromCharCode.apply(null, slice);
        index += CHUNK_SIZE;
    }     
    return btoa(result);
}

function base64ToUint8Array(base64String) {
    let padding = '='.repeat((4 - base64String.length % 4) % 4);
    let base64 = (base64String + padding)
        .replace(/\-/g, '+')
        .replace(/_/g, '/');

    let rawData = window.atob(base64);
    let outputArray = new Uint8Array(rawData.length);

    for (var i = 0; i < rawData.length; ++i) {
        outputArray[i] = rawData.charCodeAt(i);
    }
    return outputArray;
}
