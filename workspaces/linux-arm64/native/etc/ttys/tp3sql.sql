/*
Navicat MySQL Data Transfer

Source Server         : 111
Source Server Version : 50714
Source Host           : localhost:3306
Source Database       : adore01

Target Server Type    : MYSQL
Target Server Version : 50714
File Encoding         : 65001

Date: 2023-01-12 17:44:31
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
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of group_seed
-- ----------------------------
INSERT INTO `group_seed` VALUES ('25', '2', '82a04a4e8389b605fc35adf3b6852e4c', '6', '282a04a4e8389b605fc35adf3b6852e4c', '10');
INSERT INTO `group_seed` VALUES ('26', '2', '7b7c80574db5f6d7d3b7e8e534c76a3a', '6', '27b7c80574db5f6d7d3b7e8e534c76a3a', '11');
INSERT INTO `group_seed` VALUES ('27', '2', 'ed024ae3ae6c6eceb2b94019b727be61', '6', '2ed024ae3ae6c6eceb2b94019b727be61', '12');

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
) ENGINE=InnoDB AUTO_INCREMENT=693 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of rizhi
-- ----------------------------
INSERT INTO `rizhi` VALUES ('1', '6', '167000678051815云平台定时任务 播放url：mp3/6/b2e2cad4.mp3T文件播放时长2', '1001', '-1', '2022-12-03 03:00:00');
INSERT INTO `rizhi` VALUES ('2', '6', '167000678051815云平台定时任务 播放url：mp3/6/b9c7bbd2bcb6d8bcd0a1c4ae2d4465636973696f6e73202020c7b0d7e0becdb0aec9cf20b3acd4dec5aec9f920bbbdd0d1c1cbced2b5c4c1e9bbea2e6d7033.mp3T文件播放时长236', '1001', '-1', '2022-12-03 03:00:12');
INSERT INTO `rizhi` VALUES ('3', '6', '167000678051815云平台定时任务 播放url：http://192.168.3.211:12080/mp3/6/b2e2cad4.mp3T文件播放时长2', '1001', '-1', '2022-12-03 03:04:40');
INSERT INTO `rizhi` VALUES ('4', '6', '167000678051815云平台定时任务 播放url：http://192.168.3.211:12080/mp3/6/b9c7bbd2bcb6d8bcd0a1c4ae2d4465636973696f6e73202020c7b0d7e0becdb0aec9cf20b3acd4dec5aec9f920bbbdd0d1c1cbced2b5c4c1e9bbea2e6d7033.mp3T文件播放时长236', '1001', '-1', '2022-12-03 03:04:52');
INSERT INTO `rizhi` VALUES ('5', '6', '167000678051815云平台定时任务 播放url：http://192.168.3.211:12080/mp3/6/4b6174652052757362792d4661726577656c6c2e6d7033.mp3T文件播放时长335', '1001', '-1', '2022-12-03 03:08:58');
INSERT INTO `rizhi` VALUES ('6', '6', '167000678051815云平台定时任务 停止命令已发送', '1001', '-1', '2022-12-03 03:14:43');
INSERT INTO `rizhi` VALUES ('7', '6', '167000678051815云平台定时任务:1670006780518正常播放结束', '1001', '-1', '2022-12-03 03:14:44');
INSERT INTO `rizhi` VALUES ('8', '6', '167000678051815云平台定时任务 播放url：http://192.168.3.211:12080/mp3/6/b2e2cad4.mp3T文件播放时长2', '1001', '-1', '2022-12-03 23:12:30');
INSERT INTO `rizhi` VALUES ('9', '6', '167000678051815云平台定时任务 播放url：http://192.168.3.211:12080/mp3/6/b9c7bbd2bcb6d8bcd0a1c4ae2d4465636973696f6e73202020c7b0d7e0becdb0aec9cf20b3acd4dec5aec9f920bbbdd0d1c1cbced2b5c4c1e9bbea2e6d7033.mp3T文件播放时长236', '1001', '-1', '2022-12-03 23:12:42');
INSERT INTO `rizhi` VALUES ('10', '6', '167000678051815云平台定时任务 播放url：http://192.168.3.211:12080/mp3/6/4b6174652052757362792d4661726577656c6c2e6d7033.mp3T文件播放时长335', '1001', '-1', '2022-12-03 23:16:48');
INSERT INTO `rizhi` VALUES ('11', '6', '167000678051815云平台定时任务 停止命令已发送', '1001', '-1', '2022-12-03 23:22:33');
INSERT INTO `rizhi` VALUES ('12', '6', '167000678051815云平台定时任务:1670006780518正常播放结束', '1001', '-1', '2022-12-03 23:22:33');
INSERT INTO `rizhi` VALUES ('13', '6', '167008646592127云平台定时任务 播放url：http://192.168.3.211:12080/mp3/6/b2e2cad4.mp3T文件播放时长2', '1001', '-1', '2022-12-04 01:01:10');
INSERT INTO `rizhi` VALUES ('14', '6', '167008646592127云平台定时任务 播放url：http://192.168.3.211:12080/mp3/6/b9c7bbd2bcb6d8bcd0a1c4ae2d4465636973696f6e73202020c7b0d7e0becdb0aec9cf20b3acd4dec5aec9f920bbbdd0d1c1cbced2b5c4c1e9bbea2e6d7033.mp3T文件播放时长236', '1001', '-1', '2022-12-04 01:01:22');
INSERT INTO `rizhi` VALUES ('15', '6', '167008646592127云平台定时任务 播放url：http://192.168.3.211:12080/mp3/6/b2e2cad4.mp3T文件播放时长2', '1001', '-1', '2022-12-04 01:06:00');
INSERT INTO `rizhi` VALUES ('16', '6', '167008646592127云平台定时任务 播放url：http://192.168.3.211:12080/mp3/6/b9c7bbd2bcb6d8bcd0a1c4ae2d4465636973696f6e73202020c7b0d7e0becdb0aec9cf20b3acd4dec5aec9f920bbbdd0d1c1cbced2b5c4c1e9bbea2e6d7033.mp3T文件播放时长236', '1001', '-1', '2022-12-04 01:06:12');
INSERT INTO `rizhi` VALUES ('17', '6', '167008646592127云平台定时任务 播放url：http://192.168.3.211:12080/mp3/6/4b6174652052757362792d4661726577656c6c2e6d7033.mp3T文件播放时长335', '1001', '-1', '2022-12-04 01:10:18');
INSERT INTO `rizhi` VALUES ('18', '6', '167008442136716云平台定时任务 播放url：http://192.168.3.211:12080/mp3/6/b2e2cad4.mp3T文件播放时长2', '1001', '-1', '2022-12-04 02:50:01');
INSERT INTO `rizhi` VALUES ('19', '6', '167008442454017云平台定时任务 播放url：http://192.168.3.211:12080/mp3/6/b2e2cad4.mp3T文件播放时长2', '1001', '-1', '2022-12-04 02:50:01');
INSERT INTO `rizhi` VALUES ('20', '6', '167008442578118云平台定时任务 播放url：http://192.168.3.211:12080/mp3/6/b2e2cad4.mp3T文件播放时长2', '1001', '-1', '2022-12-04 02:50:01');
INSERT INTO `rizhi` VALUES ('21', '6', '167008442887919云平台定时任务 播放url：http://192.168.3.211:12080/mp3/6/b2e2cad4.mp3T文件播放时长2', '1001', '-1', '2022-12-04 02:50:01');
INSERT INTO `rizhi` VALUES ('22', '6', '167008443005420云平台定时任务 播放url：http://192.168.3.211:12080/mp3/6/b2e2cad4.mp3T文件播放时长2', '1001', '-1', '2022-12-04 02:50:01');
INSERT INTO `rizhi` VALUES ('23', '6', '167008443118621云平台定时任务 播放url：http://192.168.3.211:12080/mp3/6/b2e2cad4.mp3T文件播放时长2', '1001', '-1', '2022-12-04 02:50:01');
INSERT INTO `rizhi` VALUES ('24', '6', '167008445243522云平台定时任务 播放url：http://192.168.3.211:12080/mp3/6/b2e2cad4.mp3T文件播放时长2', '1001', '-1', '2022-12-04 02:50:01');
INSERT INTO `rizhi` VALUES ('25', '6', '@,3云平台定时任务 播放url：http://192.168.3.211:12080/mp3/6/b9c7bbd2bcb6d8bcd0a1c4ae2d4465636973696f6e73202020c7b0d7e0becdb0aec9cf20b3acd4dec5aec9f920bbbdd0d1c1cbced2b5c4c1e9bbea2e6d7033.mp3T文件播放时长236', '1001', '-1', '2022-12-05 00:09:20');
INSERT INTO `rizhi` VALUES ('26', '6', '@,3云平台定时任务 停止命令已发送', '1001', '-1', '2022-12-05 00:10:20');
INSERT INTO `rizhi` VALUES ('27', '6', '@,3云平台定时任务 到点结束', '1001', '-1', '2022-12-05 00:10:20');
INSERT INTO `rizhi` VALUES ('28', '6', '@,3云平台定时任务 播放url：http://192.168.3.211:12080/mp3/6/b9c7bbd2bcb6d8bcd0a1c4ae2d4465636973696f6e73202020c7b0d7e0becdb0aec9cf20b3acd4dec5aec9f920bbbdd0d1c1cbced2b5c4c1e9bbea2e6d7033.mp3T文件播放时长236', '1001', '-1', '2022-12-05 00:12:20');
INSERT INTO `rizhi` VALUES ('29', '6', '@,3云平台定时任务 停止命令已发送', '1001', '-1', '2022-12-05 00:12:20');
INSERT INTO `rizhi` VALUES ('30', '6', '@,3云平台定时任务 到点结束', '1001', '-1', '2022-12-05 00:12:20');
INSERT INTO `rizhi` VALUES ('31', '6', '@,3云平台定时任务 播放url：http://192.168.3.211:12080/mp3/6/b9c7bbd2bcb6d8bcd0a1c4ae2d4465636973696f6e73202020c7b0d7e0becdb0aec9cf20b3acd4dec5aec9f920bbbdd0d1c1cbced2b5c4c1e9bbea2e6d7033.mp3T文件播放时长236', '1001', '-1', '2022-12-05 00:29:20');
INSERT INTO `rizhi` VALUES ('32', '6', '@,3云平台定时任务 播放url：http://192.168.3.211:12080/mp3/6/4b6174652052757362792d4661726577656c6c2e6d7033.mp3T文件播放时长335', '1001', '-1', '2022-12-05 00:33:27');
INSERT INTO `rizhi` VALUES ('33', '6', '@,3云平台定时任务 播放url：http://192.168.3.211:12080/mp3/6/536f756ca1a36d616e2d4265617420497420c5aec9f9cae3c7e9b0e6206d6ad3c0b4b9b2bbd0e02e6d7033.mp3T文件播放时长237', '1001', '-1', '2022-12-05 00:42:20');
INSERT INTO `rizhi` VALUES ('34', '6', '@,3云平台定时任务 播放url：http://192.168.3.211:12080/mp3/6/4b6174652052757362792d4661726577656c6c2e6d7033.mp3T文件播放时长335', '1001', '-1', '2022-12-05 00:46:28');
INSERT INTO `rizhi` VALUES ('35', '6', '@,3云平台定时任务 播放url：http://192.168.3.211:12080/mp3/6/536f756ca1a36d616e2d4265617420497420c5aec9f9cae3c7e9b0e6206d6ad3c0b4b9b2bbd0e02e6d7033.mp3T文件播放时长237', '1001', '-1', '2022-12-05 00:52:14');
INSERT INTO `rizhi` VALUES ('36', '6', '@,3云平台定时任务 播放url：http://192.168.3.211:12080/mp3/6/4b6174652052757362792d4661726577656c6c2e6d7033.mp3T文件播放时长335', '1001', '-1', '2022-12-05 00:56:23');
INSERT INTO `rizhi` VALUES ('37', '6', '@,3云平台定时任务 播放url：http://192.168.3.211:12080/mp3/6/536f756ca1a36d616e2d4265617420497420c5aec9f9cae3c7e9b0e6206d6ad3c0b4b9b2bbd0e02e6d7033.mp3T文件播放时长237', '1001', '-1', '2022-12-05 01:02:09');
INSERT INTO `rizhi` VALUES ('38', '6', '@,3云平台定时任务 停止命令已发送', '1001', '-1', '2022-12-05 01:02:20');
INSERT INTO `rizhi` VALUES ('39', '6', '@,3云平台定时任务 到点结束', '1001', '-1', '2022-12-05 01:02:20');
INSERT INTO `rizhi` VALUES ('40', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 01:55:44');
INSERT INTO `rizhi` VALUES ('41', '6', 'taskname3云平台定时任务 播放url：http://192.168.3.211:12080/mp3/6/536f756ca1a36d616e2d4265617420497420c5aec9f9cae3c7e9b0e6206d6ad3c0b4b9b2bbd0e02e6d7033.mp3T文件播放时长237', '1001', '-1', '2022-12-05 01:55:44');
INSERT INTO `rizhi` VALUES ('42', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 02:02:02');
INSERT INTO `rizhi` VALUES ('43', '6', 'taskname3云平台定时任务 播放url：http://192.168.3.211:12080/mp3/6/536f756ca1a36d616e2d4265617420497420c5aec9f9cae3c7e9b0e6206d6ad3c0b4b9b2bbd0e02e6d7033.mp3T文件播放时长237', '1001', '-1', '2022-12-05 02:02:03');
INSERT INTO `rizhi` VALUES ('44', '6', 'taskname3云平台定时任务 停止命令已发送', '1001', '-1', '2022-12-05 02:02:12');
INSERT INTO `rizhi` VALUES ('45', '6', 'taskname3云平台定时任务 到点结束', '1001', '-1', '2022-12-05 02:02:13');
INSERT INTO `rizhi` VALUES ('46', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 02:02:27');
INSERT INTO `rizhi` VALUES ('47', '6', 'taskname3云平台定时任务 播放url：http://192.168.3.211:12080/mp3/6/536f756ca1a36d616e2d4265617420497420c5aec9f9cae3c7e9b0e6206d6ad3c0b4b9b2bbd0e02e6d7033.mp3T文件播放时长237', '1001', '-1', '2022-12-05 02:02:27');
INSERT INTO `rizhi` VALUES ('48', '6', 'taskname3云平台定时任务 停止命令已发送', '1001', '-1', '2022-12-05 02:02:33');
INSERT INTO `rizhi` VALUES ('49', '6', 'taskname3云平台定时任务 到点结束', '1001', '-1', '2022-12-05 02:02:33');
INSERT INTO `rizhi` VALUES ('50', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 02:03:51');
INSERT INTO `rizhi` VALUES ('51', '6', 'taskname3云平台定时任务 播放url：http://192.168.3.211:12080/mp3/6/536f756ca1a36d616e2d4265617420497420c5aec9f9cae3c7e9b0e6206d6ad3c0b4b9b2bbd0e02e6d7033.mp3T文件播放时长237', '1001', '-1', '2022-12-05 02:03:52');
INSERT INTO `rizhi` VALUES ('52', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 02:04:00');
INSERT INTO `rizhi` VALUES ('53', '6', 'taskname3云平台定时任务 停止命令已发送', '1001', '-1', '2022-12-05 02:04:06');
INSERT INTO `rizhi` VALUES ('54', '6', 'taskname3云平台定时任务 到点结束', '1001', '-1', '2022-12-05 02:04:06');
INSERT INTO `rizhi` VALUES ('55', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 02:09:27');
INSERT INTO `rizhi` VALUES ('56', '6', 'taskname3云平台定时任务 播放url：http://192.168.3.211:12080/mp3/6/536f756ca1a36d616e2d4265617420497420c5aec9f9cae3c7e9b0e6206d6ad3c0b4b9b2bbd0e02e6d7033.mp3T文件播放时长237', '1001', '-1', '2022-12-05 02:09:27');
INSERT INTO `rizhi` VALUES ('57', '6', 'taskname3云平台定时任务 停止命令已发送', '1001', '-1', '2022-12-05 02:09:32');
INSERT INTO `rizhi` VALUES ('58', '6', 'taskname3云平台定时任务 到点结束', '1001', '-1', '2022-12-05 02:09:32');
INSERT INTO `rizhi` VALUES ('59', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 02:10:30');
INSERT INTO `rizhi` VALUES ('60', '6', 'taskname3云平台定时任务 播放url：http://192.168.3.211:12080/mp3/6/536f756ca1a36d616e2d4265617420497420c5aec9f9cae3c7e9b0e6206d6ad3c0b4b9b2bbd0e02e6d7033.mp3T文件播放时长237', '1001', '-1', '2022-12-05 02:10:30');
INSERT INTO `rizhi` VALUES ('61', '6', 'taskname3云平台定时任务 停止命令已发送', '1001', '-1', '2022-12-05 02:10:34');
INSERT INTO `rizhi` VALUES ('62', '6', 'taskname3云平台定时任务 到点结束', '1001', '-1', '2022-12-05 02:10:34');
INSERT INTO `rizhi` VALUES ('63', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 02:12:15');
INSERT INTO `rizhi` VALUES ('64', '6', 'taskname3云平台定时任务 播放url：http://192.168.3.211:12080/mp3/6/536f756ca1a36d616e2d4265617420497420c5aec9f9cae3c7e9b0e6206d6ad3c0b4b9b2bbd0e02e6d7033.mp3T文件播放时长237', '1001', '-1', '2022-12-05 02:12:15');
INSERT INTO `rizhi` VALUES ('65', '6', 'taskname3云平台定时任务 停止命令已发送', '1001', '-1', '2022-12-05 02:12:18');
INSERT INTO `rizhi` VALUES ('66', '6', 'taskname3云平台定时任务 到点结束', '1001', '-1', '2022-12-05 02:12:18');
INSERT INTO `rizhi` VALUES ('67', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 02:14:45');
INSERT INTO `rizhi` VALUES ('68', '6', 'taskname3云平台定时任务 播放url：http://192.168.3.211:12080/mp3/6/536f756ca1a36d616e2d4265617420497420c5aec9f9cae3c7e9b0e6206d6ad3c0b4b9b2bbd0e02e6d7033.mp3T文件播放时长237', '1001', '-1', '2022-12-05 02:14:45');
INSERT INTO `rizhi` VALUES ('69', '6', 'taskname3云平台定时任务 停止命令已发送', '1001', '-1', '2022-12-05 02:14:51');
INSERT INTO `rizhi` VALUES ('70', '6', 'taskname3云平台定时任务 到点结束', '1001', '-1', '2022-12-05 02:14:51');
INSERT INTO `rizhi` VALUES ('71', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 02:16:19');
INSERT INTO `rizhi` VALUES ('72', '6', 'taskname3云平台定时任务 播放url：http://192.168.3.211:12080/mp3/6/536f756ca1a36d616e2d4265617420497420c5aec9f9cae3c7e9b0e6206d6ad3c0b4b9b2bbd0e02e6d7033.mp3T文件播放时长237', '1001', '-1', '2022-12-05 02:16:19');
INSERT INTO `rizhi` VALUES ('73', '6', 'taskname3云平台定时任务 停止命令已发送', '1001', '-1', '2022-12-05 02:16:29');
INSERT INTO `rizhi` VALUES ('74', '6', 'taskname3云平台定时任务 到点结束', '1001', '-1', '2022-12-05 02:16:29');
INSERT INTO `rizhi` VALUES ('75', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 02:16:38');
INSERT INTO `rizhi` VALUES ('76', '6', 'taskname3云平台定时任务 播放url：http://192.168.3.211:12080/mp3/6/536f756ca1a36d616e2d4265617420497420c5aec9f9cae3c7e9b0e6206d6ad3c0b4b9b2bbd0e02e6d7033.mp3T文件播放时长237', '1001', '-1', '2022-12-05 02:16:38');
INSERT INTO `rizhi` VALUES ('77', '6', 'taskname3云平台定时任务 停止命令已发送', '1001', '-1', '2022-12-05 02:16:42');
INSERT INTO `rizhi` VALUES ('78', '6', 'taskname3云平台定时任务 到点结束', '1001', '-1', '2022-12-05 02:16:42');
INSERT INTO `rizhi` VALUES ('79', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 02:25:45');
INSERT INTO `rizhi` VALUES ('80', '6', 'taskname3云平台定时任务 播放url：http://192.168.3.211:12080/mp3/6/536f756ca1a36d616e2d4265617420497420c5aec9f9cae3c7e9b0e6206d6ad3c0b4b9b2bbd0e02e6d7033.mp3T文件播放时长237', '1001', '-1', '2022-12-05 02:25:45');
INSERT INTO `rizhi` VALUES ('81', '6', 'taskname3云平台定时任务 停止命令已发送', '1001', '-1', '2022-12-05 02:25:51');
INSERT INTO `rizhi` VALUES ('82', '6', 'taskname3云平台定时任务 到点结束', '1001', '-1', '2022-12-05 02:25:51');
INSERT INTO `rizhi` VALUES ('83', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 02:25:57');
INSERT INTO `rizhi` VALUES ('84', '6', 'taskname3云平台定时任务 播放url：http://192.168.3.211:12080/mp3/6/536f756ca1a36d616e2d4265617420497420c5aec9f9cae3c7e9b0e6206d6ad3c0b4b9b2bbd0e02e6d7033.mp3T文件播放时长237', '1001', '-1', '2022-12-05 02:25:57');
INSERT INTO `rizhi` VALUES ('85', '6', 'taskname3云平台定时任务 停止命令已发送', '1001', '-1', '2022-12-05 02:26:03');
INSERT INTO `rizhi` VALUES ('86', '6', 'taskname3云平台定时任务 到点结束', '1001', '-1', '2022-12-05 02:26:03');
INSERT INTO `rizhi` VALUES ('87', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 02:26:52');
INSERT INTO `rizhi` VALUES ('88', '6', 'taskname3云平台定时任务 播放url：http://192.168.3.211:12080/mp3/6/536f756ca1a36d616e2d4265617420497420c5aec9f9cae3c7e9b0e6206d6ad3c0b4b9b2bbd0e02e6d7033.mp3T文件播放时长237', '1001', '-1', '2022-12-05 02:26:52');
INSERT INTO `rizhi` VALUES ('89', '6', 'taskname3云平台定时任务 停止命令已发送', '1001', '-1', '2022-12-05 02:27:26');
INSERT INTO `rizhi` VALUES ('90', '6', 'taskname3云平台定时任务 到点结束', '1001', '-1', '2022-12-05 02:27:26');
INSERT INTO `rizhi` VALUES ('91', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 02:29:24');
INSERT INTO `rizhi` VALUES ('92', '6', 'taskname3云平台定时任务 播放url：http://192.168.3.211:12080/mp3/6/536f756ca1a36d616e2d4265617420497420c5aec9f9cae3c7e9b0e6206d6ad3c0b4b9b2bbd0e02e6d7033.mp3T文件播放时长237', '1001', '-1', '2022-12-05 02:29:24');
INSERT INTO `rizhi` VALUES ('93', '6', 'taskname3云平台定时任务 到点结束', '1001', '-1', '2022-12-05 02:29:29');
INSERT INTO `rizhi` VALUES ('94', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 02:31:46');
INSERT INTO `rizhi` VALUES ('95', '6', 'taskname3云平台定时任务 播放url：http://192.168.3.211:12080/mp3/6/536f756ca1a36d616e2d4265617420497420c5aec9f9cae3c7e9b0e6206d6ad3c0b4b9b2bbd0e02e6d7033.mp3T文件播放时长237', '1001', '-1', '2022-12-05 02:31:46');
INSERT INTO `rizhi` VALUES ('96', '6', 'taskname3云平台定时任务 到点结束', '1001', '-1', '2022-12-05 02:32:00');
INSERT INTO `rizhi` VALUES ('97', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 02:33:26');
INSERT INTO `rizhi` VALUES ('98', '6', 'taskname3云平台定时任务 播放url：http://192.168.3.211:12080/mp3/6/536f756ca1a36d616e2d4265617420497420c5aec9f9cae3c7e9b0e6206d6ad3c0b4b9b2bbd0e02e6d7033.mp3T文件播放时长237', '1001', '-1', '2022-12-05 02:33:26');
INSERT INTO `rizhi` VALUES ('99', '6', 'taskname3云平台定时任务 停止命令已发送', '1001', '-1', '2022-12-05 02:33:32');
INSERT INTO `rizhi` VALUES ('100', '6', 'taskname3云平台定时任务 到点结束', '1001', '-1', '2022-12-05 02:33:32');
INSERT INTO `rizhi` VALUES ('101', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 02:37:37');
INSERT INTO `rizhi` VALUES ('102', '6', 'taskname3云平台定时任务 播放url：http://192.168.3.211:12080/mp3/6/536f756ca1a36d616e2d4265617420497420c5aec9f9cae3c7e9b0e6206d6ad3c0b4b9b2bbd0e02e6d7033.mp3T文件播放时长237', '1001', '-1', '2022-12-05 02:37:37');
INSERT INTO `rizhi` VALUES ('103', '6', 'taskname3云平台定时任务 停止命令已发送', '1001', '-1', '2022-12-05 02:37:42');
INSERT INTO `rizhi` VALUES ('104', '6', 'taskname3云平台定时任务 到点结束', '1001', '-1', '2022-12-05 02:37:42');
INSERT INTO `rizhi` VALUES ('105', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 02:43:13');
INSERT INTO `rizhi` VALUES ('106', '6', 'taskname3云平台定时任务 播放url：http://192.168.3.211:12080/mp3/6/536f756ca1a36d616e2d4265617420497420c5aec9f9cae3c7e9b0e6206d6ad3c0b4b9b2bbd0e02e6d7033.mp3T文件播放时长237', '1001', '-1', '2022-12-05 02:43:13');
INSERT INTO `rizhi` VALUES ('107', '6', 'taskname3云平台定时任务 停止命令已发送', '1001', '-1', '2022-12-05 02:43:16');
INSERT INTO `rizhi` VALUES ('108', '6', 'taskname3云平台定时任务 到点结束', '1001', '-1', '2022-12-05 02:43:16');
INSERT INTO `rizhi` VALUES ('109', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 02:44:49');
INSERT INTO `rizhi` VALUES ('110', '6', 'taskname3云平台定时任务 播放url：http://192.168.3.211:12080/mp3/6/536f756ca1a36d616e2d4265617420497420c5aec9f9cae3c7e9b0e6206d6ad3c0b4b9b2bbd0e02e6d7033.mp3T文件播放时长237', '1001', '-1', '2022-12-05 02:44:49');
INSERT INTO `rizhi` VALUES ('111', '6', 'taskname3云平台定时任务 停止命令已发送', '1001', '-1', '2022-12-05 02:44:56');
INSERT INTO `rizhi` VALUES ('112', '6', 'taskname3云平台定时任务 到点结束', '1001', '-1', '2022-12-05 02:44:56');
INSERT INTO `rizhi` VALUES ('113', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 02:45:51');
INSERT INTO `rizhi` VALUES ('114', '6', 'taskname3云平台定时任务 播放url：http://192.168.3.211:12080/mp3/6/536f756ca1a36d616e2d4265617420497420c5aec9f9cae3c7e9b0e6206d6ad3c0b4b9b2bbd0e02e6d7033.mp3T文件播放时长237', '1001', '-1', '2022-12-05 02:45:51');
INSERT INTO `rizhi` VALUES ('115', '6', 'taskname3云平台定时任务 停止命令已发送', '1001', '-1', '2022-12-05 02:45:59');
INSERT INTO `rizhi` VALUES ('116', '6', 'taskname3云平台定时任务 到点结束', '1001', '-1', '2022-12-05 02:45:59');
INSERT INTO `rizhi` VALUES ('117', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 02:48:47');
INSERT INTO `rizhi` VALUES ('118', '6', 'taskname3云平台定时任务 播放url：http://192.168.3.211:12080/mp3/6/536f756ca1a36d616e2d4265617420497420c5aec9f9cae3c7e9b0e6206d6ad3c0b4b9b2bbd0e02e6d7033.mp3T文件播放时长237', '1001', '-1', '2022-12-05 02:48:47');
INSERT INTO `rizhi` VALUES ('119', '6', 'taskname3云平台定时任务 停止命令已发送', '1001', '-1', '2022-12-05 02:48:53');
INSERT INTO `rizhi` VALUES ('120', '6', 'taskname3云平台定时任务 到点结束', '1001', '-1', '2022-12-05 02:48:53');
INSERT INTO `rizhi` VALUES ('121', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 02:52:47');
INSERT INTO `rizhi` VALUES ('122', '6', 'taskname3云平台定时任务 播放url：http://192.168.3.211:12080/mp3/6/536f756ca1a36d616e2d4265617420497420c5aec9f9cae3c7e9b0e6206d6ad3c0b4b9b2bbd0e02e6d7033.mp3T文件播放时长237', '1001', '-1', '2022-12-05 02:52:47');
INSERT INTO `rizhi` VALUES ('123', '6', 'taskname3云平台定时任务 停止命令已发送', '1001', '-1', '2022-12-05 02:52:51');
INSERT INTO `rizhi` VALUES ('124', '6', 'taskname3云平台定时任务 到点结束', '1001', '-1', '2022-12-05 02:52:51');
INSERT INTO `rizhi` VALUES ('125', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 02:52:56');
INSERT INTO `rizhi` VALUES ('126', '6', 'taskname3云平台定时任务 播放url：http://192.168.3.211:12080/mp3/6/536f756ca1a36d616e2d4265617420497420c5aec9f9cae3c7e9b0e6206d6ad3c0b4b9b2bbd0e02e6d7033.mp3T文件播放时长237', '1001', '-1', '2022-12-05 02:52:56');
INSERT INTO `rizhi` VALUES ('127', '6', 'taskname3云平台定时任务 停止命令已发送', '1001', '-1', '2022-12-05 02:53:00');
INSERT INTO `rizhi` VALUES ('128', '6', 'taskname3云平台定时任务 到点结束', '1001', '-1', '2022-12-05 02:53:00');
INSERT INTO `rizhi` VALUES ('129', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 02:55:17');
INSERT INTO `rizhi` VALUES ('130', '6', 'taskname3云平台定时任务 播放url：http://192.168.3.211:12080/mp3/6/536f756ca1a36d616e2d4265617420497420c5aec9f9cae3c7e9b0e6206d6ad3c0b4b9b2bbd0e02e6d7033.mp3T文件播放时长237', '1001', '-1', '2022-12-05 02:55:18');
INSERT INTO `rizhi` VALUES ('131', '6', 'taskname3云平台定时任务 停止命令已发送', '1001', '-1', '2022-12-05 02:55:29');
INSERT INTO `rizhi` VALUES ('132', '6', 'taskname3云平台定时任务 到点结束', '1001', '-1', '2022-12-05 02:55:29');
INSERT INTO `rizhi` VALUES ('133', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 02:58:28');
INSERT INTO `rizhi` VALUES ('134', '6', 'taskname3云平台定时任务 播放url：http://192.168.3.211:12080/mp3/6/536f756ca1a36d616e2d4265617420497420c5aec9f9cae3c7e9b0e6206d6ad3c0b4b9b2bbd0e02e6d7033.mp3T文件播放时长237', '1001', '-1', '2022-12-05 02:58:28');
INSERT INTO `rizhi` VALUES ('135', '6', 'taskname3云平台定时任务 停止命令已发送', '1001', '-1', '2022-12-05 02:58:32');
INSERT INTO `rizhi` VALUES ('136', '6', 'taskname3云平台定时任务 到点结束', '1001', '-1', '2022-12-05 02:58:32');
INSERT INTO `rizhi` VALUES ('137', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 03:03:03');
INSERT INTO `rizhi` VALUES ('138', '6', 'taskname3云平台定时任务 播放url：http://192.168.3.211:12080/mp3/6/536f756ca1a36d616e2d4265617420497420c5aec9f9cae3c7e9b0e6206d6ad3c0b4b9b2bbd0e02e6d7033.mp3T文件播放时长237', '1001', '-1', '2022-12-05 03:03:03');
INSERT INTO `rizhi` VALUES ('139', '6', 'taskname3云平台定时任务 停止命令已发送', '1001', '-1', '2022-12-05 03:03:11');
INSERT INTO `rizhi` VALUES ('140', '6', 'taskname3云平台定时任务 到点结束', '1001', '-1', '2022-12-05 03:03:11');
INSERT INTO `rizhi` VALUES ('141', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 03:06:10');
INSERT INTO `rizhi` VALUES ('142', '6', 'taskname3云平台定时任务 播放url：http://192.168.3.211:12080/mp3/6/536f756ca1a36d616e2d4265617420497420c5aec9f9cae3c7e9b0e6206d6ad3c0b4b9b2bbd0e02e6d7033.mp3T文件播放时长237', '1001', '-1', '2022-12-05 03:06:10');
INSERT INTO `rizhi` VALUES ('143', '6', 'taskname3云平台定时任务 停止命令已发送', '1001', '-1', '2022-12-05 03:06:16');
INSERT INTO `rizhi` VALUES ('144', '6', 'taskname3云平台定时任务 到点结束', '1001', '-1', '2022-12-05 03:06:16');
INSERT INTO `rizhi` VALUES ('145', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 03:07:06');
INSERT INTO `rizhi` VALUES ('146', '6', 'taskname3云平台定时任务 播放url：http://192.168.3.211:12080/mp3/6/536f756ca1a36d616e2d4265617420497420c5aec9f9cae3c7e9b0e6206d6ad3c0b4b9b2bbd0e02e6d7033.mp3T文件播放时长237', '1001', '-1', '2022-12-05 03:07:06');
INSERT INTO `rizhi` VALUES ('147', '6', 'taskname3云平台定时任务 停止命令已发送', '1001', '-1', '2022-12-05 03:07:13');
INSERT INTO `rizhi` VALUES ('148', '6', 'taskname3云平台定时任务 到点结束', '1001', '-1', '2022-12-05 03:07:13');
INSERT INTO `rizhi` VALUES ('149', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 03:17:07');
INSERT INTO `rizhi` VALUES ('150', '6', 'taskname3云平台定时任务 播放url：http://192.168.3.211:12080/mp3/6/536f756ca1a36d616e2d4265617420497420c5aec9f9cae3c7e9b0e6206d6ad3c0b4b9b2bbd0e02e6d7033.mp3T文件播放时长237', '1001', '-1', '2022-12-05 03:17:07');
INSERT INTO `rizhi` VALUES ('151', '6', 'taskname3云平台定时任务 停止命令已发送', '1001', '-1', '2022-12-05 03:17:13');
INSERT INTO `rizhi` VALUES ('152', '6', 'taskname3云平台定时任务 到点结束', '1001', '-1', '2022-12-05 03:17:13');
INSERT INTO `rizhi` VALUES ('153', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 03:18:29');
INSERT INTO `rizhi` VALUES ('154', '6', 'taskname3云平台定时任务 播放url：http://192.168.3.211:12080/mp3/6/536f756ca1a36d616e2d4265617420497420c5aec9f9cae3c7e9b0e6206d6ad3c0b4b9b2bbd0e02e6d7033.mp3T文件播放时长237', '1001', '-1', '2022-12-05 03:18:29');
INSERT INTO `rizhi` VALUES ('155', '6', 'taskname3云平台定时任务 停止命令已发送', '1001', '-1', '2022-12-05 03:18:36');
INSERT INTO `rizhi` VALUES ('156', '6', 'taskname3云平台定时任务 到点结束', '1001', '-1', '2022-12-05 03:18:36');
INSERT INTO `rizhi` VALUES ('157', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 03:21:31');
INSERT INTO `rizhi` VALUES ('158', '6', 'taskname3云平台定时任务 播放url：http://192.168.3.211:12080/mp3/6/536f756ca1a36d616e2d4265617420497420c5aec9f9cae3c7e9b0e6206d6ad3c0b4b9b2bbd0e02e6d7033.mp3T文件播放时长237', '1001', '-1', '2022-12-05 03:21:31');
INSERT INTO `rizhi` VALUES ('159', '6', 'taskname3云平台定时任务 停止命令已发送', '1001', '-1', '2022-12-05 03:21:34');
INSERT INTO `rizhi` VALUES ('160', '6', 'taskname3云平台定时任务 到点结束', '1001', '-1', '2022-12-05 03:21:34');
INSERT INTO `rizhi` VALUES ('161', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 03:24:25');
INSERT INTO `rizhi` VALUES ('162', '6', 'taskname3云平台定时任务 播放url：http://192.168.3.211:12080/mp3/6/536f756ca1a36d616e2d4265617420497420c5aec9f9cae3c7e9b0e6206d6ad3c0b4b9b2bbd0e02e6d7033.mp3T文件播放时长237', '1001', '-1', '2022-12-05 03:24:25');
INSERT INTO `rizhi` VALUES ('163', '6', 'taskname3云平台定时任务 停止命令已发送', '1001', '-1', '2022-12-05 03:24:28');
INSERT INTO `rizhi` VALUES ('164', '6', 'taskname3云平台定时任务 到点结束', '1001', '-1', '2022-12-05 03:24:28');
INSERT INTO `rizhi` VALUES ('165', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 03:25:43');
INSERT INTO `rizhi` VALUES ('166', '6', 'taskname3云平台定时任务 播放url：http://192.168.3.211:12080/mp3/6/536f756ca1a36d616e2d4265617420497420c5aec9f9cae3c7e9b0e6206d6ad3c0b4b9b2bbd0e02e6d7033.mp3T文件播放时长237', '1001', '-1', '2022-12-05 03:25:43');
INSERT INTO `rizhi` VALUES ('167', '6', 'taskname3云平台定时任务 停止命令已发送', '1001', '-1', '2022-12-05 03:25:46');
INSERT INTO `rizhi` VALUES ('168', '6', 'taskname3云平台定时任务 到点结束', '1001', '-1', '2022-12-05 03:25:46');
INSERT INTO `rizhi` VALUES ('169', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 03:26:18');
INSERT INTO `rizhi` VALUES ('170', '6', 'taskname3云平台定时任务 播放url：http://192.168.3.211:12080/mp3/6/536f756ca1a36d616e2d4265617420497420c5aec9f9cae3c7e9b0e6206d6ad3c0b4b9b2bbd0e02e6d7033.mp3T文件播放时长237', '1001', '-1', '2022-12-05 03:26:18');
INSERT INTO `rizhi` VALUES ('171', '6', 'taskname3云平台定时任务 停止命令已发送', '1001', '-1', '2022-12-05 03:26:27');
INSERT INTO `rizhi` VALUES ('172', '6', 'taskname3云平台定时任务 到点结束', '1001', '-1', '2022-12-05 03:26:27');
INSERT INTO `rizhi` VALUES ('173', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 03:26:38');
INSERT INTO `rizhi` VALUES ('174', '6', 'taskname3云平台定时任务 播放url：http://192.168.3.211:12080/mp3/6/536f756ca1a36d616e2d4265617420497420c5aec9f9cae3c7e9b0e6206d6ad3c0b4b9b2bbd0e02e6d7033.mp3T文件播放时长237', '1001', '-1', '2022-12-05 03:26:38');
INSERT INTO `rizhi` VALUES ('175', '6', 'taskname3云平台定时任务 停止命令已发送', '1001', '-1', '2022-12-05 03:26:43');
INSERT INTO `rizhi` VALUES ('176', '6', 'taskname3云平台定时任务 到点结束', '1001', '-1', '2022-12-05 03:26:43');
INSERT INTO `rizhi` VALUES ('177', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 03:34:59');
INSERT INTO `rizhi` VALUES ('178', '6', 'taskname3云平台定时任务 播放url：http://192.168.3.211:12080/mp3/6/536f756ca1a36d616e2d4265617420497420c5aec9f9cae3c7e9b0e6206d6ad3c0b4b9b2bbd0e02e6d7033.mp3T文件播放时长237', '1001', '-1', '2022-12-05 03:34:59');
INSERT INTO `rizhi` VALUES ('179', '6', 'taskname3云平台定时任务 停止命令已发送', '1001', '-1', '2022-12-05 03:35:05');
INSERT INTO `rizhi` VALUES ('180', '6', 'taskname3云平台定时任务 到点结束', '1001', '-1', '2022-12-05 03:35:05');
INSERT INTO `rizhi` VALUES ('181', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 03:36:28');
INSERT INTO `rizhi` VALUES ('182', '6', 'taskname3云平台定时任务 播放url：http://192.168.3.211:12080/mp3/6/536f756ca1a36d616e2d4265617420497420c5aec9f9cae3c7e9b0e6206d6ad3c0b4b9b2bbd0e02e6d7033.mp3T文件播放时长237', '1001', '-1', '2022-12-05 03:36:28');
INSERT INTO `rizhi` VALUES ('183', '6', 'taskname3云平台定时任务 停止命令已发送', '1001', '-1', '2022-12-05 03:36:32');
INSERT INTO `rizhi` VALUES ('184', '6', 'taskname3云平台定时任务 到点结束', '1001', '-1', '2022-12-05 03:36:32');
INSERT INTO `rizhi` VALUES ('185', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 03:45:08');
INSERT INTO `rizhi` VALUES ('186', '6', 'taskname3云平台定时任务 播放url：http://192.168.3.211:12080/mp3/6/536f756ca1a36d616e2d4265617420497420c5aec9f9cae3c7e9b0e6206d6ad3c0b4b9b2bbd0e02e6d7033.mp3T文件播放时长237', '1001', '-1', '2022-12-05 03:45:08');
INSERT INTO `rizhi` VALUES ('187', '6', 'taskname3云平台定时任务 停止命令已发送', '1001', '-1', '2022-12-05 03:45:12');
INSERT INTO `rizhi` VALUES ('188', '6', 'taskname3云平台定时任务 到点结束', '1001', '-1', '2022-12-05 03:45:12');
INSERT INTO `rizhi` VALUES ('189', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 03:45:24');
INSERT INTO `rizhi` VALUES ('190', '6', 'taskname3云平台定时任务 播放url：http://192.168.3.211:12080/mp3/6/536f756ca1a36d616e2d4265617420497420c5aec9f9cae3c7e9b0e6206d6ad3c0b4b9b2bbd0e02e6d7033.mp3T文件播放时长237', '1001', '-1', '2022-12-05 03:45:25');
INSERT INTO `rizhi` VALUES ('191', '6', 'taskname3云平台定时任务 停止命令已发送', '1001', '-1', '2022-12-05 03:45:28');
INSERT INTO `rizhi` VALUES ('192', '6', 'taskname3云平台定时任务 到点结束', '1001', '-1', '2022-12-05 03:45:28');
INSERT INTO `rizhi` VALUES ('193', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 03:48:43');
INSERT INTO `rizhi` VALUES ('194', '6', 'taskname3云平台定时任务 播放url：http://192.168.3.211:12080/mp3/6/536f756ca1a36d616e2d4265617420497420c5aec9f9cae3c7e9b0e6206d6ad3c0b4b9b2bbd0e02e6d7033.mp3T文件播放时长237', '1001', '-1', '2022-12-05 03:48:43');
INSERT INTO `rizhi` VALUES ('195', '6', 'taskname3云平台定时任务 停止命令已发送', '1001', '-1', '2022-12-05 03:48:48');
INSERT INTO `rizhi` VALUES ('196', '6', 'taskname3云平台定时任务 到点结束', '1001', '-1', '2022-12-05 03:48:48');
INSERT INTO `rizhi` VALUES ('197', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 03:49:10');
INSERT INTO `rizhi` VALUES ('198', '6', 'taskname3云平台定时任务 播放url：http://192.168.3.211:12080/mp3/6/536f756ca1a36d616e2d4265617420497420c5aec9f9cae3c7e9b0e6206d6ad3c0b4b9b2bbd0e02e6d7033.mp3T文件播放时长237', '1001', '-1', '2022-12-05 03:49:10');
INSERT INTO `rizhi` VALUES ('199', '6', 'taskname3云平台定时任务 停止命令已发送', '1001', '-1', '2022-12-05 03:49:16');
INSERT INTO `rizhi` VALUES ('200', '6', 'taskname3云平台定时任务 到点结束', '1001', '-1', '2022-12-05 03:49:16');
INSERT INTO `rizhi` VALUES ('201', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 04:00:20');
INSERT INTO `rizhi` VALUES ('202', '6', 'taskname3云平台定时任务 播放url：http://192.168.3.211:12080/mp3/6/536f756ca1a36d616e2d4265617420497420c5aec9f9cae3c7e9b0e6206d6ad3c0b4b9b2bbd0e02e6d7033.mp3T文件播放时长237', '1001', '-1', '2022-12-05 04:00:20');
INSERT INTO `rizhi` VALUES ('203', '6', 'taskname3云平台定时任务 停止命令已发送', '1001', '-1', '2022-12-05 04:01:55');
INSERT INTO `rizhi` VALUES ('204', '6', 'taskname3云平台定时任务 到点结束', '1001', '-1', '2022-12-05 04:01:55');
INSERT INTO `rizhi` VALUES ('205', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 04:03:23');
INSERT INTO `rizhi` VALUES ('206', '6', 'taskname3云平台定时任务 播放url：http://192.168.3.211:12080/mp3/6/536f756ca1a36d616e2d4265617420497420c5aec9f9cae3c7e9b0e6206d6ad3c0b4b9b2bbd0e02e6d7033.mp3T文件播放时长237', '1001', '-1', '2022-12-05 04:03:23');
INSERT INTO `rizhi` VALUES ('207', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 04:11:34');
INSERT INTO `rizhi` VALUES ('208', '6', 'taskname3云平台定时任务 播放url：http://192.168.3.211:12080/mp3/6/536f756ca1a36d616e2d4265617420497420c5aec9f9cae3c7e9b0e6206d6ad3c0b4b9b2bbd0e02e6d7033.mp3T文件播放时长237', '1001', '-1', '2022-12-05 04:11:34');
INSERT INTO `rizhi` VALUES ('209', '6', 'taskname3云平台定时任务 停止命令已发送', '1001', '-1', '2022-12-05 04:12:07');
INSERT INTO `rizhi` VALUES ('210', '6', 'taskname3云平台定时任务 到点结束', '1001', '-1', '2022-12-05 04:12:07');
INSERT INTO `rizhi` VALUES ('211', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 04:12:29');
INSERT INTO `rizhi` VALUES ('212', '6', 'taskname3云平台定时任务 播放url：http://192.168.3.211:12080/mp3/6/536f756ca1a36d616e2d4265617420497420c5aec9f9cae3c7e9b0e6206d6ad3c0b4b9b2bbd0e02e6d7033.mp3T文件播放时长237', '1001', '-1', '2022-12-05 04:12:29');
INSERT INTO `rizhi` VALUES ('213', '6', 'taskname3云平台定时任务 停止命令已发送', '1001', '-1', '2022-12-05 04:12:32');
INSERT INTO `rizhi` VALUES ('214', '6', 'taskname3云平台定时任务 到点结束', '1001', '-1', '2022-12-05 04:12:32');
INSERT INTO `rizhi` VALUES ('215', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 04:16:43');
INSERT INTO `rizhi` VALUES ('216', '6', 'taskname3云平台定时任务 播放url：http://192.168.3.211:12080/mp3/6/536f756ca1a36d616e2d4265617420497420c5aec9f9cae3c7e9b0e6206d6ad3c0b4b9b2bbd0e02e6d7033.mp3T文件播放时长237', '1001', '-1', '2022-12-05 04:16:43');
INSERT INTO `rizhi` VALUES ('217', '6', 'taskname3云平台定时任务 停止命令已发送', '1001', '-1', '2022-12-05 04:16:51');
INSERT INTO `rizhi` VALUES ('218', '6', 'taskname3云平台定时任务 到点结束', '1001', '-1', '2022-12-05 04:16:51');
INSERT INTO `rizhi` VALUES ('219', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 04:23:26');
INSERT INTO `rizhi` VALUES ('220', '6', 'taskname3云平台定时任务 播放url：http://192.168.3.211:12080/mp3/6/536f756ca1a36d616e2d4265617420497420c5aec9f9cae3c7e9b0e6206d6ad3c0b4b9b2bbd0e02e6d7033.mp3T文件播放时长237', '1001', '-1', '2022-12-05 04:23:26');
INSERT INTO `rizhi` VALUES ('221', '6', 'taskname3云平台定时任务 到点结束', '1001', '-1', '2022-12-05 04:23:30');
INSERT INTO `rizhi` VALUES ('222', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 04:24:27');
INSERT INTO `rizhi` VALUES ('223', '6', 'taskname3云平台定时任务 播放url：http://192.168.3.211:12080/mp3/6/536f756ca1a36d616e2d4265617420497420c5aec9f9cae3c7e9b0e6206d6ad3c0b4b9b2bbd0e02e6d7033.mp3T文件播放时长237', '1001', '-1', '2022-12-05 04:24:27');
INSERT INTO `rizhi` VALUES ('224', '6', 'taskname3云平台定时任务 到点结束', '1001', '-1', '2022-12-05 04:26:26');
INSERT INTO `rizhi` VALUES ('225', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 04:26:33');
INSERT INTO `rizhi` VALUES ('226', '6', 'taskname3云平台定时任务 播放url：http://192.168.3.211:12080/mp3/6/536f756ca1a36d616e2d4265617420497420c5aec9f9cae3c7e9b0e6206d6ad3c0b4b9b2bbd0e02e6d7033.mp3T文件播放时长237', '1001', '-1', '2022-12-05 04:26:33');
INSERT INTO `rizhi` VALUES ('227', '6', 'taskname3云平台定时任务 到点结束', '1001', '-1', '2022-12-05 04:27:37');
INSERT INTO `rizhi` VALUES ('228', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 04:27:49');
INSERT INTO `rizhi` VALUES ('229', '6', 'taskname3云平台定时任务 播放url：http://192.168.3.211:12080/mp3/6/536f756ca1a36d616e2d4265617420497420c5aec9f9cae3c7e9b0e6206d6ad3c0b4b9b2bbd0e02e6d7033.mp3T文件播放时长237', '1001', '-1', '2022-12-05 04:27:49');
INSERT INTO `rizhi` VALUES ('230', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 04:32:58');
INSERT INTO `rizhi` VALUES ('231', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 04:34:45');
INSERT INTO `rizhi` VALUES ('232', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 04:40:41');
INSERT INTO `rizhi` VALUES ('233', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 04:49:57');
INSERT INTO `rizhi` VALUES ('234', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 04:55:07');
INSERT INTO `rizhi` VALUES ('235', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 04:56:20');
INSERT INTO `rizhi` VALUES ('236', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:04:15');
INSERT INTO `rizhi` VALUES ('237', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:20:46');
INSERT INTO `rizhi` VALUES ('238', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:22:57');
INSERT INTO `rizhi` VALUES ('239', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:24:21');
INSERT INTO `rizhi` VALUES ('240', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:26:24');
INSERT INTO `rizhi` VALUES ('241', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:26:49');
INSERT INTO `rizhi` VALUES ('242', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:27:04');
INSERT INTO `rizhi` VALUES ('243', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:27:29');
INSERT INTO `rizhi` VALUES ('244', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:28:16');
INSERT INTO `rizhi` VALUES ('245', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:28:20');
INSERT INTO `rizhi` VALUES ('246', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:28:23');
INSERT INTO `rizhi` VALUES ('247', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:28:24');
INSERT INTO `rizhi` VALUES ('248', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:28:25');
INSERT INTO `rizhi` VALUES ('249', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:28:26');
INSERT INTO `rizhi` VALUES ('250', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:28:27');
INSERT INTO `rizhi` VALUES ('251', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:28:28');
INSERT INTO `rizhi` VALUES ('252', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:28:29');
INSERT INTO `rizhi` VALUES ('253', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:28:31');
INSERT INTO `rizhi` VALUES ('254', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:28:32');
INSERT INTO `rizhi` VALUES ('255', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:28:33');
INSERT INTO `rizhi` VALUES ('256', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:28:34');
INSERT INTO `rizhi` VALUES ('257', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:29:03');
INSERT INTO `rizhi` VALUES ('258', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:29:04');
INSERT INTO `rizhi` VALUES ('259', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:29:05');
INSERT INTO `rizhi` VALUES ('260', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:29:06');
INSERT INTO `rizhi` VALUES ('261', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:29:07');
INSERT INTO `rizhi` VALUES ('262', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:29:08');
INSERT INTO `rizhi` VALUES ('263', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:29:09');
INSERT INTO `rizhi` VALUES ('264', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:29:10');
INSERT INTO `rizhi` VALUES ('265', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:29:11');
INSERT INTO `rizhi` VALUES ('266', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:29:12');
INSERT INTO `rizhi` VALUES ('267', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:29:13');
INSERT INTO `rizhi` VALUES ('268', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:29:14');
INSERT INTO `rizhi` VALUES ('269', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:29:15');
INSERT INTO `rizhi` VALUES ('270', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:29:16');
INSERT INTO `rizhi` VALUES ('271', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:29:17');
INSERT INTO `rizhi` VALUES ('272', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:29:57');
INSERT INTO `rizhi` VALUES ('273', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:29:58');
INSERT INTO `rizhi` VALUES ('274', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:29:59');
INSERT INTO `rizhi` VALUES ('275', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:30:00');
INSERT INTO `rizhi` VALUES ('276', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:30:01');
INSERT INTO `rizhi` VALUES ('277', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:30:02');
INSERT INTO `rizhi` VALUES ('278', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:30:03');
INSERT INTO `rizhi` VALUES ('279', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:30:04');
INSERT INTO `rizhi` VALUES ('280', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:30:05');
INSERT INTO `rizhi` VALUES ('281', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:30:06');
INSERT INTO `rizhi` VALUES ('282', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:30:07');
INSERT INTO `rizhi` VALUES ('283', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:30:08');
INSERT INTO `rizhi` VALUES ('284', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:30:09');
INSERT INTO `rizhi` VALUES ('285', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:30:10');
INSERT INTO `rizhi` VALUES ('286', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:30:11');
INSERT INTO `rizhi` VALUES ('287', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:30:12');
INSERT INTO `rizhi` VALUES ('288', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:30:13');
INSERT INTO `rizhi` VALUES ('289', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:30:14');
INSERT INTO `rizhi` VALUES ('290', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:30:15');
INSERT INTO `rizhi` VALUES ('291', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:30:16');
INSERT INTO `rizhi` VALUES ('292', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:30:17');
INSERT INTO `rizhi` VALUES ('293', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:30:18');
INSERT INTO `rizhi` VALUES ('294', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:30:19');
INSERT INTO `rizhi` VALUES ('295', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:30:20');
INSERT INTO `rizhi` VALUES ('296', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:30:21');
INSERT INTO `rizhi` VALUES ('297', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:30:22');
INSERT INTO `rizhi` VALUES ('298', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:30:23');
INSERT INTO `rizhi` VALUES ('299', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:30:24');
INSERT INTO `rizhi` VALUES ('300', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:30:25');
INSERT INTO `rizhi` VALUES ('301', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:30:26');
INSERT INTO `rizhi` VALUES ('302', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:30:27');
INSERT INTO `rizhi` VALUES ('303', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:30:28');
INSERT INTO `rizhi` VALUES ('304', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:30:29');
INSERT INTO `rizhi` VALUES ('305', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:30:30');
INSERT INTO `rizhi` VALUES ('306', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:30:31');
INSERT INTO `rizhi` VALUES ('307', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:30:32');
INSERT INTO `rizhi` VALUES ('308', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:30:33');
INSERT INTO `rizhi` VALUES ('309', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:30:34');
INSERT INTO `rizhi` VALUES ('310', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:30:35');
INSERT INTO `rizhi` VALUES ('311', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:30:36');
INSERT INTO `rizhi` VALUES ('312', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:30:37');
INSERT INTO `rizhi` VALUES ('313', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:30:38');
INSERT INTO `rizhi` VALUES ('314', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:30:39');
INSERT INTO `rizhi` VALUES ('315', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:30:40');
INSERT INTO `rizhi` VALUES ('316', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:30:41');
INSERT INTO `rizhi` VALUES ('317', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:30:42');
INSERT INTO `rizhi` VALUES ('318', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:30:43');
INSERT INTO `rizhi` VALUES ('319', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:30:44');
INSERT INTO `rizhi` VALUES ('320', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:30:45');
INSERT INTO `rizhi` VALUES ('321', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:30:46');
INSERT INTO `rizhi` VALUES ('322', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:30:47');
INSERT INTO `rizhi` VALUES ('323', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:30:48');
INSERT INTO `rizhi` VALUES ('324', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:30:49');
INSERT INTO `rizhi` VALUES ('325', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:30:50');
INSERT INTO `rizhi` VALUES ('326', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:30:51');
INSERT INTO `rizhi` VALUES ('327', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:30:52');
INSERT INTO `rizhi` VALUES ('328', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:30:53');
INSERT INTO `rizhi` VALUES ('329', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:30:54');
INSERT INTO `rizhi` VALUES ('330', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:30:55');
INSERT INTO `rizhi` VALUES ('331', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:30:56');
INSERT INTO `rizhi` VALUES ('332', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:30:57');
INSERT INTO `rizhi` VALUES ('333', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:30:58');
INSERT INTO `rizhi` VALUES ('334', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:30:59');
INSERT INTO `rizhi` VALUES ('335', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:31:00');
INSERT INTO `rizhi` VALUES ('336', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:31:01');
INSERT INTO `rizhi` VALUES ('337', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:31:02');
INSERT INTO `rizhi` VALUES ('338', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:31:03');
INSERT INTO `rizhi` VALUES ('339', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:31:04');
INSERT INTO `rizhi` VALUES ('340', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:31:05');
INSERT INTO `rizhi` VALUES ('341', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:31:06');
INSERT INTO `rizhi` VALUES ('342', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:31:07');
INSERT INTO `rizhi` VALUES ('343', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:31:08');
INSERT INTO `rizhi` VALUES ('344', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:31:09');
INSERT INTO `rizhi` VALUES ('345', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:31:10');
INSERT INTO `rizhi` VALUES ('346', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:31:11');
INSERT INTO `rizhi` VALUES ('347', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:31:12');
INSERT INTO `rizhi` VALUES ('348', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:31:13');
INSERT INTO `rizhi` VALUES ('349', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:31:14');
INSERT INTO `rizhi` VALUES ('350', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:31:15');
INSERT INTO `rizhi` VALUES ('351', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:31:16');
INSERT INTO `rizhi` VALUES ('352', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:31:39');
INSERT INTO `rizhi` VALUES ('353', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:31:40');
INSERT INTO `rizhi` VALUES ('354', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:31:41');
INSERT INTO `rizhi` VALUES ('355', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:31:42');
INSERT INTO `rizhi` VALUES ('356', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:31:43');
INSERT INTO `rizhi` VALUES ('357', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:31:44');
INSERT INTO `rizhi` VALUES ('358', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:31:45');
INSERT INTO `rizhi` VALUES ('359', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:31:46');
INSERT INTO `rizhi` VALUES ('360', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:31:47');
INSERT INTO `rizhi` VALUES ('361', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:31:48');
INSERT INTO `rizhi` VALUES ('362', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:31:49');
INSERT INTO `rizhi` VALUES ('363', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:31:50');
INSERT INTO `rizhi` VALUES ('364', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:31:51');
INSERT INTO `rizhi` VALUES ('365', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:31:52');
INSERT INTO `rizhi` VALUES ('366', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:31:53');
INSERT INTO `rizhi` VALUES ('367', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:31:54');
INSERT INTO `rizhi` VALUES ('368', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:31:55');
INSERT INTO `rizhi` VALUES ('369', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:31:56');
INSERT INTO `rizhi` VALUES ('370', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:31:57');
INSERT INTO `rizhi` VALUES ('371', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:31:58');
INSERT INTO `rizhi` VALUES ('372', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:31:59');
INSERT INTO `rizhi` VALUES ('373', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:32:00');
INSERT INTO `rizhi` VALUES ('374', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:32:01');
INSERT INTO `rizhi` VALUES ('375', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:32:02');
INSERT INTO `rizhi` VALUES ('376', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:32:03');
INSERT INTO `rizhi` VALUES ('377', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:32:04');
INSERT INTO `rizhi` VALUES ('378', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:32:05');
INSERT INTO `rizhi` VALUES ('379', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:32:06');
INSERT INTO `rizhi` VALUES ('380', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:32:07');
INSERT INTO `rizhi` VALUES ('381', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:32:08');
INSERT INTO `rizhi` VALUES ('382', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:32:09');
INSERT INTO `rizhi` VALUES ('383', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:32:10');
INSERT INTO `rizhi` VALUES ('384', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:32:11');
INSERT INTO `rizhi` VALUES ('385', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:32:12');
INSERT INTO `rizhi` VALUES ('386', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:32:13');
INSERT INTO `rizhi` VALUES ('387', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:32:14');
INSERT INTO `rizhi` VALUES ('388', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:32:15');
INSERT INTO `rizhi` VALUES ('389', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:32:16');
INSERT INTO `rizhi` VALUES ('390', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:32:17');
INSERT INTO `rizhi` VALUES ('391', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:32:18');
INSERT INTO `rizhi` VALUES ('392', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:32:19');
INSERT INTO `rizhi` VALUES ('393', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:32:20');
INSERT INTO `rizhi` VALUES ('394', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:32:21');
INSERT INTO `rizhi` VALUES ('395', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:32:22');
INSERT INTO `rizhi` VALUES ('396', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:32:23');
INSERT INTO `rizhi` VALUES ('397', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:32:24');
INSERT INTO `rizhi` VALUES ('398', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:32:25');
INSERT INTO `rizhi` VALUES ('399', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:32:26');
INSERT INTO `rizhi` VALUES ('400', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:32:27');
INSERT INTO `rizhi` VALUES ('401', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:32:28');
INSERT INTO `rizhi` VALUES ('402', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:32:29');
INSERT INTO `rizhi` VALUES ('403', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:32:30');
INSERT INTO `rizhi` VALUES ('404', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:32:31');
INSERT INTO `rizhi` VALUES ('405', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:32:32');
INSERT INTO `rizhi` VALUES ('406', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:32:33');
INSERT INTO `rizhi` VALUES ('407', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:32:34');
INSERT INTO `rizhi` VALUES ('408', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:32:35');
INSERT INTO `rizhi` VALUES ('409', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:32:36');
INSERT INTO `rizhi` VALUES ('410', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:32:37');
INSERT INTO `rizhi` VALUES ('411', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:32:38');
INSERT INTO `rizhi` VALUES ('412', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:32:39');
INSERT INTO `rizhi` VALUES ('413', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:32:40');
INSERT INTO `rizhi` VALUES ('414', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:32:41');
INSERT INTO `rizhi` VALUES ('415', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:32:42');
INSERT INTO `rizhi` VALUES ('416', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:32:43');
INSERT INTO `rizhi` VALUES ('417', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:32:44');
INSERT INTO `rizhi` VALUES ('418', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:32:45');
INSERT INTO `rizhi` VALUES ('419', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:32:46');
INSERT INTO `rizhi` VALUES ('420', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:32:47');
INSERT INTO `rizhi` VALUES ('421', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:32:48');
INSERT INTO `rizhi` VALUES ('422', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:32:49');
INSERT INTO `rizhi` VALUES ('423', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:32:50');
INSERT INTO `rizhi` VALUES ('424', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:32:51');
INSERT INTO `rizhi` VALUES ('425', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:32:52');
INSERT INTO `rizhi` VALUES ('426', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:32:53');
INSERT INTO `rizhi` VALUES ('427', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:32:54');
INSERT INTO `rizhi` VALUES ('428', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:32:55');
INSERT INTO `rizhi` VALUES ('429', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:32:56');
INSERT INTO `rizhi` VALUES ('430', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:32:57');
INSERT INTO `rizhi` VALUES ('431', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:32:58');
INSERT INTO `rizhi` VALUES ('432', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:32:59');
INSERT INTO `rizhi` VALUES ('433', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:33:00');
INSERT INTO `rizhi` VALUES ('434', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:33:01');
INSERT INTO `rizhi` VALUES ('435', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:33:02');
INSERT INTO `rizhi` VALUES ('436', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:33:03');
INSERT INTO `rizhi` VALUES ('437', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:33:04');
INSERT INTO `rizhi` VALUES ('438', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:33:05');
INSERT INTO `rizhi` VALUES ('439', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:33:06');
INSERT INTO `rizhi` VALUES ('440', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:33:07');
INSERT INTO `rizhi` VALUES ('441', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:33:08');
INSERT INTO `rizhi` VALUES ('442', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:33:09');
INSERT INTO `rizhi` VALUES ('443', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:33:10');
INSERT INTO `rizhi` VALUES ('444', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:33:11');
INSERT INTO `rizhi` VALUES ('445', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:33:12');
INSERT INTO `rizhi` VALUES ('446', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:33:13');
INSERT INTO `rizhi` VALUES ('447', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:33:14');
INSERT INTO `rizhi` VALUES ('448', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:33:15');
INSERT INTO `rizhi` VALUES ('449', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:33:16');
INSERT INTO `rizhi` VALUES ('450', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:33:17');
INSERT INTO `rizhi` VALUES ('451', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:33:18');
INSERT INTO `rizhi` VALUES ('452', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:33:19');
INSERT INTO `rizhi` VALUES ('453', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:33:20');
INSERT INTO `rizhi` VALUES ('454', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:33:21');
INSERT INTO `rizhi` VALUES ('455', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:33:22');
INSERT INTO `rizhi` VALUES ('456', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:33:23');
INSERT INTO `rizhi` VALUES ('457', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:33:24');
INSERT INTO `rizhi` VALUES ('458', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:33:25');
INSERT INTO `rizhi` VALUES ('459', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:33:26');
INSERT INTO `rizhi` VALUES ('460', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:33:27');
INSERT INTO `rizhi` VALUES ('461', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:33:28');
INSERT INTO `rizhi` VALUES ('462', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:33:29');
INSERT INTO `rizhi` VALUES ('463', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:33:30');
INSERT INTO `rizhi` VALUES ('464', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:33:31');
INSERT INTO `rizhi` VALUES ('465', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:33:32');
INSERT INTO `rizhi` VALUES ('466', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:33:33');
INSERT INTO `rizhi` VALUES ('467', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:33:34');
INSERT INTO `rizhi` VALUES ('468', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:33:35');
INSERT INTO `rizhi` VALUES ('469', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:33:36');
INSERT INTO `rizhi` VALUES ('470', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:33:37');
INSERT INTO `rizhi` VALUES ('471', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:33:38');
INSERT INTO `rizhi` VALUES ('472', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:33:39');
INSERT INTO `rizhi` VALUES ('473', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:33:40');
INSERT INTO `rizhi` VALUES ('474', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:33:41');
INSERT INTO `rizhi` VALUES ('475', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:33:42');
INSERT INTO `rizhi` VALUES ('476', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:33:43');
INSERT INTO `rizhi` VALUES ('477', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:33:44');
INSERT INTO `rizhi` VALUES ('478', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:33:45');
INSERT INTO `rizhi` VALUES ('479', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:33:46');
INSERT INTO `rizhi` VALUES ('480', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:33:47');
INSERT INTO `rizhi` VALUES ('481', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:33:48');
INSERT INTO `rizhi` VALUES ('482', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:33:49');
INSERT INTO `rizhi` VALUES ('483', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:33:50');
INSERT INTO `rizhi` VALUES ('484', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:33:51');
INSERT INTO `rizhi` VALUES ('485', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:33:52');
INSERT INTO `rizhi` VALUES ('486', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:33:53');
INSERT INTO `rizhi` VALUES ('487', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:33:54');
INSERT INTO `rizhi` VALUES ('488', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:33:55');
INSERT INTO `rizhi` VALUES ('489', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:33:56');
INSERT INTO `rizhi` VALUES ('490', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:33:57');
INSERT INTO `rizhi` VALUES ('491', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:33:58');
INSERT INTO `rizhi` VALUES ('492', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:33:59');
INSERT INTO `rizhi` VALUES ('493', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:34:00');
INSERT INTO `rizhi` VALUES ('494', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:34:01');
INSERT INTO `rizhi` VALUES ('495', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:34:02');
INSERT INTO `rizhi` VALUES ('496', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:34:03');
INSERT INTO `rizhi` VALUES ('497', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:34:04');
INSERT INTO `rizhi` VALUES ('498', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:34:05');
INSERT INTO `rizhi` VALUES ('499', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:34:06');
INSERT INTO `rizhi` VALUES ('500', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:34:07');
INSERT INTO `rizhi` VALUES ('501', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:34:08');
INSERT INTO `rizhi` VALUES ('502', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:34:09');
INSERT INTO `rizhi` VALUES ('503', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:34:10');
INSERT INTO `rizhi` VALUES ('504', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:34:11');
INSERT INTO `rizhi` VALUES ('505', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:34:12');
INSERT INTO `rizhi` VALUES ('506', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:34:13');
INSERT INTO `rizhi` VALUES ('507', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:34:14');
INSERT INTO `rizhi` VALUES ('508', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:34:15');
INSERT INTO `rizhi` VALUES ('509', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:34:16');
INSERT INTO `rizhi` VALUES ('510', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:34:17');
INSERT INTO `rizhi` VALUES ('511', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:34:18');
INSERT INTO `rizhi` VALUES ('512', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:34:19');
INSERT INTO `rizhi` VALUES ('513', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:34:20');
INSERT INTO `rizhi` VALUES ('514', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:34:21');
INSERT INTO `rizhi` VALUES ('515', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:34:22');
INSERT INTO `rizhi` VALUES ('516', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:34:23');
INSERT INTO `rizhi` VALUES ('517', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:34:24');
INSERT INTO `rizhi` VALUES ('518', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:34:25');
INSERT INTO `rizhi` VALUES ('519', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:34:26');
INSERT INTO `rizhi` VALUES ('520', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:34:27');
INSERT INTO `rizhi` VALUES ('521', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:34:28');
INSERT INTO `rizhi` VALUES ('522', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:34:29');
INSERT INTO `rizhi` VALUES ('523', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:34:30');
INSERT INTO `rizhi` VALUES ('524', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:34:31');
INSERT INTO `rizhi` VALUES ('525', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:34:32');
INSERT INTO `rizhi` VALUES ('526', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:34:33');
INSERT INTO `rizhi` VALUES ('527', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:34:34');
INSERT INTO `rizhi` VALUES ('528', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:34:35');
INSERT INTO `rizhi` VALUES ('529', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:35:14');
INSERT INTO `rizhi` VALUES ('530', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:35:15');
INSERT INTO `rizhi` VALUES ('531', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:35:16');
INSERT INTO `rizhi` VALUES ('532', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:35:17');
INSERT INTO `rizhi` VALUES ('533', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:35:18');
INSERT INTO `rizhi` VALUES ('534', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:35:19');
INSERT INTO `rizhi` VALUES ('535', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:35:20');
INSERT INTO `rizhi` VALUES ('536', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:35:21');
INSERT INTO `rizhi` VALUES ('537', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:35:22');
INSERT INTO `rizhi` VALUES ('538', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:35:23');
INSERT INTO `rizhi` VALUES ('539', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:35:24');
INSERT INTO `rizhi` VALUES ('540', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:35:25');
INSERT INTO `rizhi` VALUES ('541', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:35:26');
INSERT INTO `rizhi` VALUES ('542', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:35:27');
INSERT INTO `rizhi` VALUES ('543', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:35:28');
INSERT INTO `rizhi` VALUES ('544', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:35:34');
INSERT INTO `rizhi` VALUES ('545', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:41:03');
INSERT INTO `rizhi` VALUES ('546', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:41:04');
INSERT INTO `rizhi` VALUES ('547', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:41:05');
INSERT INTO `rizhi` VALUES ('548', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:41:06');
INSERT INTO `rizhi` VALUES ('549', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:41:56');
INSERT INTO `rizhi` VALUES ('550', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:41:57');
INSERT INTO `rizhi` VALUES ('551', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:41:58');
INSERT INTO `rizhi` VALUES ('552', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:41:59');
INSERT INTO `rizhi` VALUES ('553', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:42:00');
INSERT INTO `rizhi` VALUES ('554', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:42:01');
INSERT INTO `rizhi` VALUES ('555', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:42:02');
INSERT INTO `rizhi` VALUES ('556', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:42:03');
INSERT INTO `rizhi` VALUES ('557', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:42:04');
INSERT INTO `rizhi` VALUES ('558', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:42:05');
INSERT INTO `rizhi` VALUES ('559', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:42:06');
INSERT INTO `rizhi` VALUES ('560', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:42:07');
INSERT INTO `rizhi` VALUES ('561', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:42:08');
INSERT INTO `rizhi` VALUES ('562', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:42:09');
INSERT INTO `rizhi` VALUES ('563', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:42:10');
INSERT INTO `rizhi` VALUES ('564', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:42:11');
INSERT INTO `rizhi` VALUES ('565', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:42:12');
INSERT INTO `rizhi` VALUES ('566', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:42:13');
INSERT INTO `rizhi` VALUES ('567', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:42:14');
INSERT INTO `rizhi` VALUES ('568', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:42:15');
INSERT INTO `rizhi` VALUES ('569', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:42:34');
INSERT INTO `rizhi` VALUES ('570', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:42:35');
INSERT INTO `rizhi` VALUES ('571', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:42:36');
INSERT INTO `rizhi` VALUES ('572', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:42:37');
INSERT INTO `rizhi` VALUES ('573', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:42:38');
INSERT INTO `rizhi` VALUES ('574', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:42:39');
INSERT INTO `rizhi` VALUES ('575', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:42:40');
INSERT INTO `rizhi` VALUES ('576', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:42:41');
INSERT INTO `rizhi` VALUES ('577', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:42:42');
INSERT INTO `rizhi` VALUES ('578', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:42:43');
INSERT INTO `rizhi` VALUES ('579', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:42:44');
INSERT INTO `rizhi` VALUES ('580', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:42:45');
INSERT INTO `rizhi` VALUES ('581', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:42:46');
INSERT INTO `rizhi` VALUES ('582', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:42:47');
INSERT INTO `rizhi` VALUES ('583', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:42:48');
INSERT INTO `rizhi` VALUES ('584', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:42:49');
INSERT INTO `rizhi` VALUES ('585', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:42:50');
INSERT INTO `rizhi` VALUES ('586', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:42:51');
INSERT INTO `rizhi` VALUES ('587', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:42:52');
INSERT INTO `rizhi` VALUES ('588', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:42:53');
INSERT INTO `rizhi` VALUES ('589', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:42:54');
INSERT INTO `rizhi` VALUES ('590', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:42:55');
INSERT INTO `rizhi` VALUES ('591', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:42:56');
INSERT INTO `rizhi` VALUES ('592', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:43:18');
INSERT INTO `rizhi` VALUES ('593', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:43:19');
INSERT INTO `rizhi` VALUES ('594', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:43:20');
INSERT INTO `rizhi` VALUES ('595', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:43:21');
INSERT INTO `rizhi` VALUES ('596', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:43:22');
INSERT INTO `rizhi` VALUES ('597', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:43:23');
INSERT INTO `rizhi` VALUES ('598', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:43:24');
INSERT INTO `rizhi` VALUES ('599', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:43:25');
INSERT INTO `rizhi` VALUES ('600', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:43:26');
INSERT INTO `rizhi` VALUES ('601', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:43:27');
INSERT INTO `rizhi` VALUES ('602', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:43:28');
INSERT INTO `rizhi` VALUES ('603', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:43:29');
INSERT INTO `rizhi` VALUES ('604', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:43:30');
INSERT INTO `rizhi` VALUES ('605', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:43:31');
INSERT INTO `rizhi` VALUES ('606', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:43:32');
INSERT INTO `rizhi` VALUES ('607', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:43:33');
INSERT INTO `rizhi` VALUES ('608', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:43:34');
INSERT INTO `rizhi` VALUES ('609', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:43:35');
INSERT INTO `rizhi` VALUES ('610', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:43:36');
INSERT INTO `rizhi` VALUES ('611', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:43:37');
INSERT INTO `rizhi` VALUES ('612', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:43:38');
INSERT INTO `rizhi` VALUES ('613', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:43:39');
INSERT INTO `rizhi` VALUES ('614', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:43:40');
INSERT INTO `rizhi` VALUES ('615', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:43:41');
INSERT INTO `rizhi` VALUES ('616', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:43:42');
INSERT INTO `rizhi` VALUES ('617', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:43:43');
INSERT INTO `rizhi` VALUES ('618', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:43:44');
INSERT INTO `rizhi` VALUES ('619', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:43:45');
INSERT INTO `rizhi` VALUES ('620', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:43:46');
INSERT INTO `rizhi` VALUES ('621', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:43:47');
INSERT INTO `rizhi` VALUES ('622', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:43:48');
INSERT INTO `rizhi` VALUES ('623', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:43:49');
INSERT INTO `rizhi` VALUES ('624', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:43:50');
INSERT INTO `rizhi` VALUES ('625', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:43:51');
INSERT INTO `rizhi` VALUES ('626', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:43:52');
INSERT INTO `rizhi` VALUES ('627', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:43:53');
INSERT INTO `rizhi` VALUES ('628', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:43:54');
INSERT INTO `rizhi` VALUES ('629', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:43:55');
INSERT INTO `rizhi` VALUES ('630', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:43:56');
INSERT INTO `rizhi` VALUES ('631', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:43:57');
INSERT INTO `rizhi` VALUES ('632', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:43:58');
INSERT INTO `rizhi` VALUES ('633', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:43:59');
INSERT INTO `rizhi` VALUES ('634', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:44:00');
INSERT INTO `rizhi` VALUES ('635', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:44:01');
INSERT INTO `rizhi` VALUES ('636', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:44:02');
INSERT INTO `rizhi` VALUES ('637', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:44:03');
INSERT INTO `rizhi` VALUES ('638', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:44:04');
INSERT INTO `rizhi` VALUES ('639', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:44:05');
INSERT INTO `rizhi` VALUES ('640', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:44:06');
INSERT INTO `rizhi` VALUES ('641', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:44:07');
INSERT INTO `rizhi` VALUES ('642', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:44:08');
INSERT INTO `rizhi` VALUES ('643', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:44:09');
INSERT INTO `rizhi` VALUES ('644', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:44:10');
INSERT INTO `rizhi` VALUES ('645', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:46:08');
INSERT INTO `rizhi` VALUES ('646', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:46:09');
INSERT INTO `rizhi` VALUES ('647', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:46:10');
INSERT INTO `rizhi` VALUES ('648', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:46:11');
INSERT INTO `rizhi` VALUES ('649', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:46:12');
INSERT INTO `rizhi` VALUES ('650', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:46:13');
INSERT INTO `rizhi` VALUES ('651', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:46:14');
INSERT INTO `rizhi` VALUES ('652', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:46:15');
INSERT INTO `rizhi` VALUES ('653', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:46:16');
INSERT INTO `rizhi` VALUES ('654', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:46:17');
INSERT INTO `rizhi` VALUES ('655', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:46:18');
INSERT INTO `rizhi` VALUES ('656', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:46:19');
INSERT INTO `rizhi` VALUES ('657', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:46:20');
INSERT INTO `rizhi` VALUES ('658', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:46:21');
INSERT INTO `rizhi` VALUES ('659', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:46:22');
INSERT INTO `rizhi` VALUES ('660', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:46:23');
INSERT INTO `rizhi` VALUES ('661', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:46:24');
INSERT INTO `rizhi` VALUES ('662', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:46:25');
INSERT INTO `rizhi` VALUES ('663', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:46:26');
INSERT INTO `rizhi` VALUES ('664', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:46:27');
INSERT INTO `rizhi` VALUES ('665', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:46:28');
INSERT INTO `rizhi` VALUES ('666', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:46:29');
INSERT INTO `rizhi` VALUES ('667', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:46:30');
INSERT INTO `rizhi` VALUES ('668', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:46:31');
INSERT INTO `rizhi` VALUES ('669', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:46:32');
INSERT INTO `rizhi` VALUES ('670', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:46:33');
INSERT INTO `rizhi` VALUES ('671', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:46:34');
INSERT INTO `rizhi` VALUES ('672', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:46:35');
INSERT INTO `rizhi` VALUES ('673', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:46:36');
INSERT INTO `rizhi` VALUES ('674', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:46:37');
INSERT INTO `rizhi` VALUES ('675', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:46:38');
INSERT INTO `rizhi` VALUES ('676', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:46:39');
INSERT INTO `rizhi` VALUES ('677', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:46:40');
INSERT INTO `rizhi` VALUES ('678', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:46:41');
INSERT INTO `rizhi` VALUES ('679', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:46:42');
INSERT INTO `rizhi` VALUES ('680', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:46:43');
INSERT INTO `rizhi` VALUES ('681', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:46:44');
INSERT INTO `rizhi` VALUES ('682', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:46:45');
INSERT INTO `rizhi` VALUES ('683', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:46:46');
INSERT INTO `rizhi` VALUES ('684', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:46:47');
INSERT INTO `rizhi` VALUES ('685', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:46:48');
INSERT INTO `rizhi` VALUES ('686', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:46:49');
INSERT INTO `rizhi` VALUES ('687', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:46:50');
INSERT INTO `rizhi` VALUES ('688', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:46:51');
INSERT INTO `rizhi` VALUES ('689', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:46:52');
INSERT INTO `rizhi` VALUES ('690', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:46:53');
INSERT INTO `rizhi` VALUES ('691', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:46:54');
INSERT INTO `rizhi` VALUES ('692', '6', 'SELECT*FROMtaskwhereid=3;任务启动命令发送待执行', '1001', '-1', '2022-12-05 05:46:55');

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
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sbox_device_info
-- ----------------------------
INSERT INTO `sbox_device_info` VALUES ('6', '4', '-1', '-1', 'dGVzdDAx', 'b80f8ccdb4ef83281200bfd4c5202487', 'f729c53a08b1e4ab38a6448da757ba89', '0', '2022-11-06 07:19:53', 'default', 'default', 'f729c53a08b1e4ab38a6448da757ba894', '-1', '-1', '1', '0', '_NONE.mp3', '_NONE.mp3', '2022-11-06 07:19:53', '116.40389220333873|39.91411461844903', '0', '0', '0', '0', '0');
INSERT INTO `sbox_device_info` VALUES ('7', '4', '-1', '-1', 'dGVzdDAx', '4630a59172538ef097b3a0e760c6da20', 'b80f8ccdb4ef83281200bfd4c5202487', '0', '2022-11-06 08:20:16', 'default', 'default', 'b80f8ccdb4ef83281200bfd4c52024874', '-1', '-1', '1', '0', '_NONE.mp3', '_NONE.mp3', '2022-11-06 08:20:16', '116.40389220333873|39.91411461844903', '0', '0', '0', '0', '0');
INSERT INTO `sbox_device_info` VALUES ('8', '4', '-1', '-1', 'dGVzdDAx', '88e8a8b18aa23206594947f41ae888c0', '4630a59172538ef097b3a0e760c6da20', '0', '2022-11-06 08:20:50', 'default', 'default', '4630a59172538ef097b3a0e760c6da204', '-1', '-1', '1', '0', '_NONE.mp3', '_NONE.mp3', '2022-11-06 08:20:50', '116.40389220333873|39.91411461844903', '0', '0', '0', '0', '0');
INSERT INTO `sbox_device_info` VALUES ('9', '4', '-1', '-1', 'dGVzdDAx', '4d8c756b3d8caf9abf8d528b0713674c', '88e8a8b18aa23206594947f41ae888c0', '0', '2022-11-06 08:21:11', 'default', 'default', '88e8a8b18aa23206594947f41ae888c04', '-1', '-1', '1', '0', '_NONE.mp3', '_NONE.mp3', '2022-11-06 08:21:11', '116.40389220333873|39.91411461844903', '0', '0', '0', '0', '0');
INSERT INTO `sbox_device_info` VALUES ('10', '6', '-1', '-1', 'dGVzdDAx', '9884d7f3d8b7b5d2a0e19daa34100d6c', '82a04a4e8389b605fc35adf3b6852e4c', '0', '2022-11-06 08:21:58', 'default', 'default', '82a04a4e8389b605fc35adf3b6852e4c4', '32', '1', '2', '0', '_NONE.mp3', '_NONE.mp3', '2022-11-06 08:21:58', '116.40389220333873|39.91411461844903', '0', '0', '0', '0', '0');
INSERT INTO `sbox_device_info` VALUES ('11', '6', '-1', '-1', 'dGVzdDAx', '171fcc3237226e82dc8c70c8987f9bb4', '7b7c80574db5f6d7d3b7e8e534c76a3a', '0', '2022-11-06 08:22:15', 'default', 'default', '7b7c80574db5f6d7d3b7e8e534c76a3a4', '32', '1', '2', '0', '_NONE.mp3', '_NONE.mp3', '2022-11-06 08:22:15', '116.40389220333873|39.91411461844903', '0', '0', '0', '0', '0');
INSERT INTO `sbox_device_info` VALUES ('12', '6', '-1', '-1', 'dGVzdDAxMg==', 'a64d4af228bfa0590de59b9fa2e48946', 'ed024ae3ae6c6eceb2b94019b727be61', '0', '2022-11-17 23:19:49', 'default', 'default', 'ed024ae3ae6c6eceb2b94019b727be614', '32', '1', '2', '0', '_NONE.mp3', '_NONE.mp3', '2022-11-17 23:19:49', '116.40389220333873|39.91411461844903', '0', '0', '0', '0', '0');
INSERT INTO `sbox_device_info` VALUES ('13', '6', '-1', '-1', 'dGVzdDAzMQ==', '8db7cde1757665b458ae2abee7fc526d', '34e159ed9561cbb1d90a4f8c58125623', '0', '2023-01-08 15:33:46', 'default', 'default', '34e159ed9561cbb1d90a4f8c581256236', '-1', '-1', '1', '0', '_NONE.mp3', '_NONE.mp3', '2023-01-08 15:33:46', '116.40389220333873|39.91411461844903', '0', '0', '0', '0', '0');
INSERT INTO `sbox_device_info` VALUES ('14', '6', '-1', '-1', 'dGVzdDAzMQ==', '4e19f7da354704e93c65d91b29cfa6cc', 'e1530f1287cfbb086a8fa421ddcec600', '0', '2023-01-08 15:34:03', 'default', 'default', 'e1530f1287cfbb086a8fa421ddcec6006', '-1', '-1', '1', '0', '_NONE.mp3', '_NONE.mp3', '2023-01-08 15:34:03', '116.40389220333873|39.91411461844903', '0', '0', '0', '0', '0');
INSERT INTO `sbox_device_info` VALUES ('15', '6', '-1', '-1', 'dGVzdDAzMQ==', '24774ce88d3c0a9222830a7fb8a05e1c', 'f765ee0c872ad630fc8609a207473b5f', '0', '2023-01-08 15:34:24', 'default', 'default', 'f765ee0c872ad630fc8609a207473b5f6', '-1', '-1', '1', '0', '_NONE.mp3', '_NONE.mp3', '2023-01-08 15:34:24', '116.40389220333873|39.91411461844903', '0', '0', '0', '0', '0');

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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sbox_group
-- ----------------------------
INSERT INTO `sbox_group` VALUES ('2', '6', 'suLK1LfW1+k=', '2023-01-02 15:52:00', '1');
INSERT INTO `sbox_group` VALUES ('3', '6', 'suLK1LfW1+kxMjEyMjAwMDAwMA==', '2023-01-02 21:42:17', '1');
INSERT INTO `sbox_group` VALUES ('4', '6', 'suLK1LfW1+k=', '2023-01-08 15:36:07', '1');
INSERT INTO `sbox_group` VALUES ('5', '6', 'suLK1LfW1+ky', '2023-01-08 15:36:10', '1');
INSERT INTO `sbox_group` VALUES ('6', '6', 'suLK1LfW1+kz', '2023-01-08 15:36:14', '1');

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
INSERT INTO `sbox_node` VALUES ('1', '服务', '192.168.3.211', '3333', '6000', '6006', '6002', '6003', '1', 'none', '1', '0', '6004', '0');

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
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sbox_users
-- ----------------------------
INSERT INTO `sbox_users` VALUES ('6', 'oxiaom2', '123123123', '1', '9', '-1', '-1', '2022-11-21 00:12:47', '0', '00000000000000000000000', 'Tk9USElORw==', '1', '1', '0', '1', 'cdn.ployq.com/gsh', 'd22c9c6eec0f199afef33e2be9f462b3f75b6f33');
INSERT INTO `sbox_users` VALUES ('7', 'oxiaom3', '123123123', '1', '9', '-1', '-1', '2023-01-09 14:07:20', '0', '00000000000000000000000', 'Tk9USElORw==', '1', '1', '0', '1', 'cdn.ployq.com/gsh', '09645a69a2c867fd0e822e290ddc1293653d3237');

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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of task
-- ----------------------------
INSERT INTO `task` VALUES ('3', '6', '41420', 'taskname', '1', '3000', '0', '1111111', '3', '0', '0', '11', '0', '7', '19|28|29', '10|11|12');

-- ----------------------------
-- Table structure for `taskfile`
-- ----------------------------
DROP TABLE IF EXISTS `taskfile`;
CREATE TABLE `taskfile` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `taskid` int(11) NOT NULL,
  `fileid` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=54 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of taskfile
-- ----------------------------
INSERT INTO `taskfile` VALUES ('26', '10', '19');
INSERT INTO `taskfile` VALUES ('27', '10', '28');
INSERT INTO `taskfile` VALUES ('28', '10', '29');
INSERT INTO `taskfile` VALUES ('29', '11', '19');
INSERT INTO `taskfile` VALUES ('30', '11', '28');
INSERT INTO `taskfile` VALUES ('31', '11', '29');
INSERT INTO `taskfile` VALUES ('32', '14', '19');
INSERT INTO `taskfile` VALUES ('33', '14', '28');
INSERT INTO `taskfile` VALUES ('34', '14', '29');
INSERT INTO `taskfile` VALUES ('52', '3', '28');
INSERT INTO `taskfile` VALUES ('53', '3', '36');

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
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of taskgroup
-- ----------------------------
INSERT INTO `taskgroup` VALUES ('4', '6', 'z8S8vrKlt8W3vbC4', '0', '0');
INSERT INTO `taskgroup` VALUES ('7', '6', '5pil5a2j5pKt5pS+5pa55qGI', '0', '0');

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
) ENGINE=InnoDB AUTO_INCREMENT=288 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of taskpop
-- ----------------------------
INSERT INTO `taskpop` VALUES ('1', '2022-12-05 01:55:44', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('2', '2022-12-05 01:56:19', '0', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('3', '2022-12-05 02:01:37', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('4', '2022-12-05 02:01:43', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('5', '2022-12-05 02:02:02', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('6', '2022-12-05 02:02:12', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('7', '2022-12-05 02:02:27', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('8', '2022-12-05 02:02:33', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('9', '2022-12-05 02:03:43', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('10', '2022-12-05 02:03:51', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('11', '2022-12-05 02:04:00', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('12', '2022-12-05 02:04:06', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('13', '2022-12-05 02:09:26', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('14', '2022-12-05 02:09:32', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('15', '2022-12-05 02:10:26', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('16', '2022-12-05 02:10:29', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('17', '2022-12-05 02:10:33', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('18', '2022-12-05 02:12:14', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('19', '2022-12-05 02:12:17', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('20', '2022-12-05 02:14:45', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('21', '2022-12-05 02:14:50', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('22', '2022-12-05 02:16:18', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('23', '2022-12-05 02:16:29', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('24', '2022-12-05 02:16:37', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('25', '2022-12-05 02:16:42', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('26', '2022-12-05 02:25:45', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('27', '2022-12-05 02:25:50', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('28', '2022-12-05 02:25:56', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('29', '2022-12-05 02:26:02', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('30', '2022-12-05 02:26:51', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('31', '2022-12-05 02:27:25', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('32', '2022-12-05 02:29:23', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('33', '2022-12-05 02:29:28', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('34', '2022-12-05 02:29:37', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('35', '2022-12-05 02:31:42', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('36', '2022-12-05 02:31:46', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('37', '2022-12-05 02:31:59', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('38', '2022-12-05 02:33:26', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('39', '2022-12-05 02:33:32', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('40', '2022-12-05 02:37:36', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('41', '2022-12-05 02:37:41', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('42', '2022-12-05 02:43:13', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('43', '2022-12-05 02:43:15', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('44', '2022-12-05 02:44:49', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('45', '2022-12-05 02:44:56', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('46', '2022-12-05 02:45:51', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('47', '2022-12-05 02:45:58', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('48', '2022-12-05 02:48:47', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('49', '2022-12-05 02:48:52', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('50', '2022-12-05 02:52:46', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('51', '2022-12-05 02:52:50', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('52', '2022-12-05 02:52:55', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('53', '2022-12-05 02:52:59', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('54', '2022-12-05 02:55:17', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('55', '2022-12-05 02:55:29', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('56', '2022-12-05 02:58:27', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('57', '2022-12-05 02:58:31', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('58', '2022-12-05 03:03:02', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('59', '2022-12-05 03:03:11', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('60', '2022-12-05 03:06:09', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('61', '2022-12-05 03:06:15', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('62', '2022-12-05 03:07:05', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('63', '2022-12-05 03:07:12', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('64', '2022-12-05 03:17:06', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('65', '2022-12-05 03:17:13', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('66', '2022-12-05 03:18:29', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('67', '2022-12-05 03:18:35', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('68', '2022-12-05 03:21:30', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('69', '2022-12-05 03:21:33', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('70', '2022-12-05 03:24:24', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('71', '2022-12-05 03:24:27', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('72', '2022-12-05 03:25:43', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('73', '2022-12-05 03:25:46', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('74', '2022-12-05 03:26:18', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('75', '2022-12-05 03:26:27', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('76', '2022-12-05 03:26:38', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('77', '2022-12-05 03:26:43', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('78', '2022-12-05 03:34:59', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('79', '2022-12-05 03:35:05', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('80', '2022-12-05 03:36:27', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('81', '2022-12-05 03:36:31', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('82', '2022-12-05 03:45:08', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('83', '2022-12-05 03:45:12', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('84', '2022-12-05 03:45:24', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('85', '2022-12-05 03:45:28', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('86', '2022-12-05 03:48:42', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('87', '2022-12-05 03:48:47', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('88', '2022-12-05 03:49:09', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('89', '2022-12-05 03:49:15', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('90', '2022-12-05 03:52:52', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('91', '2022-12-05 03:52:57', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('92', '2022-12-05 03:52:59', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('93', '2022-12-05 03:53:01', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('94', '2022-12-05 03:53:02', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('95', '2022-12-05 04:00:17', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('96', '2022-12-05 04:00:19', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('97', '2022-12-05 04:01:55', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('98', '2022-12-05 04:03:22', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('99', '2022-12-05 04:11:34', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('100', '2022-12-05 04:12:06', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('101', '2022-12-05 04:12:29', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('102', '2022-12-05 04:12:31', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('103', '2022-12-05 04:16:43', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('104', '2022-12-05 04:16:50', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('105', '2022-12-05 04:17:09', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('106', '2022-12-05 04:23:26', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('107', '2022-12-05 04:23:30', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('108', '2022-12-05 04:24:21', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('109', '2022-12-05 04:24:27', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('110', '2022-12-05 04:26:26', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('111', '2022-12-05 04:26:33', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('112', '2022-12-05 04:27:37', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('113', '2022-12-05 04:27:49', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('114', '2022-12-05 04:32:58', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('115', '2022-12-05 04:33:02', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('116', '2022-12-05 04:34:44', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('117', '2022-12-05 04:40:41', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('118', '2022-12-05 04:49:09', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('119', '2022-12-05 04:49:56', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('120', '2022-12-05 04:55:07', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('121', '2022-12-05 04:56:12', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('122', '2022-12-05 04:56:20', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('123', '2022-12-05 05:04:15', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('124', '2022-12-05 05:04:27', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('125', '2022-12-05 05:20:45', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('126', '2022-12-05 05:20:47', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('127', '2022-12-05 05:22:56', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('128', '2022-12-05 05:23:29', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('129', '2022-12-05 05:24:20', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('130', '2022-12-05 05:26:16', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('131', '2022-12-05 05:26:23', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('132', '2022-12-05 05:26:29', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('133', '2022-12-05 05:26:49', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('134', '2022-12-05 05:26:53', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('135', '2022-12-05 05:27:03', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('136', '2022-12-05 05:27:12', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('137', '2022-12-05 05:27:28', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('138', '2022-12-05 05:27:34', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('139', '2022-12-05 05:27:54', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('140', '2022-12-05 05:27:57', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('141', '2022-12-05 05:28:00', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('142', '2022-12-05 05:28:03', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('143', '2022-12-05 05:28:05', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('144', '2022-12-05 05:28:07', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('145', '2022-12-05 05:28:08', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('146', '2022-12-05 05:28:09', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('147', '2022-12-05 05:28:10', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('148', '2022-12-05 05:28:11', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('149', '2022-12-05 05:28:15', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('150', '2022-12-05 05:28:19', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('151', '2022-12-05 05:28:22', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('152', '2022-12-05 05:28:23', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('153', '2022-12-05 05:28:24', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('154', '2022-12-05 05:28:24', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('155', '2022-12-05 05:28:31', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('156', '2022-12-05 05:28:31', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('157', '2022-12-05 05:28:35', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('158', '2022-12-05 05:28:35', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('159', '2022-12-05 05:28:36', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('160', '2022-12-05 05:28:36', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('161', '2022-12-05 05:28:55', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('162', '2022-12-05 05:28:57', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('163', '2022-12-05 05:28:58', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('164', '2022-12-05 05:28:59', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('165', '2022-12-05 05:29:00', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('166', '2022-12-05 05:29:02', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('167', '2022-12-05 05:29:14', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('168', '2022-12-05 05:29:24', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('169', '2022-12-05 05:29:25', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('170', '2022-12-05 05:29:27', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('171', '2022-12-05 05:29:29', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('172', '2022-12-05 05:29:30', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('173', '2022-12-05 05:29:32', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('174', '2022-12-05 05:29:33', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('175', '2022-12-05 05:29:34', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('176', '2022-12-05 05:29:35', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('177', '2022-12-05 05:29:36', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('178', '2022-12-05 05:29:37', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('179', '2022-12-05 05:29:38', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('180', '2022-12-05 05:29:39', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('181', '2022-12-05 05:29:56', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('182', '2022-12-05 05:29:58', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('183', '2022-12-05 05:29:59', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('184', '2022-12-05 05:30:00', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('185', '2022-12-05 05:30:01', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('186', '2022-12-05 05:30:02', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('187', '2022-12-05 05:30:03', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('188', '2022-12-05 05:30:05', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('189', '2022-12-05 05:30:06', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('190', '2022-12-05 05:30:07', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('191', '2022-12-05 05:30:08', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('192', '2022-12-05 05:30:09', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('193', '2022-12-05 05:30:10', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('194', '2022-12-05 05:30:11', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('195', '2022-12-05 05:30:13', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('196', '2022-12-05 05:30:15', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('197', '2022-12-05 05:30:16', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('198', '2022-12-05 05:30:17', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('199', '2022-12-05 05:30:19', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('200', '2022-12-05 05:30:20', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('201', '2022-12-05 05:30:21', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('202', '2022-12-05 05:30:22', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('203', '2022-12-05 05:30:23', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('204', '2022-12-05 05:30:24', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('205', '2022-12-05 05:30:25', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('206', '2022-12-05 05:30:26', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('207', '2022-12-05 05:30:27', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('208', '2022-12-05 05:30:28', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('209', '2022-12-05 05:30:29', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('210', '2022-12-05 05:30:30', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('211', '2022-12-05 05:30:31', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('212', '2022-12-05 05:30:35', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('213', '2022-12-05 05:30:37', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('214', '2022-12-05 05:30:38', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('215', '2022-12-05 05:31:28', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('216', '2022-12-05 05:31:30', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('217', '2022-12-05 05:31:31', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('218', '2022-12-05 05:31:32', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('219', '2022-12-05 05:31:32', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('220', '2022-12-05 05:31:33', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('221', '2022-12-05 05:31:34', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('222', '2022-12-05 05:31:35', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('223', '2022-12-05 05:31:38', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('224', '2022-12-05 05:41:03', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('225', '2022-12-05 05:41:04', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('226', '2022-12-05 05:41:05', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('227', '2022-12-05 05:41:14', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('228', '2022-12-05 05:41:14', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('229', '2022-12-05 05:41:16', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('230', '2022-12-05 05:41:18', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('231', '2022-12-05 05:41:20', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('232', '2022-12-05 05:41:23', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('233', '2022-12-05 05:41:26', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('234', '2022-12-05 05:41:29', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('235', '2022-12-05 05:41:31', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('236', '2022-12-05 05:41:34', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('237', '2022-12-05 05:41:38', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('238', '2022-12-05 05:41:44', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('239', '2022-12-05 05:41:56', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('240', '2022-12-05 05:42:04', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('241', '2022-12-05 05:42:16', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('242', '2022-12-05 05:42:34', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('243', '2022-12-05 05:42:49', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('244', '2022-12-05 05:43:18', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('245', '2022-12-05 05:43:22', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('246', '2022-12-05 05:46:07', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('247', '2022-12-05 05:55:56', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('248', '2022-12-05 05:56:10', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('249', '2022-12-05 05:56:11', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('250', '2022-12-05 05:56:12', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('251', '2022-12-05 05:56:14', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('252', '2022-12-05 05:56:15', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('253', '2022-12-05 05:56:17', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('254', '2022-12-05 05:56:22', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('255', '2022-12-05 05:56:24', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('256', '2022-12-05 05:56:25', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('257', '2022-12-05 05:56:28', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('258', '2022-12-05 05:56:29', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('259', '2022-12-05 05:56:31', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('260', '2022-12-05 05:56:33', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('261', '2022-12-05 05:56:35', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('262', '2022-12-05 06:08:13', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('263', '2022-12-05 06:10:59', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('264', '2022-12-05 06:13:08', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('265', '2022-12-05 06:13:11', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('266', '2022-12-05 06:13:18', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('267', '2022-12-05 06:13:23', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('268', '2022-12-05 06:13:27', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('269', '2022-12-05 06:13:29', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('270', '2022-12-05 06:13:31', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('271', '2022-12-05 06:14:19', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('272', '2022-12-05 06:14:24', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('273', '2022-12-05 06:15:14', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('274', '2022-12-05 06:15:27', '3', '0', '6', null, null, '1', '0', null, null, '0', '0', 'webstart');
INSERT INTO `taskpop` VALUES ('276', '2022-12-06 02:14:18', '0', '0', '6', '82a04a4e8389b605fc35adf3b6852e4c|7b7c80574db5f6d7d3b7e8e534c76a3a|ed024ae3ae6c6eceb2b94019b727be61', 'http://192.168.3.211:12080/mp3/6/b9c7bbd2bcb6d8bcd0a1c4ae2d4465636973696f6e73202020c7b0d7e0becdb0aec9cf20b3acd4dec5aec9f920bbbdd0d1c1cbced2b5c4c1e9bbea2e6d7033.mp3T,236|http://192.168.3.211:12080/mp3/6/536f756ca1a36d616e2d4265617420497420c5aec9f9cae3c7e9b0e6206d6ad3c0b4b9b2bbd0e02e6d7033.mp3T,237', '2', '2', '127.0.0.1', '6006', '300', '3', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('277', '2022-12-06 02:35:11', '0', '0', '6', '82a04a4e8389b605fc35adf3b6852e4c|7b7c80574db5f6d7d3b7e8e534c76a3a|ed024ae3ae6c6eceb2b94019b727be61', 'http://192.168.3.211:12080/mp3/6/b9c7bbd2bcb6d8bcd0a1c4ae2d4465636973696f6e73202020c7b0d7e0becdb0aec9cf20b3acd4dec5aec9f920bbbdd0d1c1cbced2b5c4c1e9bbea2e6d7033.mp3T,236|http://192.168.3.211:12080/mp3/6/536f756ca1a36d616e2d4265617420497420c5aec9f9cae3c7e9b0e6206d6ad3c0b4b9b2bbd0e02e6d7033.mp3T,237', '2', '2', '127.0.0.1', '6006', '3000', '3', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('278', '2022-12-06 02:38:49', '0', '0', '6', '82a04a4e8389b605fc35adf3b6852e4c|7b7c80574db5f6d7d3b7e8e534c76a3a|ed024ae3ae6c6eceb2b94019b727be61', 'http://192.168.3.211:12080/mp3/6/b9c7bbd2bcb6d8bcd0a1c4ae2d4465636973696f6e73202020c7b0d7e0becdb0aec9cf20b3acd4dec5aec9f920bbbdd0d1c1cbced2b5c4c1e9bbea2e6d7033.mp3T,236|http://192.168.3.211:12080/mp3/6/536f756ca1a36d616e2d4265617420497420c5aec9f9cae3c7e9b0e6206d6ad3c0b4b9b2bbd0e02e6d7033.mp3T,237', '2', '2', '127.0.0.1', '6006', '3000', '3', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('279', '2022-12-06 02:44:08', '0', '0', '6', '82a04a4e8389b605fc35adf3b6852e4c|7b7c80574db5f6d7d3b7e8e534c76a3a|ed024ae3ae6c6eceb2b94019b727be61', 'http://192.168.3.211:12080/mp3/6/b9c7bbd2bcb6d8bcd0a1c4ae2d4465636973696f6e73202020c7b0d7e0becdb0aec9cf20b3acd4dec5aec9f920bbbdd0d1c1cbced2b5c4c1e9bbea2e6d7033.mp3T,236|http://192.168.3.211:12080/mp3/6/536f756ca1a36d616e2d4265617420497420c5aec9f9cae3c7e9b0e6206d6ad3c0b4b9b2bbd0e02e6d7033.mp3T,237', '2', '2', '127.0.0.1', '6006', '3000', '3', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('280', '2022-12-06 02:47:26', '0', '0', '6', '82a04a4e8389b605fc35adf3b6852e4c|7b7c80574db5f6d7d3b7e8e534c76a3a|ed024ae3ae6c6eceb2b94019b727be61', 'http://192.168.3.211:12080/mp3/6/b9c7bbd2bcb6d8bcd0a1c4ae2d4465636973696f6e73202020c7b0d7e0becdb0aec9cf20b3acd4dec5aec9f920bbbdd0d1c1cbced2b5c4c1e9bbea2e6d7033.mp3T,236|http://192.168.3.211:12080/mp3/6/536f756ca1a36d616e2d4265617420497420c5aec9f9cae3c7e9b0e6206d6ad3c0b4b9b2bbd0e02e6d7033.mp3T,237', '2', '2', '127.0.0.1', '6006', '3000', '3', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('281', '2022-12-06 02:47:52', '280', '0', '6', null, null, '2', '0', '127.0.0.1', '6006', '0', '0', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('282', '2022-12-06 02:47:57', '280', '0', '6', null, null, '2', '0', '127.0.0.1', '6006', '0', '0', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('283', '2022-12-06 02:47:58', '280', '0', '6', null, null, '2', '0', '127.0.0.1', '6006', '0', '0', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('284', '2022-12-06 02:47:59', '280', '0', '6', null, null, '2', '0', '127.0.0.1', '6006', '0', '0', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('285', '2022-12-06 02:48:10', '280', '0', '6', null, null, '2', '0', '127.0.0.1', '6006', '0', '0', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('286', '2022-12-06 02:50:56', '0', '0', '6', '82a04a4e8389b605fc35adf3b6852e4c|7b7c80574db5f6d7d3b7e8e534c76a3a|ed024ae3ae6c6eceb2b94019b727be61', 'http://192.168.3.211:12080/mp3/6/b9c7bbd2bcb6d8bcd0a1c4ae2d4465636973696f6e73202020c7b0d7e0becdb0aec9cf20b3acd4dec5aec9f920bbbdd0d1c1cbced2b5c4c1e9bbea2e6d7033.mp3T,236|http://192.168.3.211:12080/mp3/6/536f756ca1a36d616e2d4265617420497420c5aec9f9cae3c7e9b0e6206d6ad3c0b4b9b2bbd0e02e6d7033.mp3T,237', '2', '2', '127.0.0.1', '6006', '3000', '3', 'temp_task_start');
INSERT INTO `taskpop` VALUES ('287', '2022-12-06 02:51:14', '286', '0', '6', null, null, '2', '0', '127.0.0.1', '6006', '0', '0', 'temp_task_start');

-- ----------------------------
-- Table structure for `taskseed`
-- ----------------------------
DROP TABLE IF EXISTS `taskseed`;
CREATE TABLE `taskseed` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `taskid` int(11) NOT NULL,
  `devseedid` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of taskseed
-- ----------------------------
INSERT INTO `taskseed` VALUES ('25', '10', '10');
INSERT INTO `taskseed` VALUES ('26', '10', '11');
INSERT INTO `taskseed` VALUES ('27', '10', '12');
INSERT INTO `taskseed` VALUES ('28', '11', '10');
INSERT INTO `taskseed` VALUES ('29', '11', '11');
INSERT INTO `taskseed` VALUES ('30', '11', '12');
INSERT INTO `taskseed` VALUES ('31', '14', '10');
INSERT INTO `taskseed` VALUES ('32', '14', '11');
INSERT INTO `taskseed` VALUES ('33', '14', '12');
INSERT INTO `taskseed` VALUES ('45', '3', '10');
INSERT INTO `taskseed` VALUES ('46', '3', '11');
INSERT INTO `taskseed` VALUES ('47', '3', '12');

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
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of userfile
-- ----------------------------
INSERT INTO `userfile` VALUES ('13', '4', 'U291bKGjbWFuLUJlYXQgSXQgxa7J+crjx+mw5iBtatPAtLmyu9DgLm1wMw==', 'mp3/4/536f756ca1a36d616e2d4265617420497420c5aec9f9cae3c7e9b0e6206d6ad3c0b4b9b2bbd0e02e6d7033.mp3T', '237', 'G:/QTpro/Adore_mix/etc/docroot/mp3/4/536f756ca1a36d616e2d4265617420497420c5aec9f9cae3c7e9b0e6206d6ad3c0b4b9b2bbd0e02e6d7033.mp3T', '2022-11-17 07:06:42', '1', '-1', '1', '3760377');
INSERT INTO `userfile` VALUES ('14', '4', 'Q3J1c2hlZCAtIEV2ZW5pbmcubXAz', 'mp3/4/43727573686564202d204576656e696e672e6d7033.mp3T', '237', 'G:/QTpro/Adore_mix/etc/docroot/mp3/4/43727573686564202d204576656e696e672e6d7033.mp3T', '2022-11-17 07:07:00', '1', '-1', '1', '3767901');
INSERT INTO `userfile` VALUES ('15', '4', 'S2VrZSBQYWxtZXItRmlyc3QgQ3J1c2gubXAz', 'mp3/4/4b656b652050616c6d65722d46697273742043727573682e6d7033.mp3T', '235', 'G:/QTpro/Adore_mix/etc/docroot/mp3/4/4b656b652050616c6d65722d46697273742043727573682e6d7033.mp3T', '2022-11-17 08:52:16', '1', '-1', '1', '3734464');
INSERT INTO `userfile` VALUES ('16', '4', 'YSByaWRlIGluIHRoZSBzbm93IC0gc2FyYWggY29ubm9yLm1wMw==', 'mp3/4/61207269646520696e2074686520736e6f77202d20736172616820636f6e6e6f722e6d7033.mp3T', '244', 'G:/QTpro/Adore_mix/etc/docroot/mp3/4/61207269646520696e2074686520736e6f77202d20736172616820636f6e6e6f722e6d7033.mp3T', '2022-11-19 05:09:24', '1', '-1', '1', '3876152');
INSERT INTO `userfile` VALUES ('17', '4', 'uce70ry22LzQocSuLURlY2lzaW9ucyAgIMew1+C+zbCuyc8gs6zU3sWuyfkgu73Q0cHLztK1xMHpu+oubXAz', 'mp3/4/b9c7bbd2bcb6d8bcd0a1c4ae2d4465636973696f6e73202020c7b0d7e0becdb0aec9cf20b3acd4dec5aec9f920bbbdd0d1c1cbced2b5c4c1e9bbea2e6d7033.mp3T', '236', 'G:/QTpro/Adore_mix/etc/docroot/mp3/4/b9c7bbd2bcb6d8bcd0a1c4ae2d4465636973696f6e73202020c7b0d7e0becdb0aec9cf20b3acd4dec5aec9f920bbbdd0d1c1cbced2b5c4c1e9bbea2e6d7033.mp3T', '2022-11-20 23:01:34', '1', '-1', '1', '3753690');
INSERT INTO `userfile` VALUES ('18', '4', 'tu3C3su5xa7J+TIwMTYtUmVhbCBPICAgVmlzaG55YS5tcDM=', 'mp3/4/b6edc2decbb9c5aec9f9323031362d5265616c204f202020566973686e79612e6d7033.mp3T', '242', 'G:/QTpro/Adore_mix/etc/docroot/mp3/4/b6edc2decbb9c5aec9f9323031362d5265616c204f202020566973686e79612e6d7033.mp3T', '2022-11-20 23:02:09', '1', '-1', '1', '3848985');
INSERT INTO `userfile` VALUES ('19', '6', 'suLK1A==', 'mp3/6/b2e2cad4.mp3T', '2', 'G:/QTpro/Adore_mix/etc/docroot/mp3/6/b2e2cad4.mp3T', '2022-11-21 00:50:12', '1', '-1', '1', '3760');
INSERT INTO `userfile` VALUES ('28', '6', 'uce70ry22LzQocSuLURlY2lzaW9ucyAgIMew1+C+zbCuyc8gs6zU3sWuyfkgu73Q0cHLztK1xMHpu+oubXAz', 'mp3/6/b9c7bbd2bcb6d8bcd0a1c4ae2d4465636973696f6e73202020c7b0d7e0becdb0aec9cf20b3acd4dec5aec9f920bbbdd0d1c1cbced2b5c4c1e9bbea2e6d7033.mp3T', '236', 'G:/QTpro/Adore_mix/etc/docroot/mp3/6/b9c7bbd2bcb6d8bcd0a1c4ae2d4465636973696f6e73202020c7b0d7e0becdb0aec9cf20b3acd4dec5aec9f920bbbdd0d1c1cbced2b5c4c1e9bbea2e6d7033.mp3T', '2022-12-03 01:47:39', '1', '-1', '1', '3753690');
INSERT INTO `userfile` VALUES ('29', '6', 'S2F0ZSBSdXNieS1GYXJld2VsbC5tcDM=', 'mp3/6/4b6174652052757362792d4661726577656c6c2e6d7033.mp3T', '335', 'G:/QTpro/Adore_mix/etc/docroot/mp3/6/4b6174652052757362792d4661726577656c6c2e6d7033.mp3T', '2022-12-03 01:51:20', '1', '-1', '1', '5341517');
INSERT INTO `userfile` VALUES ('34', '6', 'MDAwMDExMTIyMg==', 'mp3/6/30303030313131323232.mp3T', '12', 'G:/QTpro/Adore_mix/etc/docroot/mp3/6/30303030313131323232.mp3T', '2022-12-05 04:54:34', '1', '-1', '1', '164257');
INSERT INTO `userfile` VALUES ('35', '6', 'MDAwMDExMTIyMjIyMg==', 'mp3/6/30303030313131323232323232.mp3T', '27', 'G:/QTpro/Adore_mix/etc/docroot/mp3/6/30303030313131323232323232.mp3T', '2022-12-05 04:54:43', '1', '-1', '1', '406673');
INSERT INTO `userfile` VALUES ('36', '6', 'U291bKGjbWFuLUJlYXQgSXQgxa7J+crjx+mw5iBtatPAtLmyu9DgLm1wMw==', 'mp3/6/536f756ca1a36d616e2d4265617420497420c5aec9f9cae3c7e9b0e6206d6ad3c0b4b9b2bbd0e02e6d7033.mp3T', '237', 'G:/QTpro/Adore_mix/etc/docroot/mp3/6/536f756ca1a36d616e2d4265617420497420c5aec9f9cae3c7e9b0e6206d6ad3c0b4b9b2bbd0e02e6d7033.mp3T', '2022-12-05 05:22:22', '1', '-1', '1', '3760377');
INSERT INTO `userfile` VALUES ('37', '6', 'MDAwMDExMTIyMjIyMjExMTIyMTIxMTExMjEy', 'mp3/6/303030303131313232323232323131313232313231313131323132.mp3T', '9', 'G:/QTpro/Adore_mix/etc/docroot/mp3/6/303030303131313232323232323131313232313231313131323132.mp3T', '2023-01-07 19:26:45', '1', '-1', '1', '116191');

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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of warregister
-- ----------------------------
INSERT INTO `warregister` VALUES ('1', '1', '2', '3', '4', '5', '6', '7');
