 
-- ----------------------------
-- Table structure for `autowarning`
-- ----------------------------
DROP TABLE IF EXISTS `autowarning`;
CREATE TABLE `autowarning` (
  `id` INTEGER  PRIMARY KEY AUTOINCREMENT,
  `userid` int(11) NOT NULL,
  `seed` varchar(100) NOT NULL,
  `url_bihe` varchar(200) NOT NULL DEFAULT 'url',
  `url_duankai` varchar(200) NOT NULL DEFAULT 'url',
  `ip` varchar(45) NOT NULL DEFAULT '0.0.0.0',
  `portct6` int(11) NOT NULL DEFAULT '6',
  `enable` int(11) NOT NULL DEFAULT '0' 
)  ;


DROP TABLE IF EXISTS `group_seed`;
CREATE TABLE `group_seed` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `gid` int(11) NOT NULL,
  `seed` varchar(45) NOT NULL,
  `userid` int(11) NOT NULL,
  `gidseed` varchar(45) NOT NULL DEFAULT 'none',
  `devid` int(11) NOT NULL DEFAULT '0'  
)  ;
INSERT INTO `group_seed` VALUES ('56', '17', '8e6b85a54c36d87080ca19d7495b874e', '6', '178e6b85a54c36d87080ca19d7495b874e', '75');
INSERT INTO `group_seed` VALUES ('57', '18', '8e6b85a54c36d87080ca19d7495b874e', '13', '188e6b85a54c36d87080ca19d7495b874e', '76');
DROP TABLE IF EXISTS `rizhi`;
CREATE TABLE `rizhi` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `userid` int(11) NOT NULL DEFAULT '0',
  `info` varchar(3000) NOT NULL DEFAULT 'noe',
  `kind` int(11) NOT NULL DEFAULT '0',
  `level` int(11) NOT NULL DEFAULT '0',
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP 
)  ;

DROP TABLE IF EXISTS `sbox_device_info`;
CREATE TABLE `sbox_device_info` (
  `id` INTEGER  PRIMARY KEY AUTOINCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '-1',
  `device_type` int(11) NOT NULL DEFAULT '-1',
  `device_status` int(11) NOT NULL DEFAULT '-1',
  `device_name` varchar(45) NOT NULL DEFAULT 'default',
  `device_code` varchar(45) NOT NULL DEFAULT '0000',
  `device_seed` varchar(45) NOT NULL DEFAULT '0000',
  `node_id` int(11) NOT NULL DEFAULT '1',
  `updatetime` datetime NOT NULL DEFAULT  CURRENT_TIMESTAMP    ,
  `tag1` varchar(200) NOT NULL DEFAULT 'default',
  `tag2` varchar(200) NOT NULL DEFAULT 'default',
  `userid_seed` varchar(50) UNIQUE,
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
  `qianfeiinfo` varchar(1000) DEFAULT '正常使用'  
)  ; 

DROP TABLE IF EXISTS `sbox_group`;
CREATE TABLE `sbox_group` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `userid` int(11) NOT NULL DEFAULT '0',
  `group_name` varchar(200) NOT NULL,
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `nodeid` int(11) NOT NULL DEFAULT '-1',
  `msurl` varchar(405) NOT NULL DEFAULT 'none' 
)  ;


DROP TABLE IF EXISTS `sbox_node`;
CREATE TABLE `sbox_node` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
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
  `cdnpath` varchar(100) NOT NULL DEFAULT 'cdn.ployq.com/gsh' 
)  ;
INSERT INTO `sbox_node` VALUES ('1', '服务', '192.168.0.115', '3333', '9003', '9006', '9002', '9003', '1', 'none', '1', '0', '6004', '0');


DROP TABLE IF EXISTS `sbox_users`;
CREATE TABLE `sbox_users` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `user_name` varchar(45) UNIQUE,
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
  `winfo` varchar(1000) NOT NULL DEFAULT 'none' 
)  ;
INSERT INTO `sbox_users` VALUES ('6', 'admin', '123123123', '1', '9', '-1', '-1', '2022-11-21 00:12:47', '0', '1111111111111111111111111111111111111111111111111', 'Tk9USElORw==', '1', '1', '0', '1', 'cdn.ployq.com/gsh', 'e1edf78dcf26e0457880c62aae017bb1a0648bf8', '小播鼠兜兜', 'u1.jpg', 'none');
INSERT INTO `sbox_users` VALUES ('7', 'oxiaomgl', '123123123', '1', '9', '-1', '-99', '2023-01-09 14:07:20', '0', '1111111111111111111111111111111111111111111111111', 'Tk9USElORw==', '1', '1', '0', '1', 'cdn.ployq.com/gsh', 'bb4e56a61b5154127420d0709cbb9761cf8615e3', 'nickname', 'u1.jpg', 'none');
INSERT INTO `sbox_users` VALUES ('8', 'oxiaom4', '123123123', '1', '9', '-1', '5', '2023-01-11 12:36:43', '0', '0111111111111111111111111111111111111111111111111', 'Tk9USElORw==', '1', '1', '0', '1', 'cdn.ployq.com/gsh', 'a090bc25f6f639c07c5372b95c6418438112e769', 'nickname', 'u1.jpg', 'none');
INSERT INTO `sbox_users` VALUES ('13', 'oxiaom6', '123123qq', '0', '800', '5', '6', '2023-09-28 23:40:36', '0', '00000000000000000000000000000000000000000000', 'NOTHING', '1', '1', '0', '1', 'cdn.ployq.com/gsh', '2d59207fc8fac7887a04721fc923c74b48260e50', 'nickname', 'u1.jpg', 'none');
DROP TABLE IF EXISTS `sharefiles`;
CREATE TABLE `sharefiles` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `userid` int(11) NOT NULL DEFAULT '0',
  `path` varchar(2000) NOT NULL DEFAULT 'none',
  `uname` varchar(2000) NOT NULL DEFAULT 'none',
  `detail` varchar(2000) NOT NULL DEFAULT 'none',
  `count` int(11) NOT NULL DEFAULT '0',
  `weight` int(11) NOT NULL DEFAULT '0',
  `fileid` int(11) NOT NULL DEFAULT '0' 
);
DROP TABLE IF EXISTS `swap_info`;
CREATE TABLE `swap_info` (
  `id` INTEGER  PRIMARY KEY AUTOINCREMENT,
  `url` varchar(200) NOT NULL,
  `title` varchar(2000) NOT NULL,
  `type` varchar(45) NOT NULL,
  `to` varchar(200) NOT NULL 
);
INSERT INTO `swap_info` VALUES ('6', 'http://192.168.3.105:12080/31323364313834333137.jpg', '啊实打实发的时代GV送达方刚手打发撒', 'image', '#');
INSERT INTO `swap_info` VALUES ('8', 'http://192.168.3.105:12080/e5beaee4bfa1e688aae59bbe5f3230323331303231313735333234.jpg', '手动阀所发生的胜多负少水电费撒旦法撒旦法', 'image', '#');
INSERT INTO `swap_info` VALUES ('9', 'http://192.168.3.105:12080/e5beaee4bfa1e688aae59bbe5f3230323331303231313735333234.jpg', '啊沙发斯蒂芬斯蒂芬', 'image', '#');
INSERT INTO `swap_info` VALUES ('12', '#', '撒旦法申达股份第三方个短发挂号费挂号费更好111', 'info', '3');
INSERT INTO `swap_info` VALUES ('13', 'http://192.168.3.105:12080/7374617469632f7531.jpg', '', 'touxiang', '#');


DROP TABLE IF EXISTS `task`;
CREATE TABLE `task` (
  `id` INTEGER  PRIMARY KEY AUTOINCREMENT,
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
  `snids` varchar(6000) NOT NULL DEFAULT '0' 
) ;


DROP TABLE IF EXISTS `taskfile`;
CREATE TABLE `taskfile` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `taskid` int(11) NOT NULL,
  `fileid` int(11) NOT NULL 
)  ;


DROP TABLE IF EXISTS `taskgroup`;
CREATE TABLE `taskgroup` (
  `id`  INTEGER  PRIMARY KEY AUTOINCREMENT,
  `userid` int(11) NOT NULL,
  `groupname` varchar(200) NOT NULL DEFAULT 'none',
  `status` int(11) NOT NULL DEFAULT '0',
  `taskids` int(11) NOT NULL DEFAULT '0' 
)  ;

DROP TABLE IF EXISTS `taskpop`;
CREATE TABLE `taskpop` (
  `id` INTEGER  PRIMARY KEY AUTOINCREMENT,
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
  `info` varchar(200) NOT NULL DEFAULT 'none' 
) ;

DROP TABLE IF EXISTS `taskseed`;
CREATE TABLE `taskseed` (
  `id` INTEGER  PRIMARY KEY AUTOINCREMENT,
  `taskid` int(11) NOT NULL,
  `devseedid` int(11) NOT NULL 
)  ;

DROP TABLE IF EXISTS `userfile`;
CREATE TABLE `userfile` (
  `id` INTEGER  PRIMARY KEY AUTOINCREMENT,
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
  `enable` int(11) NOT NULL DEFAULT '1'  
 ) ;
 
 
DROP TABLE IF EXISTS `warning`;
CREATE TABLE `warning` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
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
  `update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP 
) ;

DROP TABLE IF EXISTS `warningplant`;
CREATE TABLE `warningplant` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `snids` varchar(20000) NOT NULL DEFAULT 'none',
  `url` varchar(1000) NOT NULL DEFAULT 'none',
  `name` varchar(200) NOT NULL DEFAULT 'none',
  `userid` int(11) NOT NULL DEFAULT '1',
  `status` int(11) NOT NULL DEFAULT '0' 
);


DROP TABLE IF EXISTS `warregister`;
CREATE TABLE `warregister` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `sn` varchar(32) NOT NULL DEFAULT 'sn',
  `kind` int(11) NOT NULL DEFAULT '0',
  `url` varchar(1000) NOT NULL DEFAULT 'url',
  `devname` varchar(500) NOT NULL DEFAULT 'Device_name',
  `filename` varchar(500) NOT NULL DEFAULT 'File_Name',
  `userid` int(11) NOT NULL DEFAULT '0',
  `fb` int(11) NOT NULL DEFAULT '1' 
);

DROP TABLE IF EXISTS `xieyi_mod`;
CREATE TABLE `xieyi_mod` (
  `id` INTEGER  PRIMARY KEY AUTOINCREMENT,
  `xieyi` longtext NOT NULL,
  `kind` int(11) NOT NULL 
) ;
