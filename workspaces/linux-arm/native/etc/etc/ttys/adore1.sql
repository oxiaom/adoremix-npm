/*
Navicat MySQL Data Transfer

Source Server         : 12
Source Server Version : 80012
Source Host           : localhost:3307
Source Database       : adore

Target Server Type    : MYSQL
Target Server Version : 80012
File Encoding         : 65001

Date: 2023-10-27 10:36:54
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for `autowarning`
-- ----------------------------
DROP TABLE IF EXISTS `autowarning`;
CREATE TABLE `autowarning` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userid` int(11) NOT NULL,
  `seed` varchar(100) NOT NULL,
  `url_bihe` varchar(200) NOT NULL DEFAULT 'url',
  `url_duankai` varchar(200) NOT NULL DEFAULT 'url',
  `ip` varchar(45) NOT NULL DEFAULT '0.0.0.0',
  `portct6` int(11) NOT NULL DEFAULT '6',
  `enable` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of autowarning
-- ----------------------------

-- ----------------------------
-- Table structure for `group_seed`
-- ----------------------------
DROP TABLE IF EXISTS `group_seed`;
CREATE TABLE `group_seed` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `gid` int(11) NOT NULL,
  `seed` varchar(45) NOT NULL,
  `userid` int(11) NOT NULL,
  `gidseed` varchar(45) NOT NULL DEFAULT 'none',
  `devid` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=58 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of group_seed
-- ----------------------------
INSERT INTO `group_seed` VALUES ('56', '17', '8e6b85a54c36d87080ca19d7495b874e', '6', '178e6b85a54c36d87080ca19d7495b874e', '75');
INSERT INTO `group_seed` VALUES ('57', '18', '8e6b85a54c36d87080ca19d7495b874e', '13', '188e6b85a54c36d87080ca19d7495b874e', '76');

-- ----------------------------
-- Table structure for `rizhi`
-- ----------------------------
DROP TABLE IF EXISTS `rizhi`;
CREATE TABLE `rizhi` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userid` int(11) NOT NULL DEFAULT '0',
  `info` varchar(3000) NOT NULL DEFAULT 'noe',
  `kind` int(11) NOT NULL DEFAULT '0',
  `level` int(11) NOT NULL DEFAULT '0',
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of rizhi
-- ----------------------------

-- ----------------------------
-- Table structure for `sbox_device_info`
-- ----------------------------
DROP TABLE IF EXISTS `sbox_device_info`;
CREATE TABLE `sbox_device_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '-1',
  `device_type` int(11) NOT NULL DEFAULT '-1',
  `device_status` int(11) NOT NULL DEFAULT '-1',
  `device_name` varchar(45) NOT NULL DEFAULT 'default',
  `device_code` varchar(45) NOT NULL DEFAULT '0000',
  `device_seed` varchar(45) NOT NULL DEFAULT '0000',
  `node_id` int(11) NOT NULL DEFAULT '1',
  `updatetime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `tag1` varchar(200) NOT NULL DEFAULT 'default',
  `tag2` varchar(200) NOT NULL DEFAULT 'default',
  `userid_seed` varchar(50) NOT NULL,
  `vol` int(11) NOT NULL DEFAULT '-1',
  `status` int(11) NOT NULL DEFAULT '-1',
  `kind` int(11) NOT NULL DEFAULT '-1',
  `iswarning` int(11) NOT NULL DEFAULT '0',
  `furl` varchar(200) NOT NULL DEFAULT '_NONE.mp3',
  `burl` varchar(200) NOT NULL DEFAULT '_NONE.mp3',
  `changetime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `jwd` varchar(45) NOT NULL DEFAULT '116.40389220333873|39.91411461844903',
  `py` int(11) NOT NULL DEFAULT '0',
  `pyl` int(11) NOT NULL DEFAULT '0',
  `rt` int(11) NOT NULL DEFAULT '0',
  `rtl` int(11) NOT NULL DEFAULT '0',
  `xhstatus` varchar(200) NOT NULL DEFAULT '0',
  `qianfeiinfo` varchar(1000) DEFAULT '正常使用',
  PRIMARY KEY (`id`),
  UNIQUE KEY `userid_seed` (`userid_seed`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=77 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sbox_device_info
-- ----------------------------
INSERT INTO `sbox_device_info` VALUES ('47', '12', '-1', '-1', '5oql6K2m', '8c215505fb0e1dc889279a6941bf9a1f', 'a53906f3e9c8f3015e0c51c837376d8f', '-1', '2023-05-22 05:48:30', 'default', 'default', '12a53906f3e9c8f3015e0c51c837376d8f', '50', '1', '2', '0', '_NONE.mp3', '_NONE.mp3', '2023-05-22 05:48:30', '116.40389220333873|39.91411461844903', '0', '0', '0', '0', '0', '正常使用');
INSERT INTO `sbox_device_info` VALUES ('48', '12', '-1', '-1', '5oql6K2mMg==', '445b178ca3e19218516f55d3dd47353e', '39560783d24343d3ee53c77a3e6f92ea', '-1', '2023-05-22 05:48:30', 'default', 'default', '1239560783d24343d3ee53c77a3e6f92ea', '-1', '-1', '2', '0', '_NONE.mp3', '_NONE.mp3', '2023-05-22 05:48:30', '116.40389220333873|39.91411461844903', '0', '0', '0', '0', '0', '正常使用');
INSERT INTO `sbox_device_info` VALUES ('49', '11', '-1', '-1', 'bWluaTAx', 'c5e348f0f230bfa42823642fbf6d2b8f', '6bf8688ab79265657fc93d0873530a8a', '-1', '2023-05-24 23:33:54', 'default', 'default', '116bf8688ab79265657fc93d0873530a8a', '-1', '-1', '1', '0', '_NONE.mp3', '_NONE.mp3', '2023-05-24 23:33:54', '116.40389220333873|39.91411461844903', '0', '0', '0', '0', '0', '正常使用');
INSERT INTO `sbox_device_info` VALUES ('50', '11', '-1', '-1', 'bWluaTAy', '4136f4cdffe35265dd9d169afa193872', 'b5d6478d5c1218944954dd7ed143c479', '-1', '2023-05-24 23:33:54', 'default', 'default', '11b5d6478d5c1218944954dd7ed143c479', '-1', '-1', '1', '0', '_NONE.mp3', '_NONE.mp3', '2023-05-24 23:33:54', '116.40389220333873|39.91411461844903', '0', '0', '0', '0', '0', '正常使用');
INSERT INTO `sbox_device_info` VALUES ('60', '11', '-1', '-1', '5oql6K2m', '8c215505fb0e1dc889279a6941bf9a1f', 'a53906f3e9c8f3015e0c51c837376d8f', '-1', '2023-05-24 23:46:54', 'default', 'default', '11a53906f3e9c8f3015e0c51c837376d8f', '50', '1', '2', '0', '_NONE.mp3', '_NONE.mp3', '2023-05-24 23:46:54', '116.40389220333873|39.91411461844903', '0', '0', '0', '0', '0', '正常使用');
INSERT INTO `sbox_device_info` VALUES ('63', '11', '-1', '-1', 'bWluaTAz', '8fdfd92e59d56d3389cdf86b9cb2e2b6', '77b12d0065cf1182666f8e06fcf73b80', '-1', '2023-05-25 00:01:08', 'default', 'default', '1177b12d0065cf1182666f8e06fcf73b80', '-1', '-1', '1', '0', '_NONE.mp3', '_NONE.mp3', '2023-05-25 00:01:08', '116.40389220333873|39.91411461844903', '0', '0', '0', '0', '0', '正常使用');
INSERT INTO `sbox_device_info` VALUES ('64', '12', '-1', '-1', 'bWluaTAy', '4136f4cdffe35265dd9d169afa193872', 'b5d6478d5c1218944954dd7ed143c479', '-1', '2023-05-25 00:01:16', 'default', 'default', '12b5d6478d5c1218944954dd7ed143c479', '-1', '-1', '1', '0', '_NONE.mp3', '_NONE.mp3', '2023-05-25 00:01:16', '116.40389220333873|39.91411461844903', '0', '0', '0', '0', '0', '正常使用');
INSERT INTO `sbox_device_info` VALUES ('65', '12', '-1', '-1', 'bWluaTAz', '8fdfd92e59d56d3389cdf86b9cb2e2b6', '77b12d0065cf1182666f8e06fcf73b80', '-1', '2023-05-25 00:01:16', 'default', 'default', '1277b12d0065cf1182666f8e06fcf73b80', '-1', '-1', '1', '0', '_NONE.mp3', '_NONE.mp3', '2023-05-25 00:01:16', '116.40389220333873|39.91411461844903', '0', '0', '0', '0', '0', '正常使用');
INSERT INTO `sbox_device_info` VALUES ('66', '9', '-1', '-1', 'bWluaTAx', 'c5e348f0f230bfa42823642fbf6d2b8f', '6bf8688ab79265657fc93d0873530a8a', '-1', '2023-05-25 00:01:29', 'default', 'default', '96bf8688ab79265657fc93d0873530a8a', '-1', '-1', '1', '0', '_NONE.mp3', '_NONE.mp3', '2023-05-25 00:01:29', '116.40389220333873|39.91411461844903', '0', '0', '0', '0', '0', '正常使用');
INSERT INTO `sbox_device_info` VALUES ('67', '9', '-1', '-1', 'bWluaTAy', '4136f4cdffe35265dd9d169afa193872', 'b5d6478d5c1218944954dd7ed143c479', '-1', '2023-05-25 00:01:29', 'default', 'default', '9b5d6478d5c1218944954dd7ed143c479', '-1', '-1', '1', '0', '_NONE.mp3', '_NONE.mp3', '2023-05-25 00:01:29', '116.40389220333873|39.91411461844903', '0', '0', '0', '0', '0', '正常使用');
INSERT INTO `sbox_device_info` VALUES ('68', '9', '-1', '-1', 'bWluaTAz', '8fdfd92e59d56d3389cdf86b9cb2e2b6', '77b12d0065cf1182666f8e06fcf73b80', '-1', '2023-05-25 00:01:29', 'default', 'default', '977b12d0065cf1182666f8e06fcf73b80', '-1', '-1', '1', '0', '_NONE.mp3', '_NONE.mp3', '2023-05-25 00:01:29', '116.40389220333873|39.91411461844903', '0', '0', '0', '0', '0', '正常使用');
INSERT INTO `sbox_device_info` VALUES ('69', '9', '-1', '-1', '5oql6K2m', '8c215505fb0e1dc889279a6941bf9a1f', 'a53906f3e9c8f3015e0c51c837376d8f', '-1', '2023-05-25 00:01:29', 'default', 'default', '9a53906f3e9c8f3015e0c51c837376d8f', '50', '1', '2', '0', '_NONE.mp3', '_NONE.mp3', '2023-05-25 00:01:29', '116.40389220333873|39.91411461844903', '0', '0', '0', '0', '0', '正常使用');
INSERT INTO `sbox_device_info` VALUES ('75', '6', '-1', '-1', 'RFNJ', 'b90d1afa957f26786133deb83368723d', '8e6b85a54c36d87080ca19d7495b874e', '1', '2023-09-28 21:48:47', 'default', 'default', '8e6b85a54c36d87080ca19d7495b874e6', '60', '0', '2', '0', '_NONE.mp3', '_NONE.mp3', '2023-09-28 21:48:47', '116.40389220333873|39.91411461844903', '0', '0', '0', '0', '0', '正常使用');
INSERT INTO `sbox_device_info` VALUES ('76', '13', '-1', '-1', 'RFNJSQ==', 'b90d1afa957f26786133deb83368723d', '8e6b85a54c36d87080ca19d7495b874e', '-1', '2023-09-28 23:40:42', 'default', 'default', '138e6b85a54c36d87080ca19d7495b874e', '60', '0', '2', '0', '_NONE.mp3', '_NONE.mp3', '2023-09-28 23:40:42', '116.40389220333873|39.91411461844903', '0', '0', '0', '0', '0', '正常使用');

-- ----------------------------
-- Table structure for `sbox_group`
-- ----------------------------
DROP TABLE IF EXISTS `sbox_group`;
CREATE TABLE `sbox_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userid` int(11) NOT NULL DEFAULT '0',
  `group_name` varchar(200) NOT NULL,
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `nodeid` int(11) NOT NULL DEFAULT '-1',
  `msurl` varchar(405) NOT NULL DEFAULT 'none',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sbox_group
-- ----------------------------
INSERT INTO `sbox_group` VALUES ('17', '6', '5rWL6K+V5YiG57uE', '2023-09-28 22:01:20', '1', 'https://open.ys7.com/v3/openlive/D52714235_1_1.m3u8?expire=1729398958&id=637630502967517184&t=03e482ec1066512062c00cb05d58201ffac115f0e3f1c02217277d8cf7c9ee83&ev=100');
INSERT INTO `sbox_group` VALUES ('18', '13', '5rWL6K+V5YiG57uE', '2023-09-29 01:42:37', '1', 'none');

-- ----------------------------
-- Table structure for `sbox_node`
-- ----------------------------
DROP TABLE IF EXISTS `sbox_node`;
CREATE TABLE `sbox_node` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `node_name` text NOT NULL,
  `nodeip` varchar(45) NOT NULL,
  `nodeport1` int(11) NOT NULL,
  `nodeport2` int(11) NOT NULL,
  `nodeport3` int(11) NOT NULL,
  `nodeport4` int(11) NOT NULL,
  `nodeport5` int(11) NOT NULL,
  `nodeuserid` int(11) NOT NULL,
  `detail` varchar(45) NOT NULL,
  `nodeip_userid` varchar(45) DEFAULT NULL,
  `node_work` int(11) NOT NULL DEFAULT '0',
  `node_port6` int(11) NOT NULL DEFAULT '20004',
  `cdnpath` varchar(100) NOT NULL DEFAULT 'cdn.ployq.com/gsh',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sbox_node
-- ----------------------------
INSERT INTO `sbox_node` VALUES ('1', '服务', '192.168.0.115', '3333', '9003', '9006', '9002', '9003', '1', 'none', '1', '0', '6004', '0');

-- ----------------------------
-- Table structure for `sbox_users`
-- ----------------------------
DROP TABLE IF EXISTS `sbox_users`;
CREATE TABLE `sbox_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_name` varchar(45) NOT NULL,
  `user_pass` varchar(45) NOT NULL,
  `user_type` int(11) NOT NULL DEFAULT '0',
  `user_level` int(11) NOT NULL DEFAULT '800',
  `play_level` int(11) NOT NULL DEFAULT '5',
  `master_id` int(11) NOT NULL DEFAULT '-1',
  `ctime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` int(11) NOT NULL DEFAULT '0',
  `mask` varchar(100) NOT NULL DEFAULT '1111111111111111111111111111111111111111111',
  `beizhu` varchar(2000) NOT NULL DEFAULT 'Tk9USElORw==',
  `dingshi` varchar(45) NOT NULL DEFAULT '1',
  `shangchuan` varchar(45) NOT NULL DEFAULT '1',
  `qianfei` varchar(45) NOT NULL DEFAULT '0',
  `jiankong` varchar(45) NOT NULL DEFAULT '1',
  `cdnpath` varchar(100) NOT NULL DEFAULT 'cdn.ployq.com/gsh',
  `token` varchar(200) NOT NULL DEFAULT 'none',
  `nickname` varchar(45) NOT NULL DEFAULT 'nickname',
  `nickface` varchar(45) NOT NULL DEFAULT 'u1.jpg',
  `winfo` varchar(1000) NOT NULL DEFAULT 'none',
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`user_name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sbox_users
-- ----------------------------
INSERT INTO `sbox_users` VALUES ('6', 'admin', '123123123', '1', '9', '-1', '-1', '2022-11-21 00:12:47', '0', '1111111111111111111111111111111111111111111111111', 'Tk9USElORw==', '1', '1', '0', '1', 'cdn.ployq.com/gsh', 'e1edf78dcf26e0457880c62aae017bb1a0648bf8', '小播鼠兜兜', 'u1.jpg', 'none');
INSERT INTO `sbox_users` VALUES ('7', 'oxiaom666', '123123123', '1', '9', '-1', '-99', '2023-01-09 14:07:20', '0', '1111111111111111111111111111111111111111111111111', 'Tk9USElORw==', '1', '1', '0', '1', 'cdn.ployq.com/gsh', 'bb4e56a61b5154127420d0709cbb9761cf8615e3', 'nickname', 'u1.jpg', 'none');
INSERT INTO `sbox_users` VALUES ('8', 'oxiaom4', '123123123', '1', '9', '-1', '5', '2023-01-11 12:36:43', '0', '0111111111111111111111111111111111111111111111111', 'Tk9USElORw==', '1', '1', '0', '1', 'cdn.ployq.com/gsh', 'a090bc25f6f639c07c5372b95c6418438112e769', 'nickname', 'u1.jpg', 'none');
INSERT INTO `sbox_users` VALUES ('13', 'oxiaom6', '123123qq', '0', '800', '5', '6', '2023-09-28 23:40:36', '0', '00000000000000000000000000000000000000000000', 'NOTHING', '1', '1', '0', '1', 'cdn.ployq.com/gsh', '2d59207fc8fac7887a04721fc923c74b48260e50', 'nickname', 'u1.jpg', 'none');

-- ----------------------------
-- Table structure for `sharefiles`
-- ----------------------------
DROP TABLE IF EXISTS `sharefiles`;
CREATE TABLE `sharefiles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userid` int(11) NOT NULL DEFAULT '0',
  `path` varchar(2000) NOT NULL DEFAULT 'none',
  `uname` varchar(2000) NOT NULL DEFAULT 'none',
  `detail` varchar(2000) NOT NULL DEFAULT 'none',
  `count` int(11) NOT NULL DEFAULT '0',
  `weight` int(11) NOT NULL DEFAULT '0',
  `fileid` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sharefiles
-- ----------------------------
INSERT INTO `sharefiles` VALUES ('1', '6', '@path', 'LSDkv4TnvZfmlq9ISVAgSE9QLm1wMw==', 'none', '0', '0', '0');
INSERT INTO `sharefiles` VALUES ('2', '6', '@path', 'LSDkv4TnvZfmlq9ISVAgSE9QLm1wMw==', 'none', '0', '0', '0');
INSERT INTO `sharefiles` VALUES ('3', '6', '@path', 'LSDkv4TnvZfmlq9ISVAgSE9QLm1wMw==', 'none', '0', '0', '0');
INSERT INTO `sharefiles` VALUES ('4', '6', '@path', 'LSDkv4TnvZfmlq9ISVAgSE9QLm1wMw==', 'none', '0', '0', '0');
INSERT INTO `sharefiles` VALUES ('5', '6', '@path', 'MTY0ODQ2MjM3NDQxMC5tcDM=', 'none', '0', '0', '0');
INSERT INTO `sharefiles` VALUES ('6', '6', '@path', 'Mjg2Mjk2Ql9QNjQucmFy', 'none', '0', '0', '0');
INSERT INTO `sharefiles` VALUES ('7', '6', '@path', 'VE9PTFMuSU5J', 'none', '0', '0', '0');
INSERT INTO `sharefiles` VALUES ('8', '6', '@path', 'bG11dGlsLmV4ZQ==', 'none', '0', '0', '0');
INSERT INTO `sharefiles` VALUES ('9', '6', '@path', 'UGFja1VuemlwLmV4ZQ==', 'none', '0', '0', '0');
INSERT INTO `sharefiles` VALUES ('10', '6', '@path', 'VVY0LmV4ZQ==', 'none', '0', '0', '0');
INSERT INTO `sharefiles` VALUES ('11', '6', '@path', 'cHJvamVjdF9ndWkueHNk', 'none', '0', '0', '0');
INSERT INTO `sharefiles` VALUES ('12', '6', '@path', 'NC56aXA=', 'none', '0', '0', '0');
INSERT INTO `sharefiles` VALUES ('13', '7', '@path', 'dW5kZWZpbmVk', 'none', '0', '0', '0');
INSERT INTO `sharefiles` VALUES ('14', '7', '@path', 'dW5kZWZpbmVk', 'none', '0', '0', '0');
INSERT INTO `sharefiles` VALUES ('15', '7', '@path', 'dW5kZWZpbmVk', 'none', '0', '0', '0');
INSERT INTO `sharefiles` VALUES ('16', '7', '@path', 'dW5kZWZpbmVk', 'none', '0', '0', '0');
INSERT INTO `sharefiles` VALUES ('17', '7', '@path', 'dW5kZWZpbmVk', 'none', '0', '0', '0');
INSERT INTO `sharefiles` VALUES ('18', '7', '@path', 'dW5kZWZpbmVk', 'none', '0', '0', '0');
INSERT INTO `sharefiles` VALUES ('19', '7', '@path', 'dW5kZWZpbmVk', 'none', '0', '0', '0');
INSERT INTO `sharefiles` VALUES ('20', '7', '@path', 'MjAyMzEwMjExMjU2MDguanBn', 'none', '0', '0', '0');
INSERT INTO `sharefiles` VALUES ('21', '7', '@path', '5b6u5L+h5oiq5Zu+XzIwMjMxMDIxMTc1MzI0LmpwZw==', 'none', '0', '0', '0');

-- ----------------------------
-- Table structure for `swap_info`
-- ----------------------------
DROP TABLE IF EXISTS `swap_info`;
CREATE TABLE `swap_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `url` varchar(200) NOT NULL,
  `title` varchar(2000) NOT NULL,
  `type` varchar(45) NOT NULL,
  `to` varchar(200) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of swap_info
-- ----------------------------
INSERT INTO `swap_info` VALUES ('6', 'http://192.168.3.105:12080/31323364313834333137.jpg', '啊实打实发的时代GV送达方刚手打发撒', 'image', '#');
INSERT INTO `swap_info` VALUES ('8', 'http://192.168.3.105:12080/e5beaee4bfa1e688aae59bbe5f3230323331303231313735333234.jpg', '手动阀所发生的胜多负少水电费撒旦法撒旦法', 'image', '#');
INSERT INTO `swap_info` VALUES ('9', 'http://192.168.3.105:12080/e5beaee4bfa1e688aae59bbe5f3230323331303231313735333234.jpg', '啊沙发斯蒂芬斯蒂芬', 'image', '#');
INSERT INTO `swap_info` VALUES ('12', '#', '撒旦法申达股份第三方个短发挂号费挂号费更好111', 'info', '3');
INSERT INTO `swap_info` VALUES ('13', 'http://192.168.3.105:12080/7374617469632f7531.jpg', '', 'touxiang', '#');

-- ----------------------------
-- Table structure for `task`
-- ----------------------------
DROP TABLE IF EXISTS `task`;
CREATE TABLE `task` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userid` int(11) NOT NULL,
  `start_time` int(11) NOT NULL,
  `task_name` varchar(200) NOT NULL DEFAULT 'taskname',
  `nodeid` int(11) NOT NULL DEFAULT '0',
  `len` int(11) NOT NULL DEFAULT '0',
  `enable` int(11) NOT NULL DEFAULT '0',
  `week` varchar(11) NOT NULL DEFAULT '1111111',
  `kind` int(11) NOT NULL DEFAULT '1',
  `startdate` int(11) NOT NULL DEFAULT '0',
  `enddate` int(11) NOT NULL DEFAULT '0',
  `jiange` int(11) NOT NULL DEFAULT '0',
  `statu` int(11) NOT NULL DEFAULT '0',
  `groupid` int(11) NOT NULL DEFAULT '0',
  `fileids` varchar(6000) NOT NULL DEFAULT '0',
  `snids` varchar(6000) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of task
-- ----------------------------
INSERT INTO `task` VALUES ('32', '6', '12251', '1688585064659', '1', '600', '1', '1111111', '1', '0', '0', '2', '0', '0', '100|102', '27|19|25');
INSERT INTO `task` VALUES ('33', '6', '12277', '1688585087788', '1', '750', '1', '1111111', '1', '0', '0', '2', '0', '0', '101|102|103', '19|26|28');
INSERT INTO `task` VALUES ('34', '6', '78559', '1688747672103', '1', '3600', '1', '1111111', '0', '0', '0', '2', '0', '0', '99|101', '19|25|26');
INSERT INTO `task` VALUES ('35', '6', '2778', '1688748380878', '1', '600', '0', '1111111', '1', '0', '0', '2', '0', '0', '137|139', '28');
INSERT INTO `task` VALUES ('36', '6', '2879', '士大夫噶水电费', '1', '3660', '0', '1111111', '0', '0', '0', '2', '0', '0', '100|101|103', '26|28');
INSERT INTO `task` VALUES ('37', '6', '73718', '士大夫噶水电费的', '1', '600', '0', '1111111', '1', '0', '0', '2', '0', '0', '99|101', '18|19|25|26|27|28|30|31|70|71');
INSERT INTO `task` VALUES ('38', '6', '76256', '123啊实打实', '1', '4563', '0', '1111100', '0', '0', '0', '10', '0', '0', '99|102', '19|26');
INSERT INTO `task` VALUES ('39', '6', '70051', '新的任务名字23', '1', '600', '0', '1111100', '1', '0', '0', '2', '0', '0', '100|103', '19|27');
INSERT INTO `task` VALUES ('40', '6', '3753', '新的任务名字2322', '1', '7806', '0', '1111100', '6', '19509', '19566', '35', '0', '0', '98|101', '26|19');

-- ----------------------------
-- Table structure for `taskfile`
-- ----------------------------
DROP TABLE IF EXISTS `taskfile`;
CREATE TABLE `taskfile` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `taskid` int(11) NOT NULL,
  `fileid` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=299 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of taskfile
-- ----------------------------
INSERT INTO `taskfile` VALUES ('54', '4', '38');
INSERT INTO `taskfile` VALUES ('55', '5', '97');
INSERT INTO `taskfile` VALUES ('56', '5', '98');
INSERT INTO `taskfile` VALUES ('57', '5', '99');
INSERT INTO `taskfile` VALUES ('58', '6', '95');
INSERT INTO `taskfile` VALUES ('59', '6', '97');
INSERT INTO `taskfile` VALUES ('60', '6', '98');
INSERT INTO `taskfile` VALUES ('61', '7', '99');
INSERT INTO `taskfile` VALUES ('62', '7', '100');
INSERT INTO `taskfile` VALUES ('63', '8', '97');
INSERT INTO `taskfile` VALUES ('64', '8', '98');
INSERT INTO `taskfile` VALUES ('65', '8', '99');
INSERT INTO `taskfile` VALUES ('66', '9', '97');
INSERT INTO `taskfile` VALUES ('67', '9', '98');
INSERT INTO `taskfile` VALUES ('68', '9', '99');
INSERT INTO `taskfile` VALUES ('269', '32', '100');
INSERT INTO `taskfile` VALUES ('270', '32', '102');
INSERT INTO `taskfile` VALUES ('271', '33', '101');
INSERT INTO `taskfile` VALUES ('272', '33', '102');
INSERT INTO `taskfile` VALUES ('273', '33', '103');
INSERT INTO `taskfile` VALUES ('274', '34', '99');
INSERT INTO `taskfile` VALUES ('275', '34', '101');
INSERT INTO `taskfile` VALUES ('276', '35', '137');
INSERT INTO `taskfile` VALUES ('277', '35', '139');
INSERT INTO `taskfile` VALUES ('278', '36', '100');
INSERT INTO `taskfile` VALUES ('279', '36', '101');
INSERT INTO `taskfile` VALUES ('280', '36', '103');
INSERT INTO `taskfile` VALUES ('281', '37', '99');
INSERT INTO `taskfile` VALUES ('282', '37', '101');
INSERT INTO `taskfile` VALUES ('283', '38', '99');
INSERT INTO `taskfile` VALUES ('284', '38', '102');
INSERT INTO `taskfile` VALUES ('285', '39', '100');
INSERT INTO `taskfile` VALUES ('286', '39', '103');
INSERT INTO `taskfile` VALUES ('293', '40', '98');
INSERT INTO `taskfile` VALUES ('294', '40', '101');
INSERT INTO `taskfile` VALUES ('295', '40', '102');
INSERT INTO `taskfile` VALUES ('296', '40', '104');
INSERT INTO `taskfile` VALUES ('297', '40', '127');
INSERT INTO `taskfile` VALUES ('298', '40', '129');

-- ----------------------------
-- Table structure for `taskgroup`
-- ----------------------------
DROP TABLE IF EXISTS `taskgroup`;
CREATE TABLE `taskgroup` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userid` int(11) NOT NULL,
  `groupname` varchar(200) NOT NULL DEFAULT 'none',
  `status` int(11) NOT NULL DEFAULT '0',
  `taskids` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of taskgroup
-- ----------------------------
INSERT INTO `taskgroup` VALUES ('1', '6', '5ZWK5a6e5omT5a6e5aSn', '0', '0');

-- ----------------------------
-- Table structure for `taskpop`
-- ----------------------------
DROP TABLE IF EXISTS `taskpop`;
CREATE TABLE `taskpop` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `taskid` int(11) DEFAULT '0',
  `status` int(11) NOT NULL DEFAULT '0',
  `userid` int(11) NOT NULL DEFAULT '0',
  `seeds` varchar(6000) DEFAULT NULL,
  `urls` varchar(6000) DEFAULT NULL,
  `kind` int(11) NOT NULL DEFAULT '0',
  `jiange` int(11) NOT NULL DEFAULT '0',
  `ip` varchar(45) DEFAULT NULL,
  `port` int(11) DEFAULT NULL,
  `len` int(11) DEFAULT '0',
  `playmode` int(11) DEFAULT '0',
  `info` varchar(200) NOT NULL DEFAULT 'none',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=456 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of taskpop
-- ----------------------------
INSERT INTO `taskpop` VALUES ('288', '2023-01-10 16:39:06', '0', '0', '6', 'f765ee0c872ad630fc8609a207473b5f|34e159ed9561cbb1d90a4f8c58125623|e1530f1287cfbb086a8fa421ddcec600', 'http://192.168.3.211:12080/mp3/6/536f756ce380826d616e2d4265617420497420e5a5b3e5a3b0e68a92e68385e78988206d6ae6b0b8e59e82e4b88de69cbd2e6d7033.mp3T,237', '2', '2', '192.168.3.211', '3306', '3000', '3', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('289', '2023-01-10 16:40:10', '288', '0', '6', null, null, '2', '0', '192.168.3.211', '3306', '0', '0', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('290', '2023-01-10 16:40:19', '288', '0', '6', null, null, '2', '0', '192.168.3.211', '3306', '0', '0', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('291', '2023-01-10 20:58:23', '0', '0', '6', 'f765ee0c872ad630fc8609a207473b5f|34e159ed9561cbb1d90a4f8c58125623|e1530f1287cfbb086a8fa421ddcec600', 'http://192.168.3.211:12080/mp3/6/536f756ce380826d616e2d4265617420497420e5a5b3e5a3b0e68a92e68385e78988206d6ae6b0b8e59e82e4b88de69cbd2e6d7033.mp3T,237', '2', '2', '192.168.3.211', '3306', '3000', '3', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('292', '2023-01-10 20:58:38', '291', '0', '6', null, null, '2', '0', '192.168.3.211', '3306', '0', '0', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('293', '2023-01-10 21:10:01', '0', '0', '6', 'f765ee0c872ad630fc8609a207473b5f|34e159ed9561cbb1d90a4f8c58125623|e1530f1287cfbb086a8fa421ddcec600', 'http://192.168.3.211:12080/mp3/6/536f756ce380826d616e2d4265617420497420e5a5b3e5a3b0e68a92e68385e78988206d6ae6b0b8e59e82e4b88de69cbd2e6d7033.mp3T,237', '2', '2', '192.168.3.211', '3306', '3000', '3', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('294', '2023-01-10 21:13:32', '0', '0', '6', 'f765ee0c872ad630fc8609a207473b5f|34e159ed9561cbb1d90a4f8c58125623|e1530f1287cfbb086a8fa421ddcec600', 'http://192.168.3.211:12080/mp3/6/536f756ce380826d616e2d4265617420497420e5a5b3e5a3b0e68a92e68385e78988206d6ae6b0b8e59e82e4b88de69cbd2e6d7033.mp3T,237', '2', '2', '192.168.3.211', '3306', '3000', '3', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('295', '2023-01-10 21:13:53', '294', '0', '6', null, null, '2', '0', '192.168.3.211', '3306', '0', '0', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('296', '2023-01-10 21:14:52', '0', '0', '6', 'f765ee0c872ad630fc8609a207473b5f|34e159ed9561cbb1d90a4f8c58125623|e1530f1287cfbb086a8fa421ddcec600', 'http://192.168.3.211:12080/mp3/6/536f756ce380826d616e2d4265617420497420e5a5b3e5a3b0e68a92e68385e78988206d6ae6b0b8e59e82e4b88de69cbd2e6d7033.mp3T,237', '2', '2', '192.168.3.211', '3306', '3000', '3', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('297', '2023-01-10 21:15:02', '296', '0', '6', null, null, '2', '0', '192.168.3.211', '3306', '0', '0', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('298', '2023-01-10 21:16:45', '0', '0', '6', 'f765ee0c872ad630fc8609a207473b5f|34e159ed9561cbb1d90a4f8c58125623|e1530f1287cfbb086a8fa421ddcec600', 'http://192.168.3.211:12080/mp3/6/536f756ce380826d616e2d4265617420497420e5a5b3e5a3b0e68a92e68385e78988206d6ae6b0b8e59e82e4b88de69cbd2e6d7033.mp3T,237', '2', '2', '192.168.3.211', '3306', '3000', '3', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('299', '2023-01-10 21:17:56', '0', '0', '6', 'f765ee0c872ad630fc8609a207473b5f|34e159ed9561cbb1d90a4f8c58125623|e1530f1287cfbb086a8fa421ddcec600', 'http://192.168.3.211:12080/mp3/6/536f756ce380826d616e2d4265617420497420e5a5b3e5a3b0e68a92e68385e78988206d6ae6b0b8e59e82e4b88de69cbd2e6d7033.mp3T,237', '2', '2', '192.168.3.211', '3306', '3000', '3', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('300', '2023-01-10 21:18:08', '299', '0', '6', null, null, '2', '0', '192.168.3.211', '3306', '0', '0', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('301', '2023-01-11 12:40:45', '0', '0', '6', 'f765ee0c872ad630fc8609a207473b5f|34e159ed9561cbb1d90a4f8c58125623|e1530f1287cfbb086a8fa421ddcec600', 'http://192.168.3.211:12080/mp3/6/536f756ce380826d616e2d4265617420497420e5a5b3e5a3b0e68a92e68385e78988206d6ae6b0b8e59e82e4b88de69cbd2e6d7033.mp3T,237', '2', '2', '192.168.3.211', '6006', '3000', '3', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('302', '2023-01-11 12:40:59', '301', '0', '6', null, null, '2', '0', '192.168.3.211', '3306', '0', '0', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('303', '2023-01-11 12:52:41', '0', '0', '6', 'f765ee0c872ad630fc8609a207473b5f|34e159ed9561cbb1d90a4f8c58125623|e1530f1287cfbb086a8fa421ddcec600', 'http://192.168.3.211:12080/mp3/6/536f756ce380826d616e2d4265617420497420e5a5b3e5a3b0e68a92e68385e78988206d6ae6b0b8e59e82e4b88de69cbd2e6d7033.mp3T,237', '2', '2', '192.168.3.211', '6006', '3000', '3', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('304', '2023-01-11 12:52:51', '303', '0', '6', null, null, '2', '0', '192.168.3.211', '6006', '0', '0', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('305', '2023-01-11 12:58:49', '4', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('306', '2023-01-11 14:13:57', '0', '0', '6', 'f765ee0c872ad630fc8609a207473b5f|34e159ed9561cbb1d90a4f8c58125623|e1530f1287cfbb086a8fa421ddcec600', 'http://192.168.3.211:12080/mp3/6/536f756ce380826d616e2d4265617420497420e5a5b3e5a3b0e68a92e68385e78988206d6ae6b0b8e59e82e4b88de69cbd2e6d7033.mp3T,237', '2', '2', '192.168.3.211', '6006', '3000', '3', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('307', '2023-01-11 14:15:15', '306', '0', '6', null, null, '2', '0', '192.168.3.211', '6006', '0', '0', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('308', '2023-01-13 13:00:09', '4', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('309', '2023-01-14 13:01:35', '4', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('310', '2023-03-21 22:37:57', '13', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('311', '2023-03-21 22:38:52', '13', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('312', '2023-03-21 22:40:52', '12', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('313', '2023-03-21 22:41:03', '12', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('314', '2023-03-21 22:41:43', '12', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('315', '2023-03-21 22:41:59', '12', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('316', '2023-03-21 22:42:45', '12', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('317', '2023-03-21 22:43:00', '12', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('318', '2023-03-21 22:45:48', '12', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('319', '2023-03-21 22:46:09', '12', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('320', '2023-03-21 22:51:46', '11', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('321', '2023-03-26 21:37:20', '22', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('322', '2023-03-26 21:40:09', '22', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('323', '2023-03-26 21:40:47', '22', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('324', '2023-03-26 21:41:44', '22', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('325', '2023-03-26 21:41:58', '22', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('326', '2023-03-26 21:51:14', '11', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('327', '2023-04-01 16:26:28', '10', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('328', '2023-04-01 16:26:47', '10', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('329', '2023-04-01 16:27:04', '10', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('330', '2023-04-01 16:27:19', '10', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('331', '2023-04-01 16:29:16', '10', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('332', '2023-04-01 16:32:02', '10', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('333', '2023-04-01 16:34:05', '10', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('334', '2023-04-01 16:34:26', '10', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('335', '2023-04-01 16:45:40', '10', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('336', '2023-04-01 16:46:05', '10', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('337', '2023-04-01 16:47:14', '22', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('338', '2023-04-01 16:47:23', '22', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('339', '2023-04-01 16:54:00', '12', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('340', '2023-04-01 16:54:15', '12', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('341', '2023-04-01 16:56:55', '12', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('342', '2023-04-01 16:56:59', '12', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('343', '2023-04-01 16:57:58', '12', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('344', '2023-04-01 16:58:13', '12', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('345', '2023-04-01 17:16:55', '13', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('346', '2023-04-01 17:17:14', '13', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('347', '2023-04-01 17:22:26', '28', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('348', '2023-04-01 17:22:46', '28', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('349', '2023-04-01 17:25:16', '30', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('350', '2023-04-01 17:25:31', '30', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('351', '2023-04-10 00:47:20', '0', '0', '6', '6bf8688ab79265657fc93d0873530a8a|b5d6478d5c1218944954dd7ed143c479|77b12d0065cf1182666f8e06fcf73b80', 'http://129.211.117.94:12080/mp3/6/4a61636b5361766f72657474692d5275737369616e526f756c65747465e380822e6d7033.mp3T,278|http://129.211.117.94:12080/mp3/6/4b61746552757362792d4661726577656c6c2e6d7033.mp3T,335|http://129.211.117.94:12080/mp3/6/5275737369616e4769726ce6a091e5ad90e8af95e590ac2d2d536f6e675461737465e794a8e99fb3e4b990e580bee590ace5bdbce6ada42e6d7033.mp3T,279|http://129.211.117.94:12080/mp3/6/536f756ce380826d616e2d426561744974e5a5b3e5a3b0e68a92e68385e789886d6ae6b0b8e59e82e4b88de69cbd2e6d7033.mp3T,237', '2', '2', '129.211.117.94', '9006', '300', '1', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('352', '2023-04-10 00:51:19', '0', '0', '6', '6bf8688ab79265657fc93d0873530a8a|b5d6478d5c1218944954dd7ed143c479|77b12d0065cf1182666f8e06fcf73b80', 'http://129.211.117.94:12080/mp3/6/e9aaa8e781b0e7baa7e4b8b6e5b08fe6bca02d4465636973696f6e73e5898de5a58fe5b0b1e788b1e4b88ae8b685e8b59ee5a5b3e5a3b0e594a4e98692e4ba86e68891e79a84e781b5e9ad822e6d7033.mp3T,236|http://129.211.117.94:12080/mp3/6/536f756ce380826d616e2d426561744974e5a5b3e5a3b0e68a92e68385e789886d6ae6b0b8e59e82e4b88de69cbd2e6d7033.mp3T,237', '2', '2', '129.211.117.94', '9006', '300', '1', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('353', '2023-04-10 00:55:14', '0', '0', '6', '6bf8688ab79265657fc93d0873530a8a|b5d6478d5c1218944954dd7ed143c479|77b12d0065cf1182666f8e06fcf73b80', 'http://129.211.117.94:12080/mp3/6/e9aaa8e781b0e7baa7e4b8b6e5b08fe6bca02d4465636973696f6e73e5898de5a58fe5b0b1e788b1e4b88ae8b685e8b59ee5a5b3e5a3b0e594a4e98692e4ba86e68891e79a84e781b5e9ad822e6d7033.mp3T,236|http://129.211.117.94:12080/mp3/6/536f756ce380826d616e2d426561744974e5a5b3e5a3b0e68a92e68385e789886d6ae6b0b8e59e82e4b88de69cbd2e6d7033.mp3T,237', '2', '2', '129.211.117.94', '9006', '300', '1', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('354', '2023-04-10 00:56:33', '0', '0', '6', '6bf8688ab79265657fc93d0873530a8a|b5d6478d5c1218944954dd7ed143c479|77b12d0065cf1182666f8e06fcf73b80', 'http://129.211.117.94:12080/mp3/6/4a61636b5361766f72657474692d5275737369616e526f756c65747465e380822e6d7033.mp3T,278|http://129.211.117.94:12080/mp3/6/4b61746552757362792d4661726577656c6c2e6d7033.mp3T,335|http://129.211.117.94:12080/mp3/6/5275737369616e4769726ce6a091e5ad90e8af95e590ac2d2d536f6e675461737465e794a8e99fb3e4b990e580bee590ace5bdbce6ada42e6d7033.mp3T,279|http://129.211.117.94:12080/mp3/6/536f756ce380826d616e2d426561744974e5a5b3e5a3b0e68a92e68385e789886d6ae6b0b8e59e82e4b88de69cbd2e6d7033.mp3T,237', '2', '2', '129.211.117.94', '9006', '300', '1', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('355', '2023-04-10 01:00:45', '0', '0', '6', '6bf8688ab79265657fc93d0873530a8a|b5d6478d5c1218944954dd7ed143c479|77b12d0065cf1182666f8e06fcf73b80', 'http://129.211.117.94:12080/mp3/6/e9aaa8e781b0e7baa7e4b8b6e5b08fe6bca02d4465636973696f6e73e5898de5a58fe5b0b1e788b1e4b88ae8b685e8b59ee5a5b3e5a3b0e594a4e98692e4ba86e68891e79a84e781b5e9ad822e6d7033.mp3T,236|http://129.211.117.94:12080/mp3/6/536f756ce380826d616e2d426561744974e5a5b3e5a3b0e68a92e68385e789886d6ae6b0b8e59e82e4b88de69cbd2e6d7033.mp3T,237', '2', '6', '129.211.117.94', '9006', '1455', '4', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('356', '2023-04-10 01:02:32', '0', '0', '6', '6bf8688ab79265657fc93d0873530a8a|b5d6478d5c1218944954dd7ed143c479|77b12d0065cf1182666f8e06fcf73b80', 'http://129.211.117.94:12080/mp3/6/536f756ce380826d616e2d426561744974e5a5b3e5a3b0e68a92e68385e789886d6ae6b0b8e59e82e4b88de69cbd2e6d7033.mp3T,237', '2', '9', '129.211.117.94', '9006', '1230', '6', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('357', '2023-04-10 01:07:38', '0', '0', '6', '6bf8688ab79265657fc93d0873530a8a|b5d6478d5c1218944954dd7ed143c479|77b12d0065cf1182666f8e06fcf73b80', 'http://129.211.117.94:12080/mp3/6/536f756ce380826d616e2d426561744974e5a5b3e5a3b0e68a92e68385e789886d6ae6b0b8e59e82e4b88de69cbd2e6d7033.mp3T,237', '2', '9', '129.211.117.94', '9006', '1230', '6', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('358', '2023-04-10 01:22:58', '0', '0', '6', '6bf8688ab79265657fc93d0873530a8a|b5d6478d5c1218944954dd7ed143c479|77b12d0065cf1182666f8e06fcf73b80', 'http://129.211.117.94:12080/mp3/6/536f756ce380826d616e2d426561744974e5a5b3e5a3b0e68a92e68385e789886d6ae6b0b8e59e82e4b88de69cbd2e6d7033.mp3T,237', '2', '9', '129.211.117.94', '9006', '1230', '6', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('359', '2023-04-10 01:28:37', '358', '0', '6', null, null, '2', '0', '129.211.117.94', '9006', '0', '0', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('360', '2023-04-10 01:30:31', '0', '0', '6', '6bf8688ab79265657fc93d0873530a8a|b5d6478d5c1218944954dd7ed143c479|77b12d0065cf1182666f8e06fcf73b80', 'http://129.211.117.94:12080/mp3/6/536f756ce380826d616e2d426561744974e5a5b3e5a3b0e68a92e68385e789886d6ae6b0b8e59e82e4b88de69cbd2e6d7033.mp3T,237', '2', '9', '129.211.117.94', '9006', '1230', '6', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('361', '2023-04-10 01:30:42', '360', '0', '6', null, null, '2', '0', '129.211.117.94', '9006', '0', '0', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('362', '2023-04-10 01:32:17', '0', '0', '6', '6bf8688ab79265657fc93d0873530a8a|b5d6478d5c1218944954dd7ed143c479|77b12d0065cf1182666f8e06fcf73b80', 'http://129.211.117.94:12080/mp3/6/2de4bf84e7bd97e696af484950484f502e6d7033.mp3T,234|http://129.211.117.94:12080/mp3/6/e4bf84e7bd97e696afe5a5b3e5a3b0323031362d5265616c4f566973686e79612e6d7033.mp3T,242|http://129.211.117.94:12080/mp3/6/e7bea4e6989f2de5be88e5b8a6e6849fe79a84e4b880e9a696e6ad8ce4b8a8697469736d65e7bea4e6989fe4b8a82e6d7033.mp3T,188', '2', '9', '129.211.117.94', '9006', '4146', '6', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('363', '2023-04-10 01:33:09', '362', '0', '6', null, null, '2', '0', '129.211.117.94', '9006', '0', '0', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('364', '2023-04-10 01:34:34', '0', '0', '6', '6bf8688ab79265657fc93d0873530a8a|b5d6478d5c1218944954dd7ed143c479|77b12d0065cf1182666f8e06fcf73b80', 'http://129.211.117.94:12080/mp3/6/2de4bf84e7bd97e696af484950484f502e6d7033.mp3T,234|http://129.211.117.94:12080/mp3/6/e4bf84e7bd97e696afe5a5b3e5a3b0323031362d5265616c4f566973686e79612e6d7033.mp3T,242|http://129.211.117.94:12080/mp3/6/e7bea4e6989f2de5be88e5b8a6e6849fe79a84e4b880e9a696e6ad8ce4b8a8697469736d65e7bea4e6989fe4b8a82e6d7033.mp3T,188', '2', '9', '129.211.117.94', '9006', '4146', '6', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('365', '2023-04-10 01:34:41', '364', '0', '6', null, null, '2', '0', '129.211.117.94', '9006', '0', '0', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('366', '2023-04-10 01:41:22', '0', '0', '6', '6bf8688ab79265657fc93d0873530a8a|b5d6478d5c1218944954dd7ed143c479|77b12d0065cf1182666f8e06fcf73b80', 'http://129.211.117.94:12080/mp3/6/2de4bf84e7bd97e696af484950484f502e6d7033.mp3T,234|http://129.211.117.94:12080/mp3/6/e4bf84e7bd97e696afe5a5b3e5a3b0323031362d5265616c4f566973686e79612e6d7033.mp3T,242|http://129.211.117.94:12080/mp3/6/e7bea4e6989f2de5be88e5b8a6e6849fe79a84e4b880e9a696e6ad8ce4b8a8697469736d65e7bea4e6989fe4b8a82e6d7033.mp3T,188', '2', '9', '129.211.117.94', '9006', '4146', '6', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('367', '2023-04-10 01:41:31', '366', '0', '6', null, null, '2', '0', '129.211.117.94', '9006', '0', '0', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('368', '2023-04-10 01:43:16', '0', '0', '6', '6bf8688ab79265657fc93d0873530a8a|b5d6478d5c1218944954dd7ed143c479|77b12d0065cf1182666f8e06fcf73b80', 'http://129.211.117.94:12080/mp3/6/536f756ce380826d616e2d426561744974e5a5b3e5a3b0e68a92e68385e789886d6ae6b0b8e59e82e4b88de69cbd2e6d7033.mp3T,237', '2', '9', '129.211.117.94', '9006', '1230', '6', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('369', '2023-04-10 01:43:22', '368', '0', '6', null, null, '2', '0', '129.211.117.94', '9006', '0', '0', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('370', '2023-04-10 01:45:40', '0', '0', '6', '6bf8688ab79265657fc93d0873530a8a|b5d6478d5c1218944954dd7ed143c479|77b12d0065cf1182666f8e06fcf73b80', 'http://129.211.117.94:12080/mp3/6/2de4bf84e7bd97e696af484950484f502e6d7033.mp3T,234|http://129.211.117.94:12080/mp3/6/e4bf84e7bd97e696afe5a5b3e5a3b0323031362d5265616c4f566973686e79612e6d7033.mp3T,242|http://129.211.117.94:12080/mp3/6/e7bea4e6989f2de5be88e5b8a6e6849fe79a84e4b880e9a696e6ad8ce4b8a8697469736d65e7bea4e6989fe4b8a82e6d7033.mp3T,188', '2', '9', '129.211.117.94', '9006', '4146', '6', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('371', '2023-04-10 01:45:48', '0', '0', '6', '6bf8688ab79265657fc93d0873530a8a|b5d6478d5c1218944954dd7ed143c479|77b12d0065cf1182666f8e06fcf73b80', 'http://129.211.117.94:12080/mp3/6/536f756ce380826d616e2d426561744974e5a5b3e5a3b0e68a92e68385e789886d6ae6b0b8e59e82e4b88de69cbd2e6d7033.mp3T,237', '2', '9', '129.211.117.94', '9006', '1230', '6', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('372', '2023-04-10 01:46:05', '371', '0', '6', null, null, '2', '0', '129.211.117.94', '9006', '0', '0', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('373', '2023-04-10 01:46:19', '370', '0', '6', null, null, '2', '0', '129.211.117.94', '9006', '0', '0', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('374', '2023-04-10 01:46:33', '0', '0', '6', '6bf8688ab79265657fc93d0873530a8a|b5d6478d5c1218944954dd7ed143c479|77b12d0065cf1182666f8e06fcf73b80', 'http://129.211.117.94:12080/mp3/6/536f756ce380826d616e2d426561744974e5a5b3e5a3b0e68a92e68385e789886d6ae6b0b8e59e82e4b88de69cbd2e6d7033.mp3T,237', '2', '9', '129.211.117.94', '9006', '1230', '6', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('375', '2023-04-10 01:46:45', '374', '0', '6', null, null, '2', '0', '129.211.117.94', '9006', '0', '0', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('376', '2023-04-10 01:46:57', '0', '0', '6', '6bf8688ab79265657fc93d0873530a8a|b5d6478d5c1218944954dd7ed143c479|77b12d0065cf1182666f8e06fcf73b80', 'http://129.211.117.94:12080/mp3/6/2de4bf84e7bd97e696af484950484f502e6d7033.mp3T,234|http://129.211.117.94:12080/mp3/6/e4bf84e7bd97e696afe5a5b3e5a3b0323031362d5265616c4f566973686e79612e6d7033.mp3T,242|http://129.211.117.94:12080/mp3/6/e7bea4e6989f2de5be88e5b8a6e6849fe79a84e4b880e9a696e6ad8ce4b8a8697469736d65e7bea4e6989fe4b8a82e6d7033.mp3T,188', '2', '9', '129.211.117.94', '9006', '4146', '6', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('377', '2023-04-10 01:48:25', '0', '0', '6', '6bf8688ab79265657fc93d0873530a8a|b5d6478d5c1218944954dd7ed143c479|77b12d0065cf1182666f8e06fcf73b80', 'http://129.211.117.94:12080/mp3/6/536f756ce380826d616e2d426561744974e5a5b3e5a3b0e68a92e68385e789886d6ae6b0b8e59e82e4b88de69cbd2e6d7033.mp3T,237', '2', '9', '129.211.117.94', '9006', '1230', '6', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('378', '2023-04-10 01:49:14', '376', '0', '6', null, null, '2', '0', '129.211.117.94', '9006', '0', '0', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('379', '2023-04-10 01:49:59', '377', '0', '6', null, null, '2', '0', '129.211.117.94', '9006', '0', '0', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('380', '2023-04-10 01:52:25', '0', '0', '6', '6bf8688ab79265657fc93d0873530a8a|b5d6478d5c1218944954dd7ed143c479|77b12d0065cf1182666f8e06fcf73b80', 'http://129.211.117.94:12080/mp3/6/2de4bf84e7bd97e696af484950484f502e6d7033.mp3T,234|http://129.211.117.94:12080/mp3/6/e4bf84e7bd97e696afe5a5b3e5a3b0323031362d5265616c4f566973686e79612e6d7033.mp3T,242|http://129.211.117.94:12080/mp3/6/e7bea4e6989f2de5be88e5b8a6e6849fe79a84e4b880e9a696e6ad8ce4b8a8697469736d65e7bea4e6989fe4b8a82e6d7033.mp3T,188', '2', '9', '129.211.117.94', '9006', '4146', '6', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('381', '2023-04-10 01:52:32', '380', '0', '6', null, null, '2', '0', '129.211.117.94', '9006', '0', '0', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('382', '2023-04-10 01:52:49', '0', '0', '6', '6bf8688ab79265657fc93d0873530a8a|b5d6478d5c1218944954dd7ed143c479|77b12d0065cf1182666f8e06fcf73b80', 'http://129.211.117.94:12080/mp3/6/2de4bf84e7bd97e696af484950484f502e6d7033.mp3T,234|http://129.211.117.94:12080/mp3/6/e4bf84e7bd97e696afe5a5b3e5a3b0323031362d5265616c4f566973686e79612e6d7033.mp3T,242|http://129.211.117.94:12080/mp3/6/e7bea4e6989f2de5be88e5b8a6e6849fe79a84e4b880e9a696e6ad8ce4b8a8697469736d65e7bea4e6989fe4b8a82e6d7033.mp3T,188', '2', '9', '129.211.117.94', '9006', '4146', '6', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('383', '2023-04-10 01:53:11', '382', '0', '6', null, null, '2', '0', '129.211.117.94', '9006', '0', '0', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('384', '2023-04-10 01:53:23', '0', '0', '6', '6bf8688ab79265657fc93d0873530a8a|b5d6478d5c1218944954dd7ed143c479|77b12d0065cf1182666f8e06fcf73b80', 'http://129.211.117.94:12080/mp3/6/536f756ce380826d616e2d426561744974e5a5b3e5a3b0e68a92e68385e789886d6ae6b0b8e59e82e4b88de69cbd2e6d7033.mp3T,237', '2', '9', '129.211.117.94', '9006', '1230', '6', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('385', '2023-04-10 01:53:30', '0', '0', '6', '6bf8688ab79265657fc93d0873530a8a|b5d6478d5c1218944954dd7ed143c479|77b12d0065cf1182666f8e06fcf73b80', 'http://129.211.117.94:12080/mp3/6/2de4bf84e7bd97e696af484950484f502e6d7033.mp3T,234|http://129.211.117.94:12080/mp3/6/e4bf84e7bd97e696afe5a5b3e5a3b0323031362d5265616c4f566973686e79612e6d7033.mp3T,242|http://129.211.117.94:12080/mp3/6/e7bea4e6989f2de5be88e5b8a6e6849fe79a84e4b880e9a696e6ad8ce4b8a8697469736d65e7bea4e6989fe4b8a82e6d7033.mp3T,188', '2', '9', '129.211.117.94', '9006', '4146', '6', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('386', '2023-04-10 01:53:40', '385', '0', '6', null, null, '2', '0', '129.211.117.94', '9006', '0', '0', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('387', '2023-04-10 01:53:51', '384', '0', '6', null, null, '2', '0', '129.211.117.94', '9006', '0', '0', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('388', '2023-04-10 03:07:51', '0', '0', '6', '6bf8688ab79265657fc93d0873530a8a|b5d6478d5c1218944954dd7ed143c479|77b12d0065cf1182666f8e06fcf73b80', 'http://129.211.117.94:12080/mp3/6/2de4bf84e7bd97e696af484950484f502e6d7033.mp3T,234|http://129.211.117.94:12080/mp3/6/e4bf84e7bd97e696afe5a5b3e5a3b0323031362d5265616c4f566973686e79612e6d7033.mp3T,242|http://129.211.117.94:12080/mp3/6/e7bea4e6989f2de5be88e5b8a6e6849fe79a84e4b880e9a696e6ad8ce4b8a8697469736d65e7bea4e6989fe4b8a82e6d7033.mp3T,188', '2', '9', '129.211.117.94', '9006', '4146', '6', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('389', '2023-04-10 03:07:59', '0', '0', '6', '6bf8688ab79265657fc93d0873530a8a|b5d6478d5c1218944954dd7ed143c479|77b12d0065cf1182666f8e06fcf73b80', 'http://129.211.117.94:12080/mp3/6/536f756ce380826d616e2d426561744974e5a5b3e5a3b0e68a92e68385e789886d6ae6b0b8e59e82e4b88de69cbd2e6d7033.mp3T,237', '2', '9', '129.211.117.94', '9006', '1230', '6', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('390', '2023-04-10 03:13:35', '388', '0', '6', null, null, '2', '0', '129.211.117.94', '9006', '0', '0', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('391', '2023-04-10 03:13:46', '389', '0', '6', null, null, '2', '0', '129.211.117.94', '9006', '0', '0', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('392', '2023-04-10 03:20:21', '0', '0', '6', '6bf8688ab79265657fc93d0873530a8a|b5d6478d5c1218944954dd7ed143c479|77b12d0065cf1182666f8e06fcf73b80', 'http://129.211.117.94:12080/mp3/6/2de4bf84e7bd97e696af484950484f502e6d7033.mp3T,234|http://129.211.117.94:12080/mp3/6/e4bf84e7bd97e696afe5a5b3e5a3b0323031362d5265616c4f566973686e79612e6d7033.mp3T,242|http://129.211.117.94:12080/mp3/6/e7bea4e6989f2de5be88e5b8a6e6849fe79a84e4b880e9a696e6ad8ce4b8a8697469736d65e7bea4e6989fe4b8a82e6d7033.mp3T,188', '2', '9', '129.211.117.94', '9006', '4146', '6', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('393', '2023-04-10 03:20:40', '392', '0', '6', null, null, '2', '0', '129.211.117.94', '9006', '0', '0', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('394', '2023-04-10 03:20:51', '0', '0', '6', '6bf8688ab79265657fc93d0873530a8a|b5d6478d5c1218944954dd7ed143c479|77b12d0065cf1182666f8e06fcf73b80', 'http://129.211.117.94:12080/mp3/6/536f756ce380826d616e2d426561744974e5a5b3e5a3b0e68a92e68385e789886d6ae6b0b8e59e82e4b88de69cbd2e6d7033.mp3T,237', '2', '9', '129.211.117.94', '9006', '1230', '6', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('395', '2023-04-10 03:27:09', '394', '0', '6', null, null, '2', '0', '129.211.117.94', '9006', '0', '0', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('396', '2023-04-10 03:27:43', '0', '0', '6', '6bf8688ab79265657fc93d0873530a8a|b5d6478d5c1218944954dd7ed143c479|77b12d0065cf1182666f8e06fcf73b80', 'http://129.211.117.94:12080/mp3/6/e4bf84e7bd97e696afe5a5b3e5a3b0323031362d5265616c4f566973686e79612e6d7033.mp3T,242', '2', '2', '129.211.117.94', '9006', '300', '1', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('397', '2023-04-10 03:39:33', '0', '0', '6', '6bf8688ab79265657fc93d0873530a8a|b5d6478d5c1218944954dd7ed143c479|77b12d0065cf1182666f8e06fcf73b80', 'http://129.211.117.94:12080/mp3/6/e4bf84e7bd97e696afe5a5b3e5a3b0323031362d5265616c4f566973686e79612e6d7033.mp3T,242', '2', '2', '129.211.117.94', '9006', '300', '1', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('398', '2023-04-10 04:16:43', '0', '0', '6', '6bf8688ab79265657fc93d0873530a8a|b5d6478d5c1218944954dd7ed143c479|77b12d0065cf1182666f8e06fcf73b80', 'http://129.211.117.94:12080/mp3/6/e4bf84e7bd97e696afe5a5b3e5a3b0323031362d5265616c4f566973686e79612e6d7033.mp3T,242', '2', '2', '129.211.117.94', '9006', '120', '1', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('399', '2023-04-10 04:19:01', '0', '0', '6', '6bf8688ab79265657fc93d0873530a8a|b5d6478d5c1218944954dd7ed143c479|77b12d0065cf1182666f8e06fcf73b80', 'http://129.211.117.94:12080/mp3/6/e4bf84e7bd97e696afe5a5b3e5a3b0323031362d5265616c4f566973686e79612e6d7033.mp3T,242', '2', '2', '129.211.117.94', '9006', '120', '1', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('400', '2023-04-10 04:22:31', '0', '0', '6', '6bf8688ab79265657fc93d0873530a8a|b5d6478d5c1218944954dd7ed143c479|77b12d0065cf1182666f8e06fcf73b80', 'http://129.211.117.94:12080/mp3/6/e4bf84e7bd97e696afe5a5b3e5a3b0323031362d5265616c4f566973686e79612e6d7033.mp3T,242', '2', '2', '129.211.117.94', '9006', '120', '1', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('401', '2023-04-10 04:24:45', '0', '0', '6', '6bf8688ab79265657fc93d0873530a8a|b5d6478d5c1218944954dd7ed143c479|77b12d0065cf1182666f8e06fcf73b80', 'http://129.211.117.94:12080/mp3/6/e4bf84e7bd97e696afe5a5b3e5a3b0323031362d5265616c4f566973686e79612e6d7033.mp3T,242', '2', '2', '129.211.117.94', '9006', '120', '1', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('402', '2023-04-10 04:26:55', '0', '0', '6', '6bf8688ab79265657fc93d0873530a8a|b5d6478d5c1218944954dd7ed143c479|77b12d0065cf1182666f8e06fcf73b80', 'http://129.211.117.94:12080/mp3/6/536f756ce380826d616e2d426561744974e5a5b3e5a3b0e68a92e68385e789886d6ae6b0b8e59e82e4b88de69cbd2e6d7033.mp3T,237', '2', '9', '129.211.117.94', '9006', '1230', '6', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('403', '2023-04-10 04:27:42', '402', '0', '6', null, null, '2', '0', '129.211.117.94', '9006', '0', '0', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('404', '2023-04-10 04:27:55', '0', '0', '6', '6bf8688ab79265657fc93d0873530a8a|b5d6478d5c1218944954dd7ed143c479|77b12d0065cf1182666f8e06fcf73b80', 'http://129.211.117.94:12080/mp3/6/2de4bf84e7bd97e696af484950484f502e6d7033.mp3T,234|http://129.211.117.94:12080/mp3/6/e4bf84e7bd97e696afe5a5b3e5a3b0323031362d5265616c4f566973686e79612e6d7033.mp3T,242|http://129.211.117.94:12080/mp3/6/e7bea4e6989f2de5be88e5b8a6e6849fe79a84e4b880e9a696e6ad8ce4b8a8697469736d65e7bea4e6989fe4b8a82e6d7033.mp3T,188', '2', '9', '129.211.117.94', '9006', '4146', '6', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('405', '2023-04-10 04:30:39', '404', '0', '6', null, null, '2', '0', '129.211.117.94', '9006', '0', '0', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('406', '2023-04-10 05:02:21', '31', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('407', '2023-04-10 05:02:46', '31', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('408', '2023-04-11 02:50:09', '0', '0', '6', '6bf8688ab79265657fc93d0873530a8a|b5d6478d5c1218944954dd7ed143c479|77b12d0065cf1182666f8e06fcf73b80', 'http://129.211.117.94:12080/mp3/6/536f756ce380826d616e2d426561744974e5a5b3e5a3b0e68a92e68385e789886d6ae6b0b8e59e82e4b88de69cbd2e6d7033.mp3T,237', '2', '5', '129.211.117.94', '9006', '482', '2', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('409', '2023-04-11 02:50:21', '408', '0', '6', null, null, '2', '0', '129.211.117.94', '9006', '0', '0', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('410', '2023-04-11 02:51:28', '0', '0', '6', '6bf8688ab79265657fc93d0873530a8a|b5d6478d5c1218944954dd7ed143c479|77b12d0065cf1182666f8e06fcf73b80', 'http://129.211.117.94:12080/mp3/6/536f756ce380826d616e2d426561744974e5a5b3e5a3b0e68a92e68385e789886d6ae6b0b8e59e82e4b88de69cbd2e6d7033.mp3T,237', '2', '5', '129.211.117.94', '9006', '482', '2', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('411', '2023-04-11 02:51:48', '410', '0', '6', null, null, '2', '0', '129.211.117.94', '9006', '0', '0', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('412', '2023-04-12 14:08:40', '0', '0', '6', '6bf8688ab79265657fc93d0873530a8a|b5d6478d5c1218944954dd7ed143c479|77b12d0065cf1182666f8e06fcf73b80', 'http://129.211.117.94:12080/mp3/6/e7bea4e6989f2de5be88e5b8a6e6849fe79a84e4b880e9a696e6ad8ce4b8a8697469736d65e7bea4e6989fe4b8a82e6d7033.mp3T,188|http://129.211.117.94:12080/mp3/6/e5a89ce89282e4ba9a2de5a4aae5a5bde590ace4ba86e5898de5a58fe68ea7e4b880e7a792e788b1e4b88ae5a5bde590ace5a5b3e5a3b0e58d95e69bb2e5beaae78eaf476f6f644973476f6f642e6d7033.mp3T,260|http://129.211.117.94:12080/mp3/6/4b656b6550616c6d65722d466972737443727573682e6d7033.mp3T,235', '2', '6', '129.211.117.94', '9006', '4206', '7', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('413', '2023-04-12 14:09:01', '412', '0', '6', null, null, '2', '0', '129.211.117.94', '9006', '0', '0', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('414', '2023-04-17 11:20:11', '0', '0', '6', 'a53906f3e9c8f3015e0c51c837376d8f|39560783d24343d3ee53c77a3e6f92ea', 'http://129.211.117.94:12080/mp3/6/e7bea4e6989f2de5be88e5b8a6e6849fe79a84e4b880e9a696e6ad8ce4b8a8697469736d65e7bea4e6989fe4b8a82e6d7033.mp3T,188|http://129.211.117.94:12080/mp3/6/e5a89ce89282e4ba9a2de5a4aae5a5bde590ace4ba86e5898de5a58fe68ea7e4b880e7a792e788b1e4b88ae5a5bde590ace5a5b3e5a3b0e58d95e69bb2e5beaae78eaf476f6f644973476f6f642e6d7033.mp3T,260|http://129.211.117.94:12080/mp3/6/4b656b6550616c6d65722d466972737443727573682e6d7033.mp3T,235|http://129.211.117.94:12080/mp3/6/5377656574527573682d4de38082492e412e2e6d7033.mp3T,210|http://129.211.117.94:12080/mp3/6/4665727261732d527573682e6d7033.mp3T,261|http://129.211.117.94:12080/mp3/6/4a61636b5361766f72657474692d5275737369616e526f756c65747465e380822e6d7033.mp3T,278', '2', '2', '129.211.117.94', '9006', '1444', '1', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('415', '2023-04-17 11:20:19', '414', '0', '6', null, null, '2', '0', '129.211.117.94', '9006', '0', '0', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('416', '2023-04-17 13:21:49', '0', '0', '6', 'a53906f3e9c8f3015e0c51c837376d8f|39560783d24343d3ee53c77a3e6f92ea', 'http://129.211.117.94:12080/mp3/6/e7bea4e6989f2de5be88e5b8a6e6849fe79a84e4b880e9a696e6ad8ce4b8a8697469736d65e7bea4e6989fe4b8a82e6d7033.mp3T,188|http://129.211.117.94:12080/mp3/6/e5a89ce89282e4ba9a2de5a4aae5a5bde590ace4ba86e5898de5a58fe68ea7e4b880e7a792e788b1e4b88ae5a5bde590ace5a5b3e5a3b0e58d95e69bb2e5beaae78eaf476f6f644973476f6f642e6d7033.mp3T,260|http://129.211.117.94:12080/mp3/6/4b656b6550616c6d65722d466972737443727573682e6d7033.mp3T,235|http://129.211.117.94:12080/mp3/6/5377656574527573682d4de38082492e412e2e6d7033.mp3T,210|http://129.211.117.94:12080/mp3/6/4665727261732d527573682e6d7033.mp3T,261|http://129.211.117.94:12080/mp3/6/4a61636b5361766f72657474692d5275737369616e526f756c65747465e380822e6d7033.mp3T,278', '2', '2', '129.211.117.94', '9006', '1444', '1', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('417', '2023-04-17 13:23:08', '416', '0', '6', null, null, '2', '0', '129.211.117.94', '9006', '0', '0', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('418', '2023-05-14 20:29:03', '0', '0', '6', '6bf8688ab79265657fc93d0873530a8a|b5d6478d5c1218944954dd7ed143c479|77b12d0065cf1182666f8e06fcf73b80', 'http://129.211.117.94:12080/mp3/6/4b656b6550616c6d65722d466972737443727573682e6d7033.mp3T,235|http://129.211.117.94:12080/mp3/6/5377656574527573682d4de38082492e412e2e6d7033.mp3T,210', '2', '2', '129.211.117.94', '9006', '449', '2', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('419', '2023-06-13 01:58:07', '31', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('420', '2023-06-13 01:58:49', '31', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('421', '2023-06-13 09:15:54', '31', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('422', '2023-06-14 05:25:30', '31', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('423', '2023-06-14 05:25:52', '31', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('424', '2023-06-14 11:35:45', '0', '0', '6', 'a53906f3e9c8f3015e0c51c837376d8f|39560783d24343d3ee53c77a3e6f92ea', 'http://129.211.117.94:12080/mp3/6/e7bea4e6989f2de5be88e5b8a6e6849fe79a84e4b880e9a696e6ad8ce4b8a8697469736d65e7bea4e6989fe4b8a82e6d7033.mp3T,188|http://129.211.117.94:12080/mp3/6/e5a89ce89282e4ba9a2de5a4aae5a5bde590ace4ba86e5898de5a58fe68ea7e4b880e7a792e788b1e4b88ae5a5bde590ace5a5b3e5a3b0e58d95e69bb2e5beaae78eaf476f6f644973476f6f642e6d7033.mp3T,260', '2', '6', '129.211.117.94', '9006', '1380', '4', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('425', '2023-06-14 11:35:51', '424', '0', '6', null, null, '2', '0', '129.211.117.94', '9006', '0', '0', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('426', '2023-07-04 00:51:03', '0', '0', '6', 'a53906f3e9c8f3015e0c51c837376d81|e1530f1287cfbb086a8fa421ddcec600', 'http://xcx.ployq.com/f01/mp3/6/e7bea4e6989f2de5be88e5b8a6e6849fe79a84e4b880e9a696e6ad8ce4b8a8697469736d65e7bea4e6989fe4b8a82e6d7033.mp3T,188|http://xcx.ployq.com/f01/mp3/6/e5a89ce89282e4ba9a2de5a4aae5a5bde590ace4ba86e5898de5a58fe68ea7e4b880e7a792e788b1e4b88ae5a5bde590ace5a5b3e5a3b0e58d95e69bb2e5beaae78eaf476f6f644973476f6f642e6d7033.mp3T,260|http://xcx.ployq.com/f01/mp3/6/4b656b6550616c6d65722d466972737443727573682e6d7033.mp3T,235', '2', '1', '129.211.117.94', '9006', '686', '1', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('427', '2023-07-04 01:22:17', '0', '0', '6', 'e1530f1287cfbb086a8fa421ddcec600|74cf2a7daa0e07c3c488c9f8738d3a56|a53906f3e9c8f3015e0c51c837376d8f', 'http://xcx.ployq.com/f01/mp3/6/e7bea4e6989f2de5be88e5b8a6e6849fe79a84e4b880e9a696e6ad8ce4b8a8697469736d65e7bea4e6989fe4b8a82e6d7033.mp3T,188|http://xcx.ployq.com/f01/mp3/6/e5a89ce89282e4ba9a2de5a4aae5a5bde590ace4ba86e5898de5a58fe68ea7e4b880e7a792e788b1e4b88ae5a5bde590ace5a5b3e5a3b0e58d95e69bb2e5beaae78eaf476f6f644973476f6f642e6d7033.mp3T,260', '2', '1', '129.211.117.94', '9006', '450', '1', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('428', '2023-07-04 01:34:05', '0', '0', '6', 'e1530f1287cfbb086a8fa421ddcec600|74cf2a7daa0e07c3c488c9f8738d3a56|a53906f3e9c8f3015e0c51c837376d8f', 'http://xcx.ployq.com/f01/mp3/6/4b656b6550616c6d65722d466972737443727573682e6d7033.mp3T,235', '2', '1', '129.211.117.94', '9006', '236', '1', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('429', '2023-07-04 01:36:46', '0', '0', '6', 'e1530f1287cfbb086a8fa421ddcec600', 'http://xcx.ployq.com/f01/mp3/6/5377656574527573682d4de38082492e412e2e6d7033.mp3T,210', '2', '1', '129.211.117.94', '9006', '211', '1', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('430', '2023-07-04 01:41:32', '0', '0', '6', 'e1530f1287cfbb086a8fa421ddcec600', 'http://xcx.ployq.com/f01/mp3/6/4b656b6550616c6d65722d466972737443727573682e6d7033.mp3T,235', '2', '1', '129.211.117.94', '9006', '236', '1', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('431', '2023-07-04 01:46:00', '0', '0', '6', 'e1530f1287cfbb086a8fa421ddcec600|a53906f3e9c8f3015e0c51c837376d8f', 'http://xcx.ployq.com/f01/mp3/6/5377656574527573682d4de38082492e412e2e6d7033.mp3T,210', '2', '1', '129.211.117.94', '9006', '211', '1', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('432', '2023-07-04 01:53:20', '0', '0', '6', 'e1530f1287cfbb086a8fa421ddcec600|a53906f3e9c8f3015e0c51c837376d8f', 'http://xcx.ployq.com/f01/mp3/6/4b656b6550616c6d65722d466972737443727573682e6d7033.mp3T,235|http://xcx.ployq.com/f01/mp3/6/4665727261732d527573682e6d7033.mp3T,261', '2', '1', '129.211.117.94', '9006', '498', '1', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('433', '2023-07-04 01:58:29', '432', '0', '6', null, null, '2', '0', '129.211.117.94', '9006', '0', '0', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('434', '2023-07-04 01:59:41', '0', '0', '6', 'e1530f1287cfbb086a8fa421ddcec600|a53906f3e9c8f3015e0c51c837376d8f', 'http://xcx.ployq.com/f01/mp3/6/5275737369616e4769726ce6a091e5ad90e8af95e590ac2d2d536f6e675461737465e794a8e99fb3e4b990e580bee590ace5bdbce6ada42e6d7033.mp3T,279', '2', '1', '129.211.117.94', '9006', '280', '1', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('435', '2023-07-04 01:59:57', '434', '0', '6', null, null, '2', '0', '129.211.117.94', '9006', '0', '0', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('436', '2023-07-04 02:00:22', '0', '0', '6', 'e1530f1287cfbb086a8fa421ddcec600|a53906f3e9c8f3015e0c51c837376d8f', 'http://xcx.ployq.com/f01/mp3/6/5275737369616e4769726ce6a091e5ad90e8af95e590ac2d2d536f6e675461737465e794a8e99fb3e4b990e580bee590ace5bdbce6ada42e6d7033.mp3T,279', '2', '1', '129.211.117.94', '9006', '280', '1', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('437', '2023-07-08 20:28:53', '37', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('438', '2023-07-08 20:28:59', '37', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('439', '2023-07-08 21:49:38', '34', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('440', '2023-07-09 03:25:46', '32', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('441', '2023-07-09 03:25:50', '33', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('442', '2023-07-09 16:14:43', '40', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('443', '2023-07-09 16:14:47', '40', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('444', '2023-07-11 22:14:40', '0', '0', '6', 'e1530f1287cfbb086a8fa421ddcec600|a53906f3e9c8f3015e0c51c837376d8f', 'http://xcx.ployq.com/f01/mp3/6/4665727261732d527573682e6d7033.mp3T,261', '2', '1', '129.211.117.94', '9006', '262', '1', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('445', '2023-07-11 22:14:46', '444', '0', '6', null, null, '2', '0', '129.211.117.94', '9006', '0', '0', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('446', '2023-07-11 22:15:09', '34', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('447', '2023-09-28 22:01:41', '0', '0', '6', '8e6b85a54c36d87080ca19d7495b874e', 'http://192.168.0.115/mp3/6/e7bea4e6989f2de5be88e5b8a6e6849fe79a84e4b880e9a696e6ad8ce4b8a8697469736d65e7bea4e6989fe4b8a82e6d7033.mp3T,188', '2', '1', '192.168.0.115', '9006', '189', '1', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('448', '2023-09-28 22:02:03', '447', '0', '6', null, null, '2', '0', '192.168.0.115', '9006', '0', '0', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('449', '2023-09-28 22:04:04', '0', '0', '6', '8e6b85a54c36d87080ca19d7495b874e', 'http://192.168.0.115:12080/mp3/6/e998bfe890a8e5beb7e998bfe890a8e5beb7313233.mp3T,241', '2', '1', '192.168.0.115', '9006', '242', '1', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('450', '2023-09-28 22:04:43', '449', '0', '6', null, null, '2', '0', '192.168.0.115', '9006', '0', '0', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('451', '2023-09-28 22:06:22', '0', '0', '6', '8e6b85a54c36d87080ca19d7495b874e', 'http://192.168.0.115:12080/mp3/6/427269616e527573736f2d4c69676874696e677468657761792e6d7033.mp3T,200', '2', '1', '192.168.0.115', '9006', '201', '1', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('452', '2023-09-28 22:07:08', '451', '0', '6', null, null, '2', '0', '192.168.0.115', '9006', '0', '0', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('453', '2023-09-29 01:43:05', '0', '0', '13', '8e6b85a54c36d87080ca19d7495b874e', 'http://192.168.0.115:12080/mp3/13/31312e6d7033.mp3T,189', '2', '1', '192.168.0.115', '9006', '190', '1', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('454', '2023-09-29 02:13:17', '0', '0', '13', '8e6b85a54c36d87080ca19d7495b874e', 'http://192.168.0.199:12080/mp3/13/31312e6d7033.mp3T,189', '2', '1', '192.168.0.199', '9006', '190', '1', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('455', '2023-09-29 02:13:22', '454', '0', '13', null, null, '2', '0', '192.168.0.199', '9006', '0', '0', 'temp_task_start');

-- ----------------------------
-- Table structure for `taskseed`
-- ----------------------------
DROP TABLE IF EXISTS `taskseed`;
CREATE TABLE `taskseed` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `taskid` int(11) NOT NULL,
  `devseedid` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=207 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of taskseed
-- ----------------------------
INSERT INTO `taskseed` VALUES ('48', '4', '17');
INSERT INTO `taskseed` VALUES ('49', '4', '18');
INSERT INTO `taskseed` VALUES ('50', '4', '19');
INSERT INTO `taskseed` VALUES ('51', '5', '18');
INSERT INTO `taskseed` VALUES ('52', '5', '19');
INSERT INTO `taskseed` VALUES ('53', '6', '18');
INSERT INTO `taskseed` VALUES ('54', '6', '19');
INSERT INTO `taskseed` VALUES ('55', '7', '17');
INSERT INTO `taskseed` VALUES ('56', '7', '18');
INSERT INTO `taskseed` VALUES ('57', '7', '19');
INSERT INTO `taskseed` VALUES ('58', '7', '25');
INSERT INTO `taskseed` VALUES ('59', '8', '17');
INSERT INTO `taskseed` VALUES ('60', '8', '18');
INSERT INTO `taskseed` VALUES ('61', '8', '19');
INSERT INTO `taskseed` VALUES ('62', '9', '17');
INSERT INTO `taskseed` VALUES ('63', '9', '18');
INSERT INTO `taskseed` VALUES ('64', '9', '19');
INSERT INTO `taskseed` VALUES ('175', '32', '27');
INSERT INTO `taskseed` VALUES ('176', '32', '19');
INSERT INTO `taskseed` VALUES ('177', '32', '25');
INSERT INTO `taskseed` VALUES ('178', '33', '19');
INSERT INTO `taskseed` VALUES ('179', '33', '26');
INSERT INTO `taskseed` VALUES ('180', '33', '28');
INSERT INTO `taskseed` VALUES ('181', '34', '19');
INSERT INTO `taskseed` VALUES ('182', '34', '25');
INSERT INTO `taskseed` VALUES ('183', '34', '26');
INSERT INTO `taskseed` VALUES ('184', '35', '28');
INSERT INTO `taskseed` VALUES ('185', '36', '26');
INSERT INTO `taskseed` VALUES ('186', '36', '28');
INSERT INTO `taskseed` VALUES ('187', '37', '18');
INSERT INTO `taskseed` VALUES ('188', '37', '19');
INSERT INTO `taskseed` VALUES ('189', '37', '25');
INSERT INTO `taskseed` VALUES ('190', '37', '26');
INSERT INTO `taskseed` VALUES ('191', '37', '27');
INSERT INTO `taskseed` VALUES ('192', '37', '28');
INSERT INTO `taskseed` VALUES ('193', '37', '30');
INSERT INTO `taskseed` VALUES ('194', '37', '31');
INSERT INTO `taskseed` VALUES ('195', '37', '70');
INSERT INTO `taskseed` VALUES ('196', '37', '71');
INSERT INTO `taskseed` VALUES ('197', '38', '19');
INSERT INTO `taskseed` VALUES ('198', '38', '26');
INSERT INTO `taskseed` VALUES ('199', '39', '19');
INSERT INTO `taskseed` VALUES ('200', '39', '27');
INSERT INTO `taskseed` VALUES ('203', '40', '26');
INSERT INTO `taskseed` VALUES ('204', '40', '19');
INSERT INTO `taskseed` VALUES ('205', '40', '70');
INSERT INTO `taskseed` VALUES ('206', '40', '71');

-- ----------------------------
-- Table structure for `userfile`
-- ----------------------------
DROP TABLE IF EXISTS `userfile`;
CREATE TABLE `userfile` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userid` int(11) NOT NULL,
  `filename` varchar(200) NOT NULL,
  `url` varchar(300) NOT NULL,
  `len` int(11) NOT NULL DEFAULT '300',
  `crl` varchar(300) NOT NULL,
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `mark` int(11) NOT NULL DEFAULT '0',
  `markid` int(11) NOT NULL DEFAULT '-1',
  `ziuse` int(11) NOT NULL DEFAULT '0',
  `sizeByte` int(11) NOT NULL DEFAULT '1024000',
  `enable` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `filename` (`filename`,`userid`)
) ENGINE=InnoDB AUTO_INCREMENT=176 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of userfile
-- ----------------------------
INSERT INTO `userfile` VALUES ('34', '7', 'LSDkv4TnvZfmlq9ISVAgSE9QLm1wMw==', 'mp3/6/2d20e4bf84e7bd97e696af48495020484f502e6d7033.mp3T', '234', 'C:/Users/Administrator/Desktop/AdoreMixV6.2/AdoreMixV6.2/etc/docroot/mp3/6/2d20e4bf84e7bd97e696af48495020484f502e6d7033.mp3T', '2023-03-08 03:20:49', '0', '-1', '1', '3724851', '1');
INSERT INTO `userfile` VALUES ('174', '13', 'MTEubXAz', 'mp3/13/31312e6d7033.mp3T', '189', 'C:/Etl/AdoreMixV6.2/AdoreMixV6.2/etc/docroot/mp3/13/31312e6d7033.mp3T', '2023-09-29 01:42:56', '0', '-1', '1', '3002243', '1');
INSERT INTO `userfile` VALUES ('175', '6', 'MTEubXAz', 'mp3/6/31312e6d7033.mp3T', '189', 'C:/Etl/AdoreMixV6.2/AdoreMixV6.2/etc/docroot/mp3/6/31312e6d7033.mp3T', '2023-10-09 05:03:37', '0', '-1', '1', '3002243', '1');

-- ----------------------------
-- Table structure for `warning`
-- ----------------------------
DROP TABLE IF EXISTS `warning`;
CREATE TABLE `warning` (
  `id` int(11) NOT NULL,
  `userid` int(11) NOT NULL,
  `seed` varchar(100) NOT NULL,
  `cmd1` varchar(1000) DEFAULT 'null',
  `cmd2` varchar(1000) DEFAULT 'null',
  `ip` varchar(45) NOT NULL,
  `portwr` int(11) NOT NULL,
  `portct` int(11) NOT NULL,
  `enable` int(11) NOT NULL DEFAULT '0',
  `shenhe` int(11) NOT NULL DEFAULT '0',
  `play_nodeid` int(11) NOT NULL DEFAULT '0',
  `hostname` varchar(100) DEFAULT 'gsh.ployq.com',
  `count` int(11) NOT NULL DEFAULT '0',
  `update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of warning
-- ----------------------------

-- ----------------------------
-- Table structure for `warningplant`
-- ----------------------------
DROP TABLE IF EXISTS `warningplant`;
CREATE TABLE `warningplant` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `snids` varchar(20000) NOT NULL DEFAULT 'none',
  `url` varchar(1000) NOT NULL DEFAULT 'none',
  `name` varchar(200) NOT NULL DEFAULT 'none',
  `userid` int(11) NOT NULL DEFAULT '1',
  `status` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of warningplant
-- ----------------------------
INSERT INTO `warningplant` VALUES ('10', '6bf8688ab79265657fc93d0873530a8a|b5d6478d5c1218944954dd7ed143c479|77b12d0065cf1182666f8e06fcf73b80', 'http://129.211.117.94:12080/mp3/6/e5a89ce89282e4ba9a2de5a4aae5a5bde590ace4ba86e5898de5a58fe68ea7e4b880e7a792e788b1e4b88ae5a5bde590ace5a5b3e5a3b0e58d95e69bb2e5beaae78eaf476f6f644973476f6f642e6d7033.mp3T', 'mini分组播放雅典', '6', '0');

-- ----------------------------
-- Table structure for `warregister`
-- ----------------------------
DROP TABLE IF EXISTS `warregister`;
CREATE TABLE `warregister` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sn` varchar(32) NOT NULL DEFAULT 'sn',
  `kind` int(11) NOT NULL DEFAULT '0',
  `url` varchar(1000) NOT NULL DEFAULT 'url',
  `devname` varchar(500) NOT NULL DEFAULT 'Device_name',
  `filename` varchar(500) NOT NULL DEFAULT 'File_Name',
  `userid` int(11) NOT NULL DEFAULT '0',
  `fb` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of warregister
-- ----------------------------
INSERT INTO `warregister` VALUES ('22', 'a53906f3e9c8f3015e0c51c837376d8f', '0', 'http://129.211.117.94:12080/mp3/6/536f756ce380826d616e2d426561744974e5a5b3e5a3b0e68a92e68385e789886d6ae6b0b8e59e82e4b88de69cbd2e6d7033.mp3T', '啊啊啊', 'Soul。man-BeatIt女声抒情版mj永垂不朽.mp3', '6', '1');

-- ----------------------------
-- Table structure for `xieyi_mod`
-- ----------------------------
DROP TABLE IF EXISTS `xieyi_mod`;
CREATE TABLE `xieyi_mod` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `xieyi` longtext NOT NULL,
  `kind` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of xieyi_mod
-- ----------------------------
INSERT INTO `xieyi_mod` VALUES ('1', '5pS/562W55Sf5pWI5pe26Ze0Cgroh6rlupTnlKjlj5HluIPkuYvml6XvvIgyMDIzLTA277yJ6LW35LiA55u05pyJ5pWICgrku6XkuIvpmpDnp4HmnaHmrL7mmK/lsI/mkq3pvKDnvZHnu5zlub/mkq1BUFBhcHDnmoTlvIDlj5HogIXml6DplKHlsI/mkq3pvKDnvZHnu5znp5HmioDmnInpmZDlhazlj7jvvIjku6XkuIvnp7Ai5bCP5pKt6bygIuOAgSLmiJHku6wi77yJIOWvueeUqOaIt+makOengeS/neaKpOeahOiuuOivuu+8jOivt+aCqOWKoeW/heS7lOe7humYheivu+acrOadoeasvu+8jOS7peS6huino+aIkeS7rOWFs+S6jueuoeeQhuaCqOS4quS6uuS/oeaBr+eahOaDheWGteOAguacrOadoeasvueahOWFqOmDqOWGheWuueWxnuS6jiLmt7HlnLPluILmhYjoiqDlgaXlurfmnInpmZDlhazlj7jnlKjmiLfljY/orq4i55qE6YeN6KaB6YOo5YiG5LmL5LiA44CCCgrmiJHku6zoh7Tlipvkuo7nu7TmiqTmgqjlr7nmiJHku6znmoTkv6Hku7vvvIzmgarlrojku6XkuIvljp/liJnvvIzkv53miqTmgqjnmoTkuKrkurrkv6Hmga/vvJrmnYPotKPkuIDoh7Tljp/liJnjgIHnm67nmoTmmI7noa7ljp/liJnjgIHpgInmi6nlkIzmhI/ljp/liJnjgIHmnIDlsJHlpJ/nlKjljp/liJnjgIHnoa7kv53lronlhajljp/liJnjgIHkuLvkvZPlj4LkuI7ljp/liJnjgIHlhazlvIDpgI/mmI7ljp/liJnnrYnjgILlkIzml7bvvIzmiJHku6zmib/or7rvvIzmiJHku6zlsIbmjInkuJrnlYzmiJDnhp/nmoTlronlhajmoIflh4bvvIzph4flj5bnm7jlupTnmoTlronlhajkv53miqTmjqrmlr3mnaXkv53miqTmgqjnmoTkuKrkurrkv6Hmga/jgIIKCuivt+WcqOS9v+eUqOaIkeS7rOeahOS6p+WTgSjmiJbmnI3liqEp5YmN77yM5LuU57uG6ZiF6K+75bm25LqG6Kej5pys44CK6ZqQ56eB5Y2P6K6u44CL44CCCgrmnKzmnaHmrL7ljIXmi6zku6XkuIvlhoXlrrnvvJoKCuS4gOOAgeaIkeS7rOWmguS9leaUtumbhuWSjOS9v+eUqOaCqOeahOS4quS6uuS/oeaBr+S7peWPiuiwg+eUqOadg+mZkOWjsOaYjgoK5Liq5Lq65L+h5oGv5piv5oyH5Lul55S15a2Q5oiW6ICF5YW25LuW5pa55byP6K6w5b2V55qE6IO95aSf5Y2V54us5oiW6ICF5LiO5YW25LuW5L+h5oGv57uT5ZCI6K+G5Yir54m55a6a6Ieq54S25Lq66Lqr5Lu95oiW6ICF5Y+N5pig54m55a6a6Ieq54S25Lq65rS75Yqo5oOF5Ya155qE5ZCE56eN5L+h5oGv44CC5oiR5Lus5LuF5Lya5Ye65LqO5pys5p2h5qy+5omA6L+w55qE5Lul5LiL55uu55qE77yM5pS26ZuG5ZKM5L2/55So5oKo55qE5Liq5Lq65L+h5oGv77yaCgrmiJHku6znmoTkuqflk4Hln7rkuo5EQ2xvdWQgdW5pLWFwcCg1KyBBcHAvV2FwMkFwcCnlvIDlj5HvvIzlupTnlKjov5DooYzmnJ/pl7TpnIDopoHmlLbpm4bmgqjnmoTorr7lpIfllK/kuIDor4bliKvnoIHvvIhJTUVJL2FuZHJvaWQgSUQvREVWSUNFX0lEL0lERkHjgIFTSU0g5Y2hIElNU0kg5L+h5oGv44CBT0FJRO+8ieS7peaPkOS+m+e7n+iuoeWIhuaekOacjeWKoe+8jOW5tumAmui/h+W6lOeUqOWQr+WKqOaVsOaNruWPiuW8guW4uOmUmeivr+aXpeW/l+WIhuaekOaUuei/m+aAp+iDveWSjOeUqOaIt+S9k+mqjO+8jOS4uueUqOaIt+aPkOS+m+abtOWlveeahOacjeWKoeOAguivpuaDheWGheWuueivt+iuv+mXruOAikRDbG91ZOeUqOaIt+acjeWKoeadoeasvuOAizpodHRwczovL2Fzay5kY2xvdWQubmV0LmNuL3Byb3RvY29sLmh0bWwKCijkuIAp5Li65oKo5o+Q5L6b6L2v5Lu25L2/55So5pyN5YqhCgrms6jlhozmiJDkuLrnlKjmiLcKCuS4uuWujOaIkOazqOWGjOi0puWPt++8jOaCqOmcgOaPkOS+m+S7peS4i+S/oeaBr++8muaCqOeahOaJi+acuuWPt+aIluiAheW+ruS/oeaOiOadg+S/oeaBr+S4iui/sOS/oeaBr++8jOWwhuWcqOaCqOS9v+eUqOacrOacjeWKoeacn+mXtOaMgee7reaOiOadg+aIkeS7rOS9v+eUqOOAgmFwcOaYr+WFjei0ueW8gOaUvizkuI3mlLblj5bku7vkvZXotLnnlKjjgIIKCuS4iui/sOS/oeaBr+WwhuWtmOWCqOS6juS4reWNjuS6uuawkeWFseWSjOWbveWig+WGheOAguWmgumcgOi3qOWig+S8oOi+k++8jOaIkeS7rOWwhuS8muWNleeLrOW+geW+l+aCqOeahOaOiOadg+WQjOaEj+OAggoKKOS6jCnojrflj5borr7lpIfor4bliKvnoIHnmoTmnYPpmZDvvJoKCuS9v+eUqOWcuuaZr++8muiuvuWkh+ivhuWIq+eggeS9nOS4ukFQUOaOqOmAgemAmuefpeeahOagh+ivhuS9v+eUqO+8jOaIkeS7rOWSjOaIkeS7rOaJgOS9v+eUqOeahOWPi+ebn+aOqOmAgeacjeWKoemDvemcgOimgeaCqOaOiOadg+iOt+WPluivhuWIq+eggSzojrflj5bliLDorr7lpIfor4bliKvnoIHlkI7kvJrkuIrkvKDoh7PmnI3liqHlmajkv53lrZjvvIzlj4vnm5/mjqjpgIHkuZ/kvJrojrflj5blubbkv53lrZjorr7lpIfor4bliKvnoIHvvIznu4/nlLHkuKTmlrnkv53lrZjnmoTorr7lpIfor4bliKvnoIHvvIzlpoLliJ3mnI3liqHlmajlj5HpgIHnmoTmjqjpgIHmtojmga/nu4/ov4flj4vnm5/lj5HpgIHliLDmjIflrprnlKjmiLflrqLmiLfnq6/jgILmiJHku6zkvJrojrflj5bvvIjorr7lpIfluo/liJflj7cvSU1FSS9NYWMvQW5kcm9pZF9JRC9JREZBL09QRU5VRElEL0dVSUQvU0lNIOWNoSBJTVNJIC/lnLDnkIbkvY3nva7vvInlm6DkuLrkuIDkupvnrKzkuInmlrlTREvlj6/og73kvJrmlLbpm4bov5nkupvkv6Hmga/vvIzor6bmg4XnnIvkuIvmlrnnrKzkuInmlrlTREvpmpDnp4Hor7TmmI7jgIIKCijkuIkp5pys5Zyw5pWw5o2u55qE6K+75Y+W5ZKM5YaZ5YWl5p2D6ZmQ77yaCgrkvb/nlKjlnLrmma/vvJrkuLrpmLLmraLnlKjmiLfmr4/mrKHmiZPlvIBBUFDpg73ph43mlrDnmbvlvZXvvIznlKjmiLfnmoTnmbvlvZXkv6Hmga/lkoznmbvlvZXnirbmgIHlsIbkvJrlhpnlhaXliLDmnKzlnLDmlbDmja7vvIzkuIvmrKHmiZPlvIBBUFDml7bor7vlj5bmnKzlnLDmlbDmja7nmoTnmbvlvZXkv6Hmga/oh6rliqjnmbvlvZXvvIzlvZPnlKjmiLflnKjotKblj7fnrqHnkIbpobXpnaLms6jplIDnmbvlvZXmiJbogIXljbjovb1BUFDlkI7nm7jlhbPmlbDmja7kvJrooqvliKDpmaTjgIIKCueUqOaIt+iuvue9ruWSjOabtOaUueWktOWDj+aXtuS8muWwhuebuOWFs+WbvueJh+aWh+S7tuWGmeWFpeacrOWcsOaVsOaNru+8jOWxleekuueUqOaIt+WktOWDj+aXtuS8muivu+WPluWbvueJh+aWh+S7tuOAguS7peS4iuaVsOaNruWSjOaWh+S7tuS5n+S8muS4iuS8oOiHs+acjeWKoeWZqOS/neWtmOOAggoKKOWbmynojrflj5bnm7jlhozkv6Hmga/mnYPpmZDvvJoKCuS9v+eUqOWcuuaZr++8mueUqOaIt+iuvue9ruWktOWDj+WSjOabtOaNouWktOWDj+aXtu+8jOivu+WPluebuOWGjOadg+mZkOiOt+WPluWbvueJh+aWh+S7tuOAgueEtuWQjuS4iuS8oOiHs+acjeWKoeWZqOWSjOS/neWtmOWIsOacrOWcsOaVsOaNruWBmue8k+WtmOS9v+eUqOOAggoKKOS6lCnojrflj5ZBQ1RJT05fQk9PVF9DT01QTEVURUTlub/mkq3oh6rlkK/liqjmnYPpmZAsCgrmiJHku6zmnInorr7nva7orq3nu4Pmj5DphpLlip/og70s5aaC5p6c5oKo6K6+572u5LqG6L+Z5Liq5o+Q6YaSLOaIkeS7rOWwhuS7pUFDVElPTl9CT09UX0NPTVBMRVRFROW5v+aSreeahOaWueW8j+W8gOWQr+S4gOS4quaPkOekuuW5tuWQr+WKqGFwcCzkuI3orr7nva7mj5DnpLrlsIbkuI3kvJroh6rlkK/liqhhcHAKCijlha0p5Li75Yqo5o+Q5Lqk5LiK5Lyg55qE5L+h5oGvLOWGhemDqOaVsOaNruWIhuaekOWSjOeglOeptgoK5oKo5Zyo5pysQVBQ5YaF55qE5L2/55So6K6w5b2VLOaCqOS4u+WKqOS4iuS8oOeahOS4quS6uuS/oeaBryznu4/nlLHmgqjlkIzmhI/miJHku6zojrflj5bnmoTkv6Hmga8s5oiR5Lus5bCG55So5p2l5YGa5YaF6YOo5pWw5o2u5rGH5oC757uf6K6h5ZKM5YiG5p6Q44CC5oiR5Lus55qE6YOo5YiG5pyN5YqhKOS4quS6uui1hOaWmSnpnIDopoHmgqjmj5DkuqTkuIrkvKDnm7jlhbPkv6Hmga8s5aaC5p6c5oKo5L2/55So5LqG5q2k57G75pyN5Yqh5bm25LiU5LiK5Lyg55u45YWz5L+h5oGv6KeG5Li65oKo5Li75Yqo5o+Q5L6b57uZ5oiR5Lus5L+h5oGvLOmAmui/h+acrEFQUOS4u+WKqOaPkOS6pOeahOS4quS6uuS/oeaBr++8jOWNs+ihqOekuuaCqOWQjOaEj+acrOmakOengeWNj+iuruW5tuaYjuehruWQjOaEj+aMieeFp+acrOmakOengeWNj+iuruWvueaCqOeahOS4quS6uuS/oeaBr+i/m+ihjOWkhOeQhuOAggoK5b2T5oiR5Lus6KaB5bCG5L+h5oGv55So5LqO5pys5p2h5qy+5pyq6L295piO55qE5YW25a6D55So6YCU5pe277yM5Lya5LqL5YWI5b6B5rGC5oKo55qE5ZCM5oSP44CCCgrlvZPmiJHku6zopoHlsIbln7rkuo7nibnlrprnm67nmoTmlLbpm4bogIzmnaXnmoTkv6Hmga/nlKjkuo7lhbbku5bnm67nmoTml7bvvIzkvJrkuovlhYjlvoHmsYLmgqjnmoTlkIzmhI/jgIIKCuS7juWcqOaCqOmCo+mHjOaUtumbhueahOS4quS6uuS/oeaBryLmgKfliKss6Lqr6auYLOS9k+mHjSLlj6rlgZrkuIDkuKrorrDlvZUs5Y+v5Lul6ZqP5pe25L+u5pS55oiW6ICF5LiN5aGrLgoKKOS4gynmlLbpm4ZJTUVJ44CBSU1TSeOAgeiuvuWkhyBNQUPjgIHlnLDlnYDjgIHlupTnlKjlronoo4XliJfooagKCuWFs+S6jklNRUnjgIFJTVNJ44CB6K6+5aSHIE1BQ++8jOW6lOeUqOWuieijheWIl+ihqO+8jOaYr+eUqOS6juesrOS4ieaWuVNES+eahOS9v+eUqO+8jOivpuaDheWPr+afpeeci+S4i+aWueesrCjlhasp5p2h4oCc56ys5LiJ5pa5U0RL57G75pyN5Yqh5ZWG4oCd5LuL57uNCgrlvZPmiJHku6zopoHlsIbmlLbpm4bogIzmnaXnmoTkv6Hmga/nlKjkuo7lhbbku5bnm67nmoTml7bvvIzkvJrkuovlhYjlvoHmsYLmgqjnmoTlkIzmhI/jgIIKCijlhasp56ys5LiJ5pa5U0RL57G75pyN5Yqh5ZWGCgrkuLrkv53or4HlkJHmgqjmj5DkvpvmnKzpmpDnp4HmlL/nrZbnm67nmoTmiYDov7DnmoTmnI3liqHvvIzmiJHku6zlj6/og73kvJrlkJHnrKzkuInmlrnmnI3liqHmj5DkvpvllYbkuI7kuJrliqHlkIjkvZzkvJnkvLTnrYnnrKzkuInmlrnlhbHkuqvlv4XopoHnmoTkuKrkurrkv6Hmga/jgIIKCuaIkeS7rOWwhuS8muaUtumbhiBJTUVJ44CBSU1TSeOAgeiuvuWkhyBNQUPjgIHlnLDlnYDjgIHlupTnlKjlronoo4XliJfooagg562J5L+h5oGv77yM6YO95piv55So5LqO5LiL6Z2i5bCG5LuL57uN55qE56ys5LiJ5pa5U0RL5Yqf6IO977yM5b2T5oiR5Lus6KaB5bCG5pS26ZuG6ICM5p2l55qE5L+h5oGv55So5LqO5YW25LuW55uu55qE5pe277yM5Lya5LqL5YWI5b6B5rGC5oKo55qE5ZCM5oSP44CCCgrov5nljIXmi6zmiJHku6znmoTlrqLmnI3mnI3liqEs5pSv5LuY5pyN5YqhLOW5v+WRiuWSjOiQpemUgOacjeWKoSznrKzkuInmlrnnmbvlvZXmnI3liqEs5bqU55So5Yqg5Zu65pyN5YqhCgrmgqjlkIzmhI/lsIbnlLHlhbbnm7TmjqXlpITnkIbmgqjnmoTkv6Hmga8s55uu5YmN5oiR5Lus55qE5Lqn5ZOB56eN5YyF5ZCr55qE56ys5LiJ5pa5U0RL5Li76KaB5pyJOgoK6L+Z5LqbU0RL5Y+v6IO95Lya5pS26ZuG5oKo55qE56Gs5Lu25Z6L5Y+344CB5pON5L2c57O757uf54mI5pys5Y+344CBIElQIOWcsOWdgOOAgSBXTEFOIOaOpeWFpeeCueOAgei9r+S7tueJiOacrOWPt+OAgee9kee7nOaOpeWFpeaWueW8j+OAgeexu+Wei+OAgeeKtuaAgeOAgee9kee7nOi0qOmHj+aVsOaNruOAgeaTjeS9nOOAgeS9v+acjeWKoeaXpeW/l+OAgU1BQ+WcsOWdgOOAgei9r+S7tuWuieijheWIl+ihqOetiQoK56m/5bGx55SyR3JvTW9yZVNESyhVQ+WVhOacqOm4n1NESyk65a6D5Y+v6IO95Lya5pS26ZuG5oKo55qE56Gs5Lu25Z6L5Y+344CB5pON5L2c57O757uf54mI5pys5Y+344CBIElQIOWcsOWdgOOAgSBXTEFOIOaOpeWFpeeCueOAgei9r+S7tueJiOacrOWPt+OAgee9kee7nOaOpeWFpeaWueW8j+OAgeexu+Wei+OAgeeKtuaAgeOAgee9kee7nOi0qOmHj+aVsOaNruOAgeaTjeS9nOOAgeS9v+acjeWKoeaXpeW/l+OAgU1BQ+WcsOWdgOOAgei9r+S7tuWuieijheWIl+ihqOetiSzkvKDmhJ/lmajkv6Hmga/vvIjpmYDonrrku6rkvKDmhJ/lmajjgIHliqDpgJ/kvKDmhJ/lmajjgIHph43lipvkvKDmhJ/lmajvvInvvIznlKjmnaXlkJHmgqjmj5Dkvpvnm7jlhbPmgKfmm7TlvLrnmoTmjqjpgIHlhoXlrrks5L2g5Lmf5Y+v5Lul55m76ZmG56m/5bGx55Sy5bmz5Y+w5p+l55yL5a6MLOaVtOmakOengeaUv+etluS6huino+abtOWkmuS/oeaBrzpodHRwOi8vcGFydG5lci50b3V0aWFPLmNvbS9wcml2YWN5LAoKY29tLmdldHVpKOS4quaOqDvkuKrmlbDlupTnlKjnu5/orqE75Liq5YOPKTrkuKrmlbDlupTnlKjnu5/orqHmnI3liqHlj6/ku6XluK7liqnmgqjkuobop6PmgqjnmoTnlKjmiLflpoLkvZXkvb/nlKjmgqjnmoTlupTnlKjvvIzlubbluK7liqnmgqjliIbmnpDlnKjkuI3lkIznu7TluqbkuIrnmoTooajnjrDvvIzljIXmi6zkvYbkuI3pmZDkuo7mnLrlnovjgIHlk4HniYzjgIHlubPlj7DjgIHmuKDpgZPnrYnjgILpgJrov4fkuKrmlbDlupTnlKjnu5/orqFTREvmlLbpm4blubblrZjlgqjnmoTkv6Hmga/ljIXmi6zkvYbkuI3pmZDkuo7vvJoKCjEpIOiuvuWkh+S/oeaBr++8muiuvuWkh+ivhuWIq+eggeWwhuiiq+eUqOS6jueUn+aIkOWUr+S4gOeahOe7n+iuoeagh+ivhklE77yM5Y2zR0NJRO+8jOS+m+ezu+e7n+WGhemDqOS9v+eUqO+8jOeUqOWBmuaVsOaNruWOu+mHjeWSjOS4jeWQjOe7tOW6puaVsOmHj+e7n+iuoe+8m+iuvuWkh+W5s+WPsOOAgeiuvuWkh+WOguWVhuOAgeiuvuWkh+WTgeeJjOetieiuvuWkh+ebuOWFs+S/oeaBr+WwhueUqOS6juWkmue7tOW6pueahOe7n+iuoeiuoeeul+OAggoKMikg5bqU55So55u45YWz5L+h5oGv77ya5YyF5ous5L2G5LiN6ZmQ5LqO5bqU55So5YiX6KGo44CB5rig6YGT44CB5pe26Ze05oiz44CB6aG16Z2i5ZSv5LiA5qCH6K+G44CB55So5oi35omT54K55LqL5Lu244CC5oiR5Lus5L2/55So5LiK6L+w5L+h5oGv5p2l5o+Q5L6b5aSa57u055qE57uf6K6h5YiG5p6Q77yM5a6e546w5YyF5ous5Y+v6KeG5YyW5Z+L54K544CB6KGM5Lia5YiG5p6Q5Zyo5YaF55qE57uf6K6h5Yqf6IO944CCCgozKSDnvZHnu5zkv6Hmga/vvJrnlKjmnaXlkozkuKrmlbDmnI3liqHlmajlu7rnq4vov57mjqUKCumAmui/h+S4quWDj+eUqOaIt+eUu+WDj1NES+aUtumbhuW5tuWtmOWCqOeahOS/oeaBr+WMheaLrOS9huS4jemZkOS6ju+8mgoK6K6+5aSH5L+h5oGv77ya6K6+5aSH6K+G5Yir56CB5bCG6KKr55So5LqO55Sf5oiQ5ZSv5LiA55qE55So5oi35qCH6K+G77yM5Y2zR0lVSUTjgILorr7lpIflubPlj7DjgIHorr7lpIfljoLllYbjgIHorr7lpIflk4HniYznrYnorr7lpIfnm7jlhbPkv6Hmga/mnInliqnkuo7miJHku6znlJ/miJDmm7TkuLDlr4znmoTnlLvlg4/vvIzlpoLorr7lpIflk4HniYzjgIHorr7lpIfniYjmnKznrYnnlLvlg4/moIfnrb7jgIIKCuiFvuiur+S8mOmHj+axh1NESzrku5blsIbkvJrojrflj5bnspfnlaXkvY3nva7kv6Hmga/vvIzorr7lpIfkv6Hmga/vvIjlpoLorr7lpIfliLbpgKDllYbjgIHorr7lpIflnovlj7fjgIHmk43kvZzns7vnu5/niYjmnKznrYnvvInjgIHorr7lpIfmoIfor4bnrKbvvIjlpoJJTUVJ44CBQW5kcm9pZElE44CBT0FJROOAgUlERkHnrYnvvInjgIHlupTnlKjkv6Hmga/vvIjlrr/kuLvlupTnlKjnmoTljIXlkI3jgIHniYjmnKzlj7fvvInjgIHlub/lkYrmlbDmja7vvIjlpoLmm53lhYnjgIHngrnlh7vmlbDmja7nrYnvvInjgILnlKjkuo7lub/lkYrmipXmlL7jgIHlub/lkYrlvZLlm6DjgIHlub/lkYrlj43kvZzlvIrjgIIgLOmakOengeaUv+etlumTvuaOpTpodHRwczovL3F6cy5nZHRpbWcuY29tL3VuaW9uL3Jlcy91bmlvbl9jZG4vcGFnZS9kZXZfcnVsZXMveWxoX3Nka19wcml2YWN5X3N0YXRlbWVudC5odG1sIAoK55m+5bqm55m+6Z2S6Jek5bm/5ZGKU0RLOuivpVNES+S8muaUtumbhuiuvuWkh+S/oeaBr++8iOehrOS7tuWei+WPt++8jOaTjeS9nOezu+e7n+eJiOacrOWPiuezu+e7n+aDheWGte+8jOiuvuWkh+mFjee9ru+8jOWbvemZheenu+WKqOiuvuWkh+i6q+S7veeggUlNRUnjgIHlm73pmYXnp7vliqjnlKjmiLfor4bliKvnoIFJTVNJ44CB5bm/5ZGK5qCH6K+G56ymSURGQeOAgeenu+WKqOiuvuWkh+ivhuWIq+eggU1FSUTjgIHljL/lkI3orr7lpIfmoIfor4bnrKZPQUlEIOOAgU1BQ+WcsOWdgOOAgUFuZHJvaWQgSUTnrYnorr7lpIfmoIfor4bnrKbvvInjgIHorr7lpIfov57mjqXkv6Hmga/vvIjkvovlpoLmtY/op4jlmajnmoTnsbvlnovjgIHnlLXkv6Hov5DokKXllYbjgIHkvb/nlKjnmoTor63oqIDjgIFXSUZJ5L+h5oGv77yJ44CB6K6+5aSH54q25oCB5L+h5oGv77yI5L6L5aaC6K6+5aSH5bqU55So5a6J6KOF5YiX6KGo5Y+K6K6+5aSH5Lyg5oSf5Zmo77yJ5Lul5Y+K6K6+5aSH5L2N572u5L+h5oGv77yI6YCa6L+HR1BT44CB6JOd54mZ5oiWV2ktRmnkv6Hlj7fojrflvpfnmoTkvY3nva7kv6Hmga/vvInjgIHml6Xlv5fkv6Hmga/jgIHkvY3nva7kv6Hmga/jgIHlupTnlKjnqIvluo/liJfooajkv6Hmga/vvIzkvKDmhJ/lmajkv6Hmga/vvIjpmYDonrrku6rkvKDmhJ/lmajjgIHliqDpgJ/kvKDmhJ/lmajjgIHph43lipvkvKDmhJ/lmajvvInvvIzku6Xkv53or4HmnI3liqHmraPluLjov5DooYwgLOmakOengeaUv+etlumTvuaOpTpodHRwczovL3d3dy5iYWlkdS5jb20vZHV0eS95aW5zaXF1YW4tcG9saWN5Lmh0bWwgCgozNjDlpYfomY5TREs65a6D5bCG5Lya5pS26ZuG5oKo55qE572R57uc5L2N572u5L+h5oGv44CBTUFDIOWcsOWdgOOAgeaJi+acuuWPt+eggeOAgSBTSU0g5Y2h5bqP5YiX5Y+344CBIElNRSDjgIEgSVAg5Zyw5Z2A44CBVzEtRuS/oeaBr+OAgU1BMOWcsOWdgCznlKjmnaXkvb/nlKjlupTnlKjliqDlm7rmnI3liqEs6ZqQ56eB5pS/562W6ZO+5o6lOmh0dHBzOi8vZGV2LjM2MC5jbi93aWtpL2luZGV4L2lkLzE2Cgrlv6vmiYvlub/lkYrogZTnm59TREs65L2/55So55uu55qE77ya55So5LqO6I635Y+W5bm/5ZGKIOaUtumbhuS4quS6uuS/oeaBr+exu+Wei++8mue9kee7nOiuv+mXru+8jOiuvuWkh+agh+ivhuS/oeaBr+OAkE1BQ+WcsOWdgOS/oeaBr+OAgWltZWnjgIFpbXNp5oiWb2FpZOOAgUFuZHJvaWQgSWQg44CBQ1BVIElEIOW6j+WIl+WPt+OAgU9wZW5VVUlkIChpT1Mp44CR44CB5Zyw55CG5L2N572u5L+h5oGv77yM572R57uc6K6/6Zeu77yM6I635Y+WV2lGaeeKtuaAge+8jOivu+WPlueUteivneeKtuaAge+8jOWGmeWFpeWklumDqOWtmOWCqO+8jOW3suWuieijheaIluato+WcqOi/m+eoi+eahOW6lOeUqOS/oeaBr++8jOS8oOaEn+WZqOS/oeaBr++8iOmZgOieuuS7quS8oOaEn+WZqO+8jOWKoOmAn+S8oOaEn+WZqO+8jOmHjeWKm+S8oOaEn+WZqO+8ieOAgiDjgIrlv6vmiYvlubPlj7DpmpDnp4HmlL/nrZbjgIs6aHR0cHM6Ly9wcml2YWN5Lmt1YWlzaG91LmNvbS9wb2xpY3kgCgpTaWdtb2Llub/lkYpTREs66K+lU0RL5Y+v6IO95Lya5pS26ZuG77ya6K6+5aSH5ZOB54mM44CB5Z6L5Y+344CB5pON5L2c57O757uf54mI5pys44CBT0FJROOAgeWIhui+qOeOh+etieWfuuehgOiuvuWkh+S/oeaBr+OAgueUqOS6juW5v+WRiuaKleaUvuOAgeW5v+WRiuS4u+W9kuWboOOAgeWPjeS9nOW8iiBTaWdtb2Llub/lkYrpmpDnp4HmlL/nrZbvvJoKCmh0dHBzOi8vZG9jLnNpZ21vYi5jb20vIy9TaWdtb2IlRTQlQkQlQkYlRTclOTQlQTglRTYlOEMlODclRTUlOEQlOTcvJUU5JTlBJTkwJUU3JUE3JTgxJUU2JTlEJUExJUU2JUFDJUJFLyVFOSU5QSU5MCVFNyVBNyU4MSVFNiU5NCVCRiVFNyVBRCU5Ni8KCuaUr+S7mOWunVNESyjpmL/ph4xTREsm5reY5a6dIFNESyk65a6D5bCG6I635Y+W57O757uf6K+t6KiA77yM57O757uf5ZSv5LiA5qCH6K+G56ym77yM5aSW6YOo5a2Y5YKo54q25oCB77yM572R57uc57G75Z6L77yM6K6+5aSH5Z6L5Y+377yM6K6+5aSH5Yi26YCg5ZWG77yMU0lNIOWNoeW6j+WIl+WPt++8jElNRUnvvIxNQUMg5Zyw5Z2A77yMQU5EUk9JRF9JRO+8jElQIOWcsOWdgO+8jFdpRmkg5L+h5oGv77yM5bqU55So5a6J6KOF5YiX6KGo77yMT3BlblVESUTnlKjkuo7mlK/ku5jnm7jlhbPmnI3liqHvvIzljIXmi6zorqLljZXmlK/ku5jjgIHkuqTmmJPooYzkuLrmoLjpqozjgIHmlLblhaXnu5PnrpfjgIHmlK/ku5jkv6Hmga/msYfmgLvnu5/orqHnrYnlpoLmgqjpnIDopoHkuobop6Pmm7TlpJos6K+35p+l55yL5pSv5LuY5a6d6ZqQ56eB5Y2P6K6uLOmTvuaOpTpodHRwczovL3JlbmRlci5hbGlwYXkuY29tL3AvYy9rMmN4MHRnOAoK5b6u5L+h5pSv5LuYU0RLOuWug+WwhuS8muaUtumbhuaCqOeahOaJi+acuuWPt+eggeOAgSBTSU0g5Y2h54q25oCB44CBIElNRSDjgIEgTUFDIOWcsOWdgOOAgSBXSS1GIOS/oeaBryznlKjkuo7lvq7kv6HmlK/ku5gs5Lul56Gu5L+d5pSv5LuY5a6J5YWoLOaCqOWPr+mAmui/h+iuv+mXruS7peS4i+mTvuaOpeafpeeci+W+ruS/oeWujOaVtOmakOengeaUv+etljpodHRwczovL3ByaXZhY3kucXEuY29tLwoK5b6u5L+h5YiG5LqrOuWug+WwhuS8muaUtumbhuaCqOeahOe9kee7nOS9jee9ruS/oeaBr+OAgeaJi+acuuWPt+eggeOAgSBTSU0g5Y2h5bqP5YiX5Y+344CBIElNRUlQIOWcsOWdgOOAgVcxLUbkv6Hmga/jgIEgTUFDIOWcsOWdgCznlKjkuo7mgqjpgJrov4flvq7kv6HnmbvpmYbmiJHku6znmoTotKbmiLcs5ZCM5pe25oKo5Lmf5Y+v5Lul6YCa6L+H5b6u5L+h5bCG5oiR5Lus5bmz5Y+w55qE5YaF5a655YiG5Lqr5Ye65Y67LOW+ruS/oemakOengeaUv+etlumTvuaOpTpodHRwczovL3ByaXZhY3kucXEuY29tLyAKCumYv+mHjHdlZXhTREs65a6D5bCG6I635Y+W5oKo55qE5a2Y5YKo5paH5Lu277yM55So5LqOdW5pLWFwcOWfuuehgOaooeWdl+m7mOiupOmbhuaIkO+8jOeUqOS6jua4suafk3VuaWFwcOeahG52dWXpobXpnaLlvJXmk47jgIIgLOmakOengeaUv+etlumTvuaOpTpodHRwOi8vZG9jLndlZXguaW8vemggCgpGcmVzY2/lm77lupM65a6D5bCG6I635Y+W5oKo55qE5a2Y5YKo5paH5Lu277yM55So5LqObnZ1ZemhtemdouWKoOi9veWbvueJh+S9v+eUqCAs6ZqQ56eB5pS/562W6ZO+5o6lOmh0dHBzOi8vd3d3LmZyZXNjby1jbi5vcmcvIAoKZ2xpZGXlm77lupM65a6D5bCG6I635Y+W5oKo55qE5a2Y5YKo5paH5Lu277yM55So5LqO5Zu+54mH6aKE6KeI5L2/55SoICzpmpDnp4HmlL/nrZbpk77mjqU6aHR0cDovL2J1bXB0ZWNoLmdpdGh1Yi5pby9nbGlkZS8gCgpnaWYtZHJhd2FibGU65a6D5bCG6I635Y+W5oKo55qE5a2Y5YKo5paH5Lu277yM5Yqg6L29Z2lm5Zu+ICzpmpDnp4HmlL/nrZbpk77mjqU6aHR0cHM6Ly9naXRodWIuY29tL2FsaWJhYmEvZmFzdGpzb24gCgpmYXN0anNvbjrnlKjkuo5KU09O6Kej5p6Q77yM5LiN5raJ5Y+K5Liq5Lq65L+h5oGvICzpmpDnp4HmlL/nrZbpk77mjqU6aHR0cHM6Ly9naXRodWIuY29tL2FsaWJhYmEvZmFzdGpzb24gCgrnp7vliqjlronlhajogZTnm58gT0FJRDrnp7vliqjmmbrog73nu4jnq6/ooaXlhYXorr7lpIfmoIfor4bkvZPns7vkuI4gU0RLIOS4peagvOmBteWuiOaIkeWbveOAiue9kee7nOWuieWFqOazleOAi+OAgeOAiuaVsOaNruWuieWFqOazleOAi+WSjOOAiueUteS/oeWSjOS6kuiBlOe9keeUqOaIt+S4quS6uuS/oeaBr+S/neaKpOinhOWumuOAi+etieebuOWFs+azleW+i+azleinhOWSjOOAiuS/oeaBr+WuieWFqOaKgOacryDkuKrkurrkv6Hmga/lronlhajop4TojIPjgIvnrYnlm73lrrbmoIflh4bopoHmsYLjgIJTREsg5LiN5Lya5Li75Yqo5pS26ZuG5Lu75L2V5pWw5o2u77yM5Y+q5ZyoIEFQUCDosIPnlKjml7bojrflj5bku6XkuIvmlbDmja7vvIznlKjkuo7mnKzlnLDliKTmlq3vvIzkuI3kvJrov5vooYzku7vkvZXnvZHnu5zkvKDovpPvvJoKCjHjgIHorr7lpIfliLbpgKDllYbjgIHorr7lpIflnovlj7fjgIHorr7lpIflk4HniYzvvIznlKjkuo7liKTmlq3nu4jnq6/osIPnlKjmjqXlj6PjgIIKCjLjgIHorr7lpIfnvZHnu5zov5DokKXllYblkI3np7DvvIznlKjkuo7liKTmlq3omZrmi5/mnLrnjq/looPjgIIKCjPjgIFBUFAg5YyF5ZCN77yM55So5LqO5qCh6aqM562+5ZCN44CCCgrpmpDnp4HmlL/nrZbpk77mjqUgOmh0dHBzOi8vZ2l0aHViLmNvbS9hbGliYWJhL2Zhc3Rqc29uCgrlvq7kv6HlvIDmlL7lubPlj7A655So5LqO5b6u5L+h55m75b2V44CB5YiG5Lqr77yM5a6D5bCG5Lya6I635Y+W5oKo55qE5Liq5Lq65paH5Lu244CB572R57uc5L+h5oGvICzlvq7kv6HpmpDnp4HljY/orq7pk77mjqU6aHR0cHM6Ly93ZWl4aW4ucXEuY29tL2NnaS1iaW4vcmVhZHRlbXBsYXRlP2xhbmc9emhfQ04mdD13ZWl4aW5fYWdyZWVtZW50JnM9cHJpdmFjeSAKCuS4qumqjOS4gOmUrueZu+W9lTrnlKjkuo5BcHDkuIDplK7nmbvlvZXvvIzlroPlsIbkvJrmtonlj4rmgqjnmoTkuKrkurrmlofku7bjgIHor7vlj5bmiYvmnLrnirbmgIHlkozouqvku73jgIHnvZHnu5zkv6Hmga/jgIIg6ZqQ56eB5Y2P6K6u6ZO+5o6lOmh0dHBzOi8vZG9jcy5nZXR1aS5jb20vcHJpdmFjeS8g44CCIOWkqee/vOiupOivgSDpmpDnp4HljY/orq7vvJpodHRwczovL2UuMTg5LmNuL3Nkay9hZ3JlZW1lbnQvZGV0YWlsLmRvP2hpZGV0b3A9dHJ1ZSDvvJsg5Lit5Zu956e75Yqo6K6k6K+BIOmakOengeWNj+iuru+8mmh0dHBzOi8vd2FwLmNtcGFzc3BvcnQuY29tL3Jlc291cmNlcy9odG1sL2NvbnRyYWN0Lmh0bWwg77ybIOiBlOmAmue7n+S4gOiupOivgSDpmpDnp4HljY/orq7vvJpodHRwczovL29wZW5jbG91ZC53b3N0b3JlLmNuL2F1dGh6L3Jlc291cmNlL2h0bWwvZGlzY2xhaW1lci5odG1sP2Zyb21zZGs9dHJ1ZSDvvJsKCnVuaS1hcHAoNSvjgIF3ZWIyYXBwKTrlroPkvJrojrflj5blrZjlgqjnmoTkuKrkurrmlofku7bvvIzorr7lpIfkv6Hmga/vvIhJTUVJ44CBQU5EUk9JRF9JROOAgURFVklDRV9JROOAgUlNU0nvvInvvIznvZHnu5zkv6Hmga/jgILnlKjkuo7ln7rnoYDmqKHlnZcgLOmakOengeWNj+iurumTvuaOpTpodHRwczovL2Fzay5kY2xvdWQubmV0LmNuL2FydGljbGUvMzY5MzcgCgpTaGFyZVNESzrkuLrkuoblrp7njrDliIbkuqvlkozmjqjpgIHlip/og73vvIzmiJHku6zkvb/nlKjkuoZNb2JUZWNo55qEIFNoYXJlU0RL5Lqn5ZOB77yM5q2k5Lqn5ZOB55qE6ZqQ56eB5pS/562W6K+35Y+C6ICD77yaIGh0dHBzOi8vd3d3Lm1vYi5jb20vYWJvdXQvcG9saWN5CgpNb2JUZWNoIFNESzrmiJHku6zkvb/nlKjkuobnrKzkuInmlrnvvIjkuIrmtbfmuLjmmIbkv6Hmga/mioDmnK/mnInpmZDlhazlj7jvvIzku6XkuIvnp7DigJxNb2JUZWNo4oCd77yJTW9iVGVjaCBTREsg5pyN5Yqh5Li65oKo5o+Q5L6b44CQ56ys5LiJ5pa555m75b2V5ZKM5YiG5LqrIOOAkeWKn+iDveOAguS4uuS6humhuuWIqeWunueOsOivpeWKn+iDve+8jOaCqOmcgOimgeaOiOadg01vYlRlY2ggU0RL5o+Q5L6b5a+55bqU55qE5pyN5YqhO+WcqOaCqOaOiOadg+WQju+8jE1vYlRlY2jlsIbmlLbpm4bmgqjnm7jlhbPnmoTkuKrkurrkv6Hmga8657O757uf6L+Q6JCl5L+h5oGv44CB572R57uc54q25oCB5L+h5oGv44CBaU9T5bm/5ZGK5qCH6K+G56ym77yISURGQe+8ieOAgU1BQ+WcsOWdgOOAgeWbvemZheenu+WKqOiuvuWkh+ivhuWIq+egge+8iElNRUnvvInjgIHljL/lkI3orr7lpIfmoIfor4bnrKYoT0FJRCnjgIHlm73pmYXnp7vliqjnlKjmiLfor4bliKvnoIHvvIhJTVNJ77yJ44CB5bqU55So5YiX6KGo5L+h5oGv44CB5Z+656uZ5L+h5oGv44CB56S+5Lqk5bmz5Y+wT3BlbklE44CB5Zyw55CG5L2N572u44CC5YWz5LqOTW9iVGVjaOaJgOaUtumbhueahOS/oeaBr+enjeexu+OAgeeUqOmAlOOAgeS4quS6uuS/oeaBr+S/neaKpOeahOinhOWImeWPiumAgOWHuuacuuWItuetie+8jOivpuingU1vYlRlY2jlrpjnvZHvvIh3d3cubW9iLmNvbe+8iSDkuIrnmoTpmpDnp4HmlL/nrZYg77yId3d3Lm1vYi5jb20vYWJvdXQvcG9saWN577yJIOadoeasvgoK5LqM44CB5oiR5Lus5aaC5L2V5YWx5Lqr44CB6L2s6K6p44CB5YWs5byA5oqr6Zyy5oKo55qE5Liq5Lq65L+h5oGvCgoo5LiAKeWFseS6qwoK5oiR5Lus5LiN5Lya5ZCR5YW25LuW5Lu75L2V5YWs5Y+444CB57uE57uH5ZKM5Liq5Lq65YiG5Lqr5oKo55qE5Liq5Lq65L+h5oGv77yM5L2G5Lul5LiL5oOF5Ya16Zmk5aSW77yaCgrlnKjojrflj5bmmI7noa7lkIzmhI/nmoTmg4XlhrXkuIvlhbHkuqvvvJrojrflvpfmgqjnmoTmmI7noa7lkIzmhI/lkI7vvIzmiJHku6zkvJrkuI7lhbbku5bmlrnlhbHkuqvmgqjnmoTkuKrkurrkv6Hmga/jgIIKCuaIkeS7rOWPr+iDveS8muagueaNruazleW+i+azleinhOinhOWumu+8jOaIluaMieaUv+W6nOS4u+euoemDqOmXqOeahOW8uuWItuaAp+imgeaxgu+8jOWvueWkluWFseS6q+aCqOeahOS4quS6uuS/oeaBr+OAggoK5LiO5oiR5Lus55qE5YWz6IGU5YWs5Y+45YWx5Lqr77ya5oKo55qE5Liq5Lq65L+h5oGv5Y+v6IO95Lya5LiO5oiR5Lus5YWz6IGU5YWs5Y+45YWx5Lqr44CC5oiR5Lus5Y+q5Lya5YWx5Lqr5b+F6KaB55qE5Liq5Lq65L+h5oGv77yM5LiU5Y+X5pys6ZqQ56eB5Y2P6K6u5Lit5omA5aOw5piO55uu55qE55qE57qm5p2f44CC5YWz6IGU5YWs5Y+45aaC6KaB5pS55Y+Y5Liq5Lq65L+h5oGv55qE5aSE55CG55uu55qE77yM5bCG5YaN5qyh5b6B5rGC5oKo55qE5o6I5p2D5ZCM5oSP44CCCgrkuI7mjojmnYPlkIjkvZzkvJnkvLTlhbHkuqvvvJrku4XkuLrlrp7njrDmnKzpmpDnp4HljY/orq7kuK3lo7DmmI7nmoTnm67nmoTvvIzmiJHku6znmoTmn5DkupvmnI3liqHlsIbnlLHmjojmnYPlkIjkvZzkvJnkvLTmj5DkvpvjgILmiJHku6zlj6/og73kvJrkuI7lkIjkvZzkvJnkvLTlhbHkuqvmgqjnmoTmn5DkupvkuKrkurrkv6Hmga/vvIzku6Xmj5Dkvpvmm7Tlpb3nmoTlrqLmiLfmnI3liqHlkoznlKjmiLfkvZPpqozjgIIKCuWcqOi/meenjeaDheWGteS4i++8jOi/meS6m+WFrOWPuOW/hemhu+mBteWuiOaIkeS7rOeahOaVsOaNrumakOengeWSjOWuieWFqOimgeaxguOAguaIkeS7rOS7heS8muWHuuS6juWQiOazleOAgeato+W9k+OAgeW/heimgeOAgeeJueWumuOAgeaYjuehrueahOebrueahOWFseS6q+aCqOeahOS4quS6uuS/oeaBr++8jOW5tuS4lOWPquS8muWFseS6q+aPkOS+m+acjeWKoeaJgOW/heimgeeahOS4quS6uuS/oeaBr+OAggoK5a+55oiR5Lus5LiO5LmL5YWx5Lqr5Liq5Lq65L+h5oGv55qE5YWs5Y+444CB57uE57uH5ZKM5Liq5Lq677yM5oiR5Lus5Lya5LiO5YW2562+572y5Lil5qC855qE5L+d5a+G5Y2P5a6a77yM6KaB5rGC5LuW5Lus5oyJ54Wn5oiR5Lus55qE6K+05piO44CB5pys6ZqQ56eB5Y2P6K6u5Lul5Y+K5YW25LuW5Lu75L2V55u45YWz55qE5L+d5a+G5ZKM5a6J5YWo5o6q5pa95p2l5aSE55CG5Liq5Lq65L+h5oGv44CCCgoo5LqMKei9rOiuqQoK5oiR5Lus5LiN5Lya5bCG5oKo55qE5Liq5Lq65L+h5oGv6L2s6K6p57uZ5Lu75L2V5YWs5Y+444CB57uE57uH5ZKM5Liq5Lq677yM5L2G5Lul5LiL5oOF5Ya16Zmk5aSW77yaCgrlnKjojrflj5bmmI7noa7lkIzmhI/nmoTmg4XlhrXkuIvovazorqnvvJrojrflvpfmgqjnmoTmmI7noa7lkIzmhI/lkI7vvIzmiJHku6zkvJrlkJHlhbbku5bmlrnovazorqnmgqjnmoTkuKrkurrkv6Hmga/vvJsKCuWcqOa2ieWPiuWQiOW5tuOAgeaUtui0reaIluegtOS6p+a4heeul+aXtu+8jOWmgua2ieWPiuWIsOS4quS6uuS/oeaBr+i9rOiuqe+8jOaIkeS7rOS8muWcqOimgeaxguaWsOeahOaMgeacieaCqOS4quS6uuS/oeaBr+eahOWFrOWPuOOAgee7hOe7h+e7p+e7reWPl+atpOmakOengeWNj+iurueahOe6puadn++8jOWQpuWImeaIkeS7rOWwhuimgeaxguivpeWFrOWPuOOAgee7hOe7h+mHjeaWsOWQkeaCqOW+geaxguaOiOadg+WQjOaEj+OAggoKKOS4iSnlhazlvIDmiqvpnLIKCuaIkeS7rOS7heS8muWcqOS7peS4i+aDheWGteS4i++8jOWFrOW8gOaKq+mcsuaCqOeahOS4quS6uuS/oeaBr++8mgoK6I635b6X5oKo5piO56Gu5ZCM5oSP5ZCO77ybCgrln7rkuo7ms5XlvovnmoTmiqvpnLLvvJrlnKjms5XlvovjgIHms5XlvovnqIvluo/jgIHor4norrzmiJbmlL/lupzkuLvnrqHpg6jpl6jlvLrliLbmgKfopoHmsYLnmoTmg4XlhrXkuIvvvIzmiJHku6zlj6/og73kvJrlhazlvIDmiqvpnLLmgqjnmoTkuKrkurrkv6Hmga/jgIIKCijlm5sp5oiR5Lus5L+d55WZ6Ieq6KGM6YCJ5oup5ZCR56ys5LiJ5pa55L2/55So5ZKM5oqr6Zyy5Yy/5ZCN5L+h5oGv55qE5p2D5Yip77yM5YyF5ous55So5LqO5YaF6YOo5Lia5Yqh5YiG5p6Q77yM5Lul5Y+K5ZCR5oiR5Lus55qE5ZCE5Liq5ZCI5L2c5pa55o+Q5L6b5rGH5oC757uf6K6h5pWw5o2u55qE5p2D5Yip44CCCgrkuInjgIHmiJHku6zlpoLkvZXkv53miqTmgqjnmoTkuKrkurrkv6Hmga8KCijkuIAp5oiR5Lus5bey5L2/55So56ym5ZCI5Lia55WM5qCH5YeG55qE5a6J5YWo6Ziy5oqk5o6q5pa95L+d5oqk5oKo5o+Q5L6b55qE5Liq5Lq65L+h5oGv77yM6Ziy5q2i5pWw5o2u6YGt5Yiw5pyq57uP5o6I5p2D6K6/6Zeu44CB5YWs5byA5oqr6Zyy44CB5L2/55So44CB5L+u5pS544CB5o2f5Z2P5oiW5Lii5aSx44CC5oiR5Lus5Lya6YeH5Y+W5LiA5YiH5ZCI55CG5Y+v6KGM55qE5o6q5pa977yM5L+d5oqk5oKo55qE5Liq5Lq65L+h5oGv44CCCgrkvovlpoLvvIzlnKjmgqjnmoTmiYvmnLrkuI7mnI3liqHlmajkuYvpl7TkuqTmjaLmlbDmja7ml7blj5dTU0zliqDlr4bkv53miqTvvJsKCuaIkeS7rOWQjOaXtuWvueaIkeS7rOacjeWKoeaPkOS+myBodHRwc+WuieWFqOa1j+iniOaWueW8j++8mwoK5oiR5Lus5Lya5L2/55So5Yqg5a+G5oqA5pyv56Gu5L+d5pWw5o2u55qE5L+d5a+G5oCn77ybCgrmiJHku6zkvJrkvb/nlKjlj5fkv6HotZbnmoTkv53miqTmnLrliLbpmLLmraLmlbDmja7pga3liLDmgbbmhI/mlLvlh7vvvJsKCuaIkeS7rOS8mumDqOe9suiuv+mXruaOp+WItuacuuWItu+8jOehruS/neWPquacieaOiOadg+S6uuWRmOaJjeWPr+iuv+mXruS4quS6uuS/oeaBr++8mwoK5Lul5Y+K5oiR5Lus5Lya5Li+5Yqe5a6J5YWo5ZKM6ZqQ56eB5L+d5oqk5Z+56K6t6K++56iL77yM5Yqg5by65ZGY5bel5a+55LqO5L+d5oqk5Liq5Lq65L+h5oGv6YeN6KaB5oCn55qE6K6k6K+G44CCCgoo5LqMKeaIkeS7rOS8mumHh+WPluS4gOWIh+WQiOeQhuWPr+ihjOeahOaOquaWve+8jOehruS/neacquaUtumbhuaXoOWFs+eahOS4quS6uuS/oeaBr+OAguaIkeS7rOWPquS8muWcqOi+vuaIkOacrOadoeasvuaJgOi/sOebrueahOaJgOmcgOeahOacn+mZkOWGheS/neeVmeaCqOeahOS4quS6uuS/oeaBr++8jOmZpOmdnumcgOimgeW7tumVv+S/neeVmeacn+aIluWPl+WIsOazleW+i+eahOWFgeiuuOOAggoKKOS4iSnkupLogZTnvZHlubbpnZ7nu53lr7nlronlhajnmoTnjq/looPvvIzogIzkuJTnlLXlrZDpgq7ku7bjgIHljbPml7bpgJrorq/jgIHlj4rkuI7lhbbku5bmiJHku6znlKjmiLfnmoTkuqTmtYHmlrnlvI/lubbmnKrliqDlr4bvvIzmiJHku6zlvLrng4jlu7rorq7mgqjkuI3opoHpgJrov4fmraTnsbvmlrnlvI/lj5HpgIHkuKrkurrkv6Hmga/jgILor7fkvb/nlKjlpI3mnYLlr4bnoIHvvIzljY/liqnmiJHku6zkv53or4HmgqjnmoTotKblj7flronlhajjgIIKCijlm5sp5LqS6IGU572R546v5aKD5bm26Z2e55m+5YiG5LmL55m+5a6J5YWo77yM5oiR5Lus5bCG5bC95Yqb56Gu5L+d5oiW5ouF5L+d5oKo5Y+R6YCB57uZ5oiR5Lus55qE5Lu75L2V5L+h5oGv55qE5a6J5YWo5oCn44CCCgoo5LqUKeWcqOS4jeW5uOWPkeeUn+S4quS6uuS/oeaBr+WuieWFqOS6i+S7tuWQju+8jOaIkeS7rOWwhuaMieeFp+azleW+i+azleinhOeahOimgeaxgu+8jOWPiuaXtuWQkeaCqOWRiuefpe+8muWuieWFqOS6i+S7tueahOWfuuacrOaDheWGteWSjOWPr+iDveeahOW9seWTjeOAgeaIkeS7rOW3sumHh+WPluaIluWwhuimgemHh+WPlueahOWkhOe9ruaOquaWveOAgeaCqOWPr+iHquS4u+mYsuiMg+WSjOmZjeS9jumjjumZqeeahOW7uuiuruOAgeWvueaCqOeahOihpeaVkeaOquaWveetieOAggoK5oiR5Lus5bCG5Y+K5pe25bCG5LqL5Lu255u45YWz5oOF5Ya15Lul6YKu5Lu244CB5L+h5Ye944CB55S16K+d44CB5o6o6YCB6YCa55+l562J5pa55byP5ZGK55+l5oKo77yM6Zq+5Lul6YCQ5LiA5ZGK55+l5Liq5Lq65L+h5oGv5Li75L2T5pe277yM5oiR5Lus5Lya6YeH5Y+W5ZCI55CG44CB5pyJ5pWI55qE5pa55byP5Y+R5biD5YWs5ZGK44CC5ZCM5pe277yM5oiR5Lus6L+Y5bCG5oyJ54Wn55uR566h6YOo6Zeo6KaB5rGC77yM5Li75Yqo5LiK5oql5Liq5Lq65L+h5oGv5a6J5YWo5LqL5Lu255qE5aSE572u5oOF5Ya144CCCgrlm5vjgIHmgqjnmoTmnYPliKkKCuaMieeFp+S4reWbveebuOWFs+eahOazleW+i+OAgeazleinhOOAgeagh+WHhu+8jOS7peWPiuWFtuS7luWbveWutuOAgeWcsOWMuueahOmAmuihjOWBmuazle+8jOaIkeS7rOS/nemanOaCqOWvueiHquW3seeahOS4quS6uuS/oeaBr+ihjOS9v+S7peS4i+adg+WIqe+8mgoKKOS4gCnorr/pl67mgqjnmoTkuKrkurrkv6Hmga8KCuaCqOacieadg+iuv+mXruaCqOeahOS4quS6uuS/oeaBr++8jOazleW+i+azleinhOinhOWumueahOS+i+WkluaDheWGtemZpOWkluOAguWmguaenOaCqOaDs+ihjOS9v+aVsOaNruiuv+mXruadg++8jOWPr+S7pemAmui/h+S7peS4i+aWueW8j+iHquihjOiuv+mXru+8mgoK6LSm5oi35L+h5oGv4oCU4oCU5aaC5p6c5oKo5biM5pyb6K6/6Zeu5oiW57yW6L6R5oKo55qE6LSm5oi35Lit55qE5Liq5Lq66LWE5paZ5L+h5oGv5ZKM5pSv5LuY5L+h5oGv44CB5pu05pS55oKo55qE5a+G56CB44CB5re75Yqg5a6J5YWo5L+h5oGv5oiW5YWz6Zet5oKo55qE6LSm5oi3562J77yM5oKo5Y+v5Lul6YCa6L+HQVBQ5YaF55qE55u45YWz6K6+572u6aG16Z2i5oiW6ICF6IGU57O75oiR5Lus5omn6KGM5q2k57G75pON5L2c44CCCgrlr7nkuo7mgqjlnKjkvb/nlKjmiJHku6znmoTkuqflk4HmiJbmnI3liqHov4fnqIvkuK3kuqfnlJ/nmoTlhbbku5bkuKrkurrkv6Hmga/vvIzlj6ropoHmiJHku6zkuI3pnIDopoHov4flpJrmipXlhaXvvIzmiJHku6zkvJrlkJHmgqjmj5DkvpvjgIIKCuW9k+aCqOWPkeeOsOaIkeS7rOWkhOeQhueahOWFs+S6juaCqOeahOS4quS6uuS/oeaBr+aciemUmeivr+aXtu+8jOaCqOacieadg+imgeaxguaIkeS7rOWBmuWHuuabtOato+OAguaCqOWPr+S7pemAmui/h+KAnCjkuIAp6K6/6Zeu5oKo55qE5Liq5Lq65L+h5oGv4oCd5Lit572X5YiX55qE5pa55byP5omn6KGM5q2k57G75pON5L2c44CCCgoo5LiJKeWIoOmZpOaCqOeahOS4quS6uuS/oeaBrwoK5Zyo5Lul5LiL5oOF5b2i5Lit77yM5oKo5Y+v5Lul5ZCR5oiR5Lus5o+Q5Ye65Yig6Zmk5Liq5Lq65L+h5oGv55qE6K+35rGC77yaCgrlpoLmnpzmiJHku6zlpITnkIbkuKrkurrkv6Hmga/nmoTooYzkuLrov53lj43ms5Xlvovms5Xop4TvvJsKCuWmguaenOaIkeS7rOaUtumbhuOAgeS9v+eUqOaCqOeahOS4quS6uuS/oeaBr++8jOWNtOacquW+geW+l+aCqOeahOWQjOaEj++8mwoK5aaC5p6c5oiR5Lus5aSE55CG5Liq5Lq65L+h5oGv55qE6KGM5Li66L+d5Y+N5LqG5LiO5oKo55qE57qm5a6a77ybCgrlpoLmnpzmgqjkuI3lho3kvb/nlKjmiJHku6znmoTkuqflk4HmiJbmnI3liqHvvIzmiJbmgqjms6jplIDkuobotKblj7fvvJsKCuWmguaenOaIkeS7rOS4jeWGjeS4uuaCqOaPkOS+m+S6p+WTgeaIluacjeWKoeOAggoK6Iul5oiR5Lus5Yaz5a6a5ZON5bqU5oKo55qE5Yig6Zmk6K+35rGC77yM5oiR5Lus6L+Y5bCG5ZCM5pe26YCa55+l5LuO5oiR5Lus6I635b6X5oKo55qE5Liq5Lq65L+h5oGv55qE5a6e5L2T77yM6KaB5rGC5YW25Y+K5pe25Yig6Zmk77yM6Zmk6Z2e5rOV5b6L5rOV6KeE5Y+m5pyJ6KeE5a6a77yM5oiW6L+Z5Lqb5a6e5L2T6I635b6X5oKo55qE54us56uL5o6I5p2D44CCCgrlvZPmgqjku47miJHku6znmoTmnI3liqHkuK3liKDpmaTkv6Hmga/lkI7vvIzmiJHku6zlj6/og73kuI3kvJrnq4vljbPlpIfku73ns7vnu5/kuK3liKDpmaTnm7jlupTnmoTkv6Hmga/vvIzkvYbkvJrlnKjlpIfku73mm7TmlrDml7bliKDpmaTov5nkupvkv6Hmga/jgIIKCijlm5sp5pS55Y+Y5oKo5o6I5p2D5ZCM5oSP55qE6IyD5Zu0Cgrmr4/kuKrkuJrliqHlip/og73pnIDopoHkuIDkupvln7rmnKznmoTkuKrkurrkv6Hmga/miY3og73lvpfku6XlrozmiJAo6KeB5pys5p2h5qy+4oCc56ys5LiA6YOo5YiG4oCdKeOAguWvueS6jumineWkluaUtumbhueahOS4quS6uuS/oeaBr+eahOaUtumbhuWSjOS9v+eUqO+8jOW9k+aCqOaUtuWbnuWQjOaEj+WQju+8jOaIkeS7rOWwhuS4jeWGjeWkhOeQhuebuOW6lOeahOS4quS6uuS/oeaBr+OAguS9huaCqOaUtuWbnuWQjOaEj+eahOWGs+Wumu+8jOS4jeS8muW9seWTjeatpOWJjeWfuuS6juaCqOeahOaOiOadg+iAjOW8gOWxleeahOS4quS6uuS/oeaBr+WkhOeQhuOAggoKKOS6lCnkuKrkurrkv6Hmga/kuLvkvZPms6jplIDotKbmiLcKCuaCqOmaj+aXtuWPr+azqOmUgOatpOWJjeazqOWGjOeahOi0puaIt+OAggoK5rOo6ZSA5rWB56iL77yaQVBQ5oiR6aG1LT7orr7nva4tPuazqOmUgOi0puWPty0+5by55Ye656Gu6K6k5qGGLT7noa7lrprvvJvoh7PmraTotKblj7fms6jplIDmiJDlip/jgIIKCuWcqOazqOmUgOi0puaIt+S5i+WQju+8jOaIkeS7rOWwhuWBnOatouS4uuaCqOaPkOS+m+S6p+WTgeaIluacjeWKoe+8jOW5tuS+neaNruaCqOeahOimgeaxgu+8jOWIoOmZpOaCqOeahOS4quS6uuS/oeaBr++8jOazleW+i+azleinhOWPpuacieinhOWumueahOmZpOWkluOAggoKKOWFrSnkuKrkurrkv6Hmga/kuLvkvZPojrflj5bkuKrkurrkv6Hmga/lia/mnKwKCuaCqOacieadg+iOt+WPluaCqOeahOS4quS6uuS/oeaBr+WJr+acrOOAggoK5Zyo5oqA5pyv5Y+v6KGM55qE5YmN5o+Q5LiL77yM5L6L5aaC5pWw5o2u5o6l5Y+j5Yy56YWN77yM5oiR5Lus6L+Y5Y+v5oyJ5oKo55qE6KaB5rGC77yM55u05o6l5bCG5oKo55qE5Liq5Lq65L+h5oGv5Ymv5pys5Lyg6L6T57uZ5oKo5oyH5a6a55qE56ys5LiJ5pa544CCCgoo5LiDKee6puadn+S/oeaBr+ezu+e7n+iHquWKqOWGs+etlgoK5Zyo5p+Q5Lqb5Lia5Yqh5Yqf6IO95Lit77yM5oiR5Lus5Y+v6IO95LuF5L6d5o2u5L+h5oGv57O757uf44CB566X5rOV562J5Zyo5YaF55qE6Z2e5Lq65bel6Ieq5Yqo5Yaz562W5py65Yi25YGa5Ye65Yaz5a6a44CC5aaC5p6c6L+Z5Lqb5Yaz5a6a5pi+6JGX5b2x5ZON5oKo55qE5ZCI5rOV5p2D55uK77yM5oKo5pyJ5p2D6KaB5rGC5oiR5Lus5YGa5Ye66Kej6YeK77yM5oiR5Lus5Lmf5bCG5o+Q5L6b6YCC5b2T55qE5pWR5rWO5pa55byP44CCCgoo5YWrKeWTjeW6lOaCqOeahOS4iui/sOivt+axggoK5oKo5Y+v5Lul6YCa6L+H5paH5pyr55qE6IGU57O75pa55byP5o+Q5Ye65LiK6L+w6K+35rGCLOaIkeS7rOWwhuWcqOS4ieWNgeWkqeWGheWBmuWHuuetlOWkjeOAguS4uuS/nemanOWuieWFqO+8jOaCqOWPr+iDvemcgOimgeaPkOS+m+S5pumdouivt+axgu+8jOaIluS7peWFtuS7luaWueW8j+ivgeaYjuaCqOeahOi6q+S7veOAguaIkeS7rOWPr+iDveS8muWFiOimgeaxguaCqOmqjOivgeiHquW3seeahOi6q+S7ve+8jOeEtuWQjuWGjeWkhOeQhuaCqOeahOivt+axguOAggoK5a+55LqO5oKo5ZCI55CG55qE6K+35rGC77yM5oiR5Lus5Y6f5YiZ5LiK5LiN5pS25Y+W6LS555So77yM5L2G5a+55aSa5qyh6YeN5aSN44CB6LaF5Ye65ZCI55CG6ZmQ5bqm55qE6K+35rGC77yM5oiR5Lus5bCG6KeG5oOF5pS25Y+W5LiA5a6a5oiQ5pys6LS555So44CCCgrlr7nkuo7pgqPkupvml6Dnq6/ph43lpI3jgIHpnIDopoHov4flpJrmioDmnK/miYvmrrUo5L6L5aaC77yM6ZyA6KaB5byA5Y+R5paw57O757uf5oiW5LuO5qC55pys5LiK5pS55Y+Y546w6KGM5oOv5L6LKeOAgee7meS7luS6uuWQiOazleadg+ebiuW4puadpemjjumZqeaIluiAhemdnuW4uOS4jeWIh+WunumZhSjkvovlpoLvvIzmtonlj4rlpIfku73no4HluKbkuIrlrZjmlL7nmoTkv6Hmga8p55qE6K+35rGC77yM5oiR5Lus5Y+v6IO95Lya5LqI5Lul5ouS57ud44CCCgrlnKjku6XkuIvmg4XlvaLkuK3vvIzmjInnhafms5Xlvovms5Xop4TopoHmsYLvvIzmiJHku6zlsIbml6Dms5Xlk43lupTmgqjnmoTor7fmsYLvvJoKCuS4juWbveWutuWuieWFqOOAgeWbvemYsuWuieWFqOacieWFs+eahO+8mwoK5LiO5YWs5YWx5a6J5YWo44CB5YWs5YWx5Y2r55Sf44CB6YeN5aSn5YWs5YWx5Yip55uK5pyJ5YWz55qE77ybCgrkuI7niq/nvarkvqbmn6XjgIHotbfor4nlkozlrqHliKTnrYnmnInlhbPnmoTvvJsKCuacieWFheWIhuivgeaNruihqOaYjuaCqOWtmOWcqOS4u+inguaBtuaEj+aIlua7peeUqOadg+WIqeeahO+8mwoK5ZON5bqU5oKo55qE6K+35rGC5bCG5a+86Ie05oKo5oiW5YW25LuW5Liq5Lq644CB57uE57uH55qE5ZCI5rOV5p2D55uK5Y+X5Yiw5Lil6YeN5o2f5a6z55qE44CCCgrkupTjgIHmiJHku6zlpoLkvZXlpITnkIbmnKrmiJDlubTkurrnmoTkuKrkurrkv6Hmga8KCuaIkeS7rOeahOS6p+WTgeOAgee9keermeWSjOacjeWKoeWFqOmDqOmdouWQkeaIkOW5tOS6uuOAguWmguaenOayoeacieeItuavjeaIluebkeaKpOS6uueahOWQjOaEj++8jOacquaIkOW5tOS6uuS4jeW+l+WIm+W7uuiHquW3seeahOeUqOaIt+i0puaIt+OAggoK5a+55LqO57uP54i25q+N5ZCM5oSP6ICM5pS26ZuG5pyq5oiQ5bm05Lq65Liq5Lq65L+h5oGv55qE5oOF5Ya177yM5oiR5Lus5Y+q5Lya5Zyo5Y+X5Yiw5rOV5b6L5YWB6K6444CB54i25q+N5oiW55uR5oqk5Lq65piO56Gu5ZCM5oSP5oiW6ICF5L+d5oqk5pyq5oiQ5bm05Lq65omA5b+F6KaB55qE5oOF5Ya15LiL5L2/55So5oiW5YWs5byA5oqr6Zyy5q2k5L+h5oGv44CC5Zyo5p+Q5Lqb6ZyA6KaB5Liq5Lq65L+h5oGv55qE5rS75Yqo5LitLOWPguWKoOa0u+WKqOWNs+ihqOekuuWQjOaEj+aIkeS7rOaUtumbhuS4quS6uuS/oeaBr+OAggoK5bC9566h5b2T5Zyw5rOV5b6L5ZKM5Lmg5L+X5a+55pyq5oiQ5bm05Lq655qE5a6a5LmJ5LiN5ZCM77yM5L2G5oiR5Lus5bCG5LiN5ruhIDE4IOWRqOWygeeahOS7u+S9leS6uuWdh+inhuS4uuacquaIkOW5tOS6uuOAggoK5aaC5p6c5oiR5Lus5Y+R546w6Ieq5bex5Zyo5pyq5LqL5YWI6I635b6X5Y+v6K+B5a6e55qE54i25q+N5ZCM5oSP55qE5oOF5Ya15LiL5pS26ZuG5LqG5pyq5oiQ5bm05Lq655qE5Liq5Lq65L+h5oGv77yM5YiZ5Lya6K6+5rOV5bC95b+r5Yig6Zmk55u45YWz5pWw5o2u44CCCgrlha3jgIHmgqjnmoTkuKrkurrkv6Hmga/lpoLkvZXlnKjlhajnkIPojIPlm7Tovaznp7sKCuWOn+WImeS4iu+8jOaIkeS7rOWcqOS4reWNjuS6uuawkeWFseWSjOWbveWig+WGheaUtumbhuWSjOS6p+eUn+eahOS4quS6uuS/oeaBr++8jOWwhuWtmOWCqOWcqOS4reWNjuS6uuawkeWFseWSjOWbveWig+WGheOAggoK55Sx5LqO5oiR5Lus6YCa6L+H6YGN5biD5YWo55CD55qE6LWE5rqQ5ZKM5pyN5Yqh5Zmo5o+Q5L6b5Lqn5ZOB5oiW5pyN5Yqh77yM6L+Z5oSP5ZGz552A77yM5Zyo6I635b6X5oKo55qE5o6I5p2D5ZCM5oSP5ZCO77yM5oKo55qE5Liq5Lq65L+h5oGv5Y+v6IO95Lya6KKr6L2s56e75Yiw5oKo5L2/55So5Lqn5ZOB5oiW5pyN5Yqh5omA5Zyo5Zu95a62L+WcsOWMuueahOWig+Wklueuoei+luWMuu+8jOaIluiAheWPl+WIsOadpeiHqui/meS6m+euoei+luWMuueahOiuv+mXruOAggoK5q2k57G7566h6L6W5Yy65Y+v6IO96K6+5pyJ5LiN5ZCM55qE5pWw5o2u5L+d5oqk5rOV77yM55Sa6Iez5pyq6K6+56uL55u45YWz5rOV5b6L44CC5Zyo5q2k57G75oOF5Ya15LiL77yM5oiR5Lus5Lya56Gu5L+d5oKo55qE5Liq5Lq65L+h5oGv5b6X5Yiw5Zyo5Lit5Y2O5Lq65rCR5YWx5ZKM5Zu95aKD5YaF6Laz5aSf5ZCM562J55qE5L+d5oqk44CCCgrkvovlpoLvvIzmiJHku6zkvJror7fmsYLmgqjlr7not6jlooPovaznp7vkuKrkurrkv6Hmga/nmoTlkIzmhI/vvIzmiJbogIXlnKjot6jlooPmlbDmja7ovaznp7vkuYvliY3lrp7mlr3mlbDmja7ljrvmoIfor4bljJbnrYnlronlhajkuL7mjqrjgIIKCuS4g+OAgeacrOmakOengeWNj+iuruWmguS9leabtOaWsAoK5oiR5Lus5Y+v6IO96YCC5pe25Lya5a+55pys6ZqQ56eB5Y2P6K6u6L+b6KGM6LCD5pW05oiW5Y+Y5pu077yM5pys6ZqQ56eB5Y2P6K6u55qE5Lu75L2V5pu05paw5bCG5Lul5qCH5rOo5pu05paw5pe26Ze055qE5pa55byP5YWs5biD5Zyo5oiR5LusQVBQ5YaF77yM6Zmk5rOV5b6L5rOV6KeE5oiW55uR566h6KeE5a6a5Y+m5pyJ5by65Yi25oCn6KeE5a6a5aSW77yM57uP6LCD5pW05oiW5Y+Y5pu055qE5YaF5a655LiA57uP6YCa55+l5oiW5YWs5biD5ZCO55qEN+aXpeWQjueUn+aViOOAggoK5aaC5oKo5Zyo6ZqQ56eB5Y2P6K6u6LCD5pW05oiW5Y+Y5pu05ZCO57un57ut5L2/55So5oiR5Lus5o+Q5L6b55qE5Lu75LiA5pyN5Yqh5oiW6K6/6Zeu5oiR5Lus55u45YWz572R56uZ55qE77yM5oiR5Lus55u45L+h6L+Z5Luj6KGo5oKo5bey5YWF5YiG6ZiF6K+744CB55CG6Kej5bm25o6l5Y+X5L+u5pS55ZCO55qE6ZqQ56eB5Y2P6K6u5bm25Y+X5YW257qm5p2f44CCCgrlhavjgIHlpoLkvZXogZTns7vmiJHku6wKCuWmguaenOaCqOWvueacrOmakOengeWNj+iuruacieS7u+S9leeWkemXruOAgeaEj+ingeaIluW7uuiuru+8jOmAmui/h+S7peS4i+aWueW8j+S4juaIkeS7rOiBlOezu++8mgoK5YWs5Y+45ZCN56ew77ya5peg6ZSh5bCP5pKt6byg572R57uc56eR5oqA5pyJ6ZmQ5YWs5Y+4CgrogZTns7vmlrnlvI/vvJoyNDQyNTUwNTVAcXEuY29tCgrms6jlhozlnLDlnYDvvJrmsZ/oi4/nnIHml6DplKHluILplKHlsbHljLrnmq7pnanln47llYbkuJrooZdUMi0yMDIKCuW4uOeUqOWKnuWFrOWcsOWdgO+8muaxn+iLj+ecgeaXoOmUoeW4gumUoeWxseWMuuearumdqeWfjuWVhuS4muihl1QyLTIwMgoK5L+h5oGv5L+d5oqk6LSf6LSj5Lq66IGU57O755S16K+dMDUxMC04MDUwMTExNgoK5pS/562W55Sf5pWI5pe26Ze0Cgroh6rlupTnlKjlj5HluIPkuYvml6XvvIgyMDIzLTA277yJ6LW35LiA55u05pyJ5pWI', '1');

-- ----------------------------
-- Procedure structure for `dis_str`
-- ----------------------------
DROP PROCEDURE IF EXISTS `dis_str`;
DELIMITER ;;
CREATE   PROCEDURE `dis_str`(in ids varchar(5000) ,  in zid int )
BEGIN 

	DECLARE  device_name, device_code , device_seed ,userid_seed varchar(45);
    declare  tmps varchar(5000);
    declare  count int;
    declare  id varchar(20) ;
    declare  i  int default 0; 
    SET SQL_SAFE_UPDATES = 0;
    set i = 0;    
    set tmps = ids;
	loplab: while length(tmps) > 0 do
		set count = length(tmps)-length(replace(tmps,'|',''));
		if count = 0 then 
			set id = tmps;
            select   `sbox_device_info`.`device_name`, `sbox_device_info`.`device_code` , `sbox_device_info`.`device_seed` ,`sbox_device_info`.`userid_seed` into  device_name ,device_code,device_seed , userid_seed from   `sbox_device_info`  where ( `sbox_device_info`.`id` =  id and  `sbox_device_info`.`user_id` = zid);    
			if  userid_seed is null then 
				leave loplab;
            end if ; 
			DELETE FROM  `sbox_device_info` WHERE (  `sbox_device_info`.`userid_seed` = userid_seed and `sbox_device_info`.`device_seed` = device_seed   );
			set device_name = null ;
			set device_code = null ;
			set device_seed = null ;
			set userid_seed = null ;
            leave loplab;
        elseif count > 0 then
			set id = SUBSTRING_INDEX(tmps,'|',1); 
            select id; 
            set tmps = RIGHT(tmps,length(tmps)-length(id)-1);
            select   `sbox_device_info`.`device_name`, `sbox_device_info`.`device_code` , `sbox_device_info`.`device_seed` ,`sbox_device_info`.`userid_seed`  into  device_name ,device_code,device_seed , userid_seed from   `sbox_device_info`  where ( `sbox_device_info`.`id` =  id and  `sbox_device_info`.`user_id` = zid  );    
			if  userid_seed is null then 
				iterate loplab;
			else   
				DELETE FROM  `sbox_device_info` WHERE ( `sbox_device_info`.`userid_seed` = userid_seed and `sbox_device_info`.`device_seed` = device_seed   );
				set device_name = null ;
				set device_code = null ;
				set device_seed = null ;
				set userid_seed = null ;
				if length(tmps) = 0 then
					leave loplab;
				end if;		
            end if ;                     	
		end if;    
    end while; 
    SET SQL_SAFE_UPDATES = 1;
   END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for `pus_str`
-- ----------------------------
DROP PROCEDURE IF EXISTS `pus_str`;
DELIMITER ;;
CREATE   PROCEDURE `pus_str`(in ids varchar(5000) ,  in master_id  int ,in zid int )
BEGIN
	
	DECLARE   device_name, device_code , device_seed ,userid_seed varchar(45);
    declare  tmps varchar(5000);
    declare  count int;
    declare  id varchar(20) ;
    declare  i  int default 0;
    set i = 0;    
    set tmps = ids;
	loplab: while length(tmps) > 0 do
		set count = length(tmps)-length(replace(tmps,'|',''));
		if count = 0 then 
			set id = tmps;
			select   `sbox_device_info`.`device_name`, `sbox_device_info`.`device_code` , `sbox_device_info`.`device_seed`  into  device_name ,device_code,device_seed  from   `sbox_device_info`  where ( `sbox_device_info`.`id` =  id and  `sbox_device_info`.`user_id` = master_id);    
			if  device_name is null then 
				leave loplab;
            end if ;
            set userid_seed = concat(zid,device_seed); 
            INSERT   INTO  `sbox_device_info` ( `user_id`, `device_name`, `device_code`, `device_seed` , `userid_seed`) VALUES (  zid ,    device_name,  device_code,   device_seed ,userid_seed); 
		    set device_name = null ;
            set device_code = null ;
            set device_seed = null ;
            set userid_seed = null ;
            leave loplab;
        elseif count > 0 then
			set id = SUBSTRING_INDEX(tmps,'|',1); 
            set tmps = RIGHT(tmps,length(tmps)-length(id)-1);
            select   `sbox_device_info`.`device_name`, `sbox_device_info`.`device_code` , `sbox_device_info`.`device_seed`  into  device_name ,device_code,device_seed  from   `sbox_device_info`  where ( `sbox_device_info`.`id` =  id and  `sbox_device_info`.`user_id` = master_id );    
			if  device_name is null then 
				iterate loplab;
			else 
				set userid_seed = concat(zid,device_seed); 
				INSERT   INTO  `sbox_device_info` ( `user_id`, `device_name`, `device_code`, `device_seed` , `userid_seed`) VALUES (  zid ,    device_name,  device_code,   device_seed ,userid_seed); 
				set device_name = null ;
				set device_code = null ;
				set device_seed = null ;
				set userid_seed = null ;
				if length(tmps) = 0 then
					leave loplab;
				end if;		
            end if ;          	
		end if;    
    end while;  
    
    
   END
;;
DELIMITER ;
