'use strict';

/**
 * 统一 voice 短名表（前端 UI 用这套）
 *
 * Qt 调 tts.js 时传的 voice 参数用这里的短名（如 xiaoxiao/yunxi）。
 * 每个 provider 在自己的 voices 字典里把短名映射到平台真实 voice_id。
 *
 * 短名以 edge-tts 风格命名（小写拼音），是 UI 蓝本。
 */

// 标准短名（前端 UI 应该只展示这些）
const STANDARD_VOICES = [
  { short: 'xiaoxiao',   desc: '晓晓 - 女声，自然亲切' },
  { short: 'yunxi',      desc: '云希 - 男声，年轻活力' },
  { short: 'yunjian',    desc: '云健 - 男声，成熟稳重' },
  { short: 'xiaoyi',     desc: '晓伊 - 女声，温柔甜美' },
  { short: 'yunxia',     desc: '云夏 - 男童声' },
  { short: 'xiaochen',   desc: '晓辰 - 女声，新闻播报' },
  { short: 'xiaohan',    desc: '晓涵 - 女声，温暖' },
  { short: 'xiaomeng',   desc: '晓梦 - 女声，活泼' },
  { short: 'xiaomo',     desc: '晓墨 - 女声，知性' },
  { short: 'xiaoqiu',    desc: '晓秋 - 女声，温和' },
  { short: 'xiaorui',    desc: '晓睿 - 女童声' },
  { short: 'xiaoshuang', desc: '晓双 - 女童声' },
  { short: 'xiaoxuan',   desc: '晓萱 - 女声' },
  { short: 'xiaoyan',    desc: '晓妍 - 女声' },
  { short: 'xiaoyou',    desc: '悠悠 - 女童声' },
  { short: 'yunfeng',    desc: '云枫 - 男声' },
  { short: 'yunhao',     desc: '云皓 - 男声' },
  { short: 'yunxiang',   desc: '云翔 - 男声' },
  { short: 'yunyang',    desc: '云扬 - 男声' }
];

const DEFAULT_VOICE = 'xiaoxiao';

module.exports = { STANDARD_VOICES, DEFAULT_VOICE };
