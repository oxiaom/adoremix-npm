/*
Navicat MySQL Data Transfer

Source Server         : 111
Source Server Version : 50714
Source Host           : localhost:3306
Source Database       : adore03

Target Server Type    : MYSQL
Target Server Version : 50714
File Encoding         : 65001

Date: 2023-01-12 17:46:06
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of group_seed
-- ----------------------------

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
  `node_id` int(11) NOT NULL DEFAULT '-1',
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
  PRIMARY KEY (`id`),
  UNIQUE KEY `userid_seed` (`userid_seed`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sbox_device_info
-- ----------------------------
INSERT INTO `sbox_device_info` VALUES ('17', '6', '-1', '-1', 'dGVzdDAzMQ==', '24774ce88d3c0a9222830a7fb8a05e1c', 'f765ee0c872ad630fc8609a207473b5f', '0', '2023-01-10 13:47:56', 'default', 'default', 'f765ee0c872ad630fc8609a207473b5f6', '-1', '-1', '1', '0', '_NONE.mp3', '_NONE.mp3', '2023-01-10 13:47:56', '116.40389220333873|39.91411461844903', '0', '0', '0', '0', '0');
INSERT INTO `sbox_device_info` VALUES ('18', '6', '-1', '-1', 'dGVzdDAzMQ==', '8db7cde1757665b458ae2abee7fc526d', '34e159ed9561cbb1d90a4f8c58125623', '0', '2023-01-10 13:48:32', 'default', 'default', '34e159ed9561cbb1d90a4f8c581256236', '-1', '-1', '1', '0', '_NONE.mp3', '_NONE.mp3', '2023-01-10 13:48:32', '116.40389220333873|39.91411461844903', '0', '0', '0', '0', '0');
INSERT INTO `sbox_device_info` VALUES ('19', '6', '-1', '-1', 'dGVzdDAzMQ==', '4e19f7da354704e93c65d91b29cfa6cc', 'e1530f1287cfbb086a8fa421ddcec600', '0', '2023-01-10 13:48:47', 'default', 'default', 'e1530f1287cfbb086a8fa421ddcec6006', '-1', '-1', '1', '0', '_NONE.mp3', '_NONE.mp3', '2023-01-10 13:48:47', '116.40389220333873|39.91411461844903', '0', '0', '0', '0', '0');

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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sbox_group
-- ----------------------------

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
INSERT INTO `sbox_node` VALUES ('1', '服务', '192.168.3.211', '3333', '6003', '6006', '6002', '6003', '1', 'none', '1', '0', '6004', '0');

-- ----------------------------
-- Table structure for `sbox_users`
-- ----------------------------
DROP TABLE IF EXISTS `sbox_users`;
CREATE TABLE `sbox_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_name` varchar(45) NOT NULL,
  `user_pass` varchar(45) NOT NULL,
  `user_type` int(11) NOT NULL DEFAULT '1',
  `user_level` int(11) NOT NULL DEFAULT '9',
  `play_level` int(11) NOT NULL DEFAULT '-1',
  `master_id` int(11) NOT NULL DEFAULT '-1',
  `ctime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` int(11) NOT NULL DEFAULT '0',
  `mask` varchar(100) NOT NULL DEFAULT '00000000000000000000000',
  `beizhu` varchar(2000) NOT NULL DEFAULT 'Tk9USElORw==',
  `dingshi` varchar(45) NOT NULL DEFAULT '1',
  `shangchuan` varchar(45) NOT NULL DEFAULT '1',
  `qianfei` varchar(45) NOT NULL DEFAULT '0',
  `jiankong` varchar(45) NOT NULL DEFAULT '1',
  `cdnpath` varchar(100) NOT NULL DEFAULT 'cdn.ployq.com/gsh',
  `token` varchar(200) NOT NULL DEFAULT 'none',
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`user_name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sbox_users
-- ----------------------------
INSERT INTO `sbox_users` VALUES ('6', 'oxiaom2', '123123123', '1', '9', '-1', '-1', '2022-11-21 00:12:47', '0', '00000000000000000000000', 'Tk9USElORw==', '1', '1', '0', '1', 'cdn.ployq.com/gsh', '7ae1466da5cbef4218ba93ca0fb522ae36cb252b');
INSERT INTO `sbox_users` VALUES ('7', 'oxiaom3', '123123123', '1', '9', '-1', '-1', '2023-01-09 14:07:20', '0', '00000000000000000000000', 'Tk9USElORw==', '1', '1', '0', '1', 'cdn.ployq.com/gsh', '09645a69a2c867fd0e822e290ddc1293653d3237');
INSERT INTO `sbox_users` VALUES ('8', 'oxiaom4', '123123123', '1', '9', '-1', '-1', '2023-01-11 12:36:43', '0', '00000000000000000000000', 'Tk9USElORw==', '1', '1', '0', '1', 'cdn.ployq.com/gsh', 'a090bc25f6f639c07c5372b95c6418438112e769');

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
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sharefiles
-- ----------------------------

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
  `week` int(11) NOT NULL DEFAULT '1111111',
  `kind` int(11) NOT NULL DEFAULT '1',
  `startdate` int(11) NOT NULL DEFAULT '0',
  `enddate` int(11) NOT NULL DEFAULT '0',
  `jiange` int(11) NOT NULL DEFAULT '0',
  `statu` int(11) NOT NULL DEFAULT '0',
  `groupid` int(11) NOT NULL DEFAULT '0',
  `fileids` varchar(6000) NOT NULL DEFAULT '0',
  `snids` varchar(6000) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of task
-- ----------------------------
INSERT INTO `task` VALUES ('4', '6', '46700', '@,', '1', '1800', '1', '1111111', '1', '0', '0', '2', '0', '0', '38', '17|18|19');

-- ----------------------------
-- Table structure for `taskfile`
-- ----------------------------
DROP TABLE IF EXISTS `taskfile`;
CREATE TABLE `taskfile` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `taskid` int(11) NOT NULL,
  `fileid` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=55 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of taskfile
-- ----------------------------
INSERT INTO `taskfile` VALUES ('54', '4', '38');

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of taskgroup
-- ----------------------------

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
) ENGINE=InnoDB AUTO_INCREMENT=308 DEFAULT CHARSET=utf8;

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

-- ----------------------------
-- Table structure for `taskseed`
-- ----------------------------
DROP TABLE IF EXISTS `taskseed`;
CREATE TABLE `taskseed` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `taskid` int(11) NOT NULL,
  `devseedid` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of taskseed
-- ----------------------------
INSERT INTO `taskseed` VALUES ('48', '4', '17');
INSERT INTO `taskseed` VALUES ('49', '4', '18');
INSERT INTO `taskseed` VALUES ('50', '4', '19');

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
  PRIMARY KEY (`id`),
  UNIQUE KEY `useridandurl` (`userid`,`url`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of userfile
-- ----------------------------
INSERT INTO `userfile` VALUES ('38', '6', 'U291bOOAgm1hbi1CZWF0IEl0IOWls+WjsOaKkuaDheeJiCBtauawuOWeguS4jeacvS5tcDM=', 'mp3/6/536f756ce380826d616e2d4265617420497420e5a5b3e5a3b0e68a92e68385e78988206d6ae6b0b8e59e82e4b88de69cbd2e6d7033.mp3T', '237', 'G:/QTpro/Adore_mix/etc/docroot/mp3/6/536f756ce380826d616e2d4265617420497420e5a5b3e5a3b0e68a92e68385e78988206d6ae6b0b8e59e82e4b88de69cbd2e6d7033.mp3T', '2023-01-09 19:05:25', '1', '-1', '1', '3760377');

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
  `url` varchar(300) NOT NULL DEFAULT 'none',
  `name` varchar(200) NOT NULL DEFAULT 'none',
  `userid` int(11) NOT NULL DEFAULT '1',
  `status` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of warningplant
-- ----------------------------

-- ----------------------------
-- Table structure for `warregister`
-- ----------------------------
DROP TABLE IF EXISTS `warregister`;
CREATE TABLE `warregister` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sn` varchar(32) NOT NULL DEFAULT 'sn',
  `kind` int(11) NOT NULL DEFAULT '0',
  `url` varchar(500) NOT NULL DEFAULT 'url',
  `devname` varchar(500) NOT NULL DEFAULT 'Device_name',
  `filename` varchar(500) NOT NULL DEFAULT 'File_Name',
  `userid` int(11) NOT NULL DEFAULT '0',
  `fb` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `only` (`sn`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of warregister
-- ----------------------------
