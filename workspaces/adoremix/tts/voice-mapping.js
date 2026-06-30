'use strict';

/**
 * 统一 voice 表
 *
 * Qt/WebUI 调 tts.js 时传讯飞发音人 ID（WebUI 音色选项：小燕/许久/小萍/小婧）。
 * 每个 provider 在自己的 VOICES 字典里把发音人映射到平台真实 voice_id：
 *   - xf:      讯飞原生 vcn 直接透传（讯飞接受任意 vcn）
 *   - minimax: 讯飞名 → minimax voice_id
 *   - edge:    讯飞名 → edge-tts voice（edge 实际只有 8 个 zh-CN voice，就近映射 + fallback 兜底）
 *
 * STANDARD_VOICES 是 Qt 实际传的（adoremix tts voices 命令展示这些）；
 * EXTENDED_VOICES 是 edge 风格扩展短名（Qt 不传，但各 provider VOICES 兼容映射，
 * 用户在 config.ini 手动配 voice 或 xf_voice_override 时可用）。
 */

// Qt/WebUI 实际传的讯飞发音人（WebUI 音色下拉选项）
const STANDARD_VOICES = [
  { short: 'xiaoyan',   desc: '小燕 - 女声（讯飞，WebUI 默认）' },
  { short: 'aisjiuxu',  desc: '许久 - 男声（讯飞）' },
  { short: 'aisxping',  desc: '小萍 - 女声（讯飞）' },
  { short: 'aisjinger', desc: '小婧 - 女声（讯飞）' }
];

const DEFAULT_VOICE = 'xiaoyan';

// 扩展短名（edge 风格，Qt 不直接传；provider VOICES 兼容映射，手动配置可用）
const EXTENDED_VOICES = [
  { short: 'xiaoxiao',   desc: '晓晓 - 女声，自然亲切（edge）' },
  { short: 'yunxi',      desc: '云希 - 男声，年轻活力（edge）' },
  { short: 'yunjian',    desc: '云健 - 男声，成熟稳重（edge）' },
  { short: 'xiaoyi',     desc: '晓伊 - 女声，温柔甜美（edge）' },
  { short: 'yunxia',     desc: '云夏 - 男童声（edge）' },
  { short: 'xiaochen',   desc: '晓辰 - 女声，新闻播报' },
  { short: 'xiaohan',    desc: '晓涵 - 女声，温暖' },
  { short: 'xiaomeng',   desc: '晓梦 - 女声，活泼' },
  { short: 'xiaomo',     desc: '晓墨 - 女声，知性' },
  { short: 'xiaoqiu',    desc: '晓秋 - 女声，温和' },
  { short: 'xiaorui',    desc: '晓睿 - 女童声' },
  { short: 'xiaoshuang', desc: '晓双 - 女童声' },
  { short: 'xiaoxuan',   desc: '晓萱 - 女声' },
  { short: 'xiaoyou',    desc: '悠悠 - 女童声' },
  { short: 'yunfeng',    desc: '云枫 - 男声' },
  { short: 'yunhao',     desc: '云皓 - 男声' },
  { short: 'yunxiang',   desc: '云翔 - 男声' },
  { short: 'yunyang',    desc: '云扬 - 男声' }
];

module.exports = { STANDARD_VOICES, DEFAULT_VOICE, EXTENDED_VOICES };
