# Host: 127.0.0.1  (Version 5.6.13)
# Date: 2018-07-09 20:59:17
# Generator: MySQL-Front 6.0  (Build 2.20)


#
# Structure for table "tb_album"
#

DROP TABLE IF EXISTS `tb_album`;
CREATE TABLE `tb_album` (
  `id` mediumint(8) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL COMMENT '相册名称',
  `cover` varchar(70) NOT NULL COMMENT '相册封面',
  `posttime` datetime NOT NULL,
  `ishide` tinyint(1) NOT NULL,
  `rank` tinyint(3) NOT NULL DEFAULT '0',
  `photonum` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `tb_album_posttime` (`posttime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

#
# Data for table "tb_album"
#


#
# Structure for table "tb_comments"
#

DROP TABLE IF EXISTS `tb_comments`;
CREATE TABLE `tb_comments` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `obj_pk` bigint(20) NOT NULL DEFAULT '0',
  `reply_pk` bigint(20) NOT NULL DEFAULT '0',
  `reply_fk` bigint(20) NOT NULL DEFAULT '0',
  `user_id` bigint(20) NOT NULL,
  `comment` longtext NOT NULL,
  `submittime` datetime NOT NULL,
  `ipaddress` varchar(255) DEFAULT NULL,
  `is_public` tinyint(4) NOT NULL DEFAULT '0',
  `is_removed` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

#
# Data for table "tb_comments"
#


#
# Structure for table "tb_link"
#

DROP TABLE IF EXISTS `tb_link`;
CREATE TABLE `tb_link` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `sitename` varchar(80) NOT NULL DEFAULT '' COMMENT '网站名字',
  `url` varchar(200) NOT NULL DEFAULT '' COMMENT '友链URL地址',
  `rank` tinyint(4) NOT NULL DEFAULT '0' COMMENT '排序值',
  `siteavator` varchar(200) NOT NULL DEFAULT '',
  `sitedesc` varchar(300) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

#
# Data for table "tb_link"
#


#
# Structure for table "tb_mood"
#

DROP TABLE IF EXISTS `tb_mood`;
CREATE TABLE `tb_mood` (
  `id` mediumint(8) NOT NULL AUTO_INCREMENT,
  `content` text CHARACTER SET utf8 NOT NULL,
  `cover` varchar(70) CHARACTER SET utf8 NOT NULL DEFAULT '/static/upload/defaultcover.png' COMMENT '说说图片',
  `posttime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '发布时间',
  PRIMARY KEY (`id`),
  KEY `tb_mood_posttime` (`posttime`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

#
# Data for table "tb_mood"
#


#
# Structure for table "tb_option"
#

DROP TABLE IF EXISTS `tb_option`;
CREATE TABLE `tb_option` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL DEFAULT '',
  `value` text NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;

#
# Data for table "tb_option"
#

INSERT INTO `tb_option` VALUES (1,'sitename','inana用心交织的生活'),(2,'siteurl','https://inana.top/'),(3,'subtitle','带着她和她去旅行'),(4,'pagesize','15'),(5,'keywords','Python,MySQL,Golang,Windows,Linux'),(6,'description','来一场说走就走的旅行'),(8,'theme','double'),(9,'timezone','8'),(10,'stat','<script language=\"javascript\" type=\"text/javascript\" src=\"http://js.users.51.la/17253002.js\"></script>\r\n<noscript><a href=\"http://www.51.la/?17253002\" target=\"_blank\"><img alt=\"&#x6211;&#x8981;&#x5566;&#x514D;&#x8D39;&#x7EDF;&#x8BA1;\" src=\"http://img.users.51.la/17253002.asp\" style=\"border:none\" /></a></noscript>'),(11,'weibo','https://weibo.com/p/1005051484763434'),(12,'github','https://github.com/griffin702'),(13,'duoshuo','inana'),(14,'albumsize','9'),(15,'nickname','云丶先生');

#
# Structure for table "tb_permission"
#

DROP TABLE IF EXISTS `tb_permission`;
CREATE TABLE `tb_permission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(20) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

#
# Data for table "tb_permission"
#

INSERT INTO `tb_permission` VALUES (1,'user'),(2,'article'),(3,'album'),(4,'link'),(5,'mood'),(6,'tag'),(7,'system');

#
# Structure for table "tb_photo"
#

DROP TABLE IF EXISTS `tb_photo`;
CREATE TABLE `tb_photo` (
  `id` mediumint(8) NOT NULL AUTO_INCREMENT,
  `albumid` mediumint(8) NOT NULL COMMENT '所属相册ID',
  `des` varchar(100) NOT NULL COMMENT '照片描述',
  `posttime` datetime NOT NULL COMMENT '上传时间',
  `url` varchar(70) NOT NULL COMMENT '照片URL地址',
  PRIMARY KEY (`id`),
  KEY `tb_photo_posttime` (`posttime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

#
# Data for table "tb_photo"
#


#
# Structure for table "tb_post"
#

DROP TABLE IF EXISTS `tb_post`;
CREATE TABLE `tb_post` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '作者',
  `title` varchar(100) NOT NULL DEFAULT '' COMMENT '标题',
  `color` varchar(7) NOT NULL DEFAULT '' COMMENT '标题颜色',
  `urlname` varchar(100) NOT NULL DEFAULT '' COMMENT 'url名',
  `urltype` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'url访问形式',
  `content` longtext NOT NULL COMMENT '内容',
  `tags` varchar(100) NOT NULL DEFAULT '' COMMENT '标签',
  `posttime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '发布时间',
  `views` bigint(20) NOT NULL DEFAULT '0' COMMENT '查看次数',
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '状态{0:正常,1:草稿,2:回收站}',
  `updated` datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '更新时间',
  `istop` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否置顶',
  `cover` varchar(70) NOT NULL DEFAULT '/static/upload/defaultcover.png' COMMENT '文章封面',
  PRIMARY KEY (`id`),
  KEY `tb_post_urlname` (`urlname`),
  KEY `tb_post_posttime` (`posttime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

#
# Data for table "tb_post"
#


#
# Structure for table "tb_tag"
#

DROP TABLE IF EXISTS `tb_tag`;
CREATE TABLE `tb_tag` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(20) NOT NULL DEFAULT '' COMMENT '标签名',
  `count` mediumint(8) unsigned NOT NULL DEFAULT '0' COMMENT '使用次数',
  PRIMARY KEY (`id`),
  KEY `name` (`name`),
  KEY `tb_tag_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

#
# Data for table "tb_tag"
#


#
# Structure for table "tb_tag_post"
#

DROP TABLE IF EXISTS `tb_tag_post`;
CREATE TABLE `tb_tag_post` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `tagid` mediumint(8) unsigned NOT NULL DEFAULT '0' COMMENT '标签id',
  `postid` mediumint(8) unsigned NOT NULL DEFAULT '0' COMMENT '内容id',
  `poststatus` tinyint(3) NOT NULL DEFAULT '0' COMMENT '内容状态',
  `posttime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '发布时间',
  PRIMARY KEY (`id`),
  KEY `tagid` (`tagid`),
  KEY `postid` (`postid`),
  KEY `tb_tag_post_tagid` (`tagid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

#
# Data for table "tb_tag_post"
#


#
# Structure for table "tb_user"
#

DROP TABLE IF EXISTS `tb_user`;
CREATE TABLE `tb_user` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `username` varchar(15) NOT NULL DEFAULT '',
  `password` varchar(32) NOT NULL DEFAULT '',
  `email` varchar(50) NOT NULL DEFAULT '',
  `lastlogin` datetime NOT NULL,
  `logincount` bigint(20) NOT NULL DEFAULT '0',
  `lastip` varchar(32) NOT NULL DEFAULT '',
  `authkey` varchar(10) NOT NULL DEFAULT '',
  `active` tinyint(4) NOT NULL DEFAULT '0',
  `permission` varchar(100) NOT NULL DEFAULT '',
  `avator` varchar(150) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

#
# Data for table "tb_user"
#

INSERT INTO `tb_user` VALUES (1,'admin','e10adc3949ba59abbe56e057f20f883e','admin@admin.com','2018-07-07 01:19:50',26,'127.0.0.1','',1,'1|2|3|4|5|6|7','/static/upload/smallpic/20180706/1530858688716800600.jpg');
