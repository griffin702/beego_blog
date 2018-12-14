# Host: 127.0.0.1  (Version 5.6.13)
# Date: 2018-07-12 12:58:18
# Generator: MySQL-Front 6.0  (Build 2.20)

CREATE DATABASE IF NOT EXISTS beego_blog;
USE beego_blog;

#
# Structure for table "tb_album"
#

DROP TABLE IF EXISTS `tb_album`;
CREATE TABLE `tb_album` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL DEFAULT '',
  `cover` varchar(70) NOT NULL DEFAULT '',
  `posttime` datetime NOT NULL,
  `ishide` tinyint(4) NOT NULL DEFAULT '0',
  `rank` tinyint(4) NOT NULL DEFAULT '0',
  `photonum` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `tb_album_name` (`name`),
  KEY `tb_album_posttime` (`posttime`),
  KEY `tb_album_ishide` (`ishide`),
  KEY `tb_album_rank` (`rank`),
  KEY `tb_album_photonum` (`photonum`)
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
  `obj_pk_id` bigint(20) NOT NULL,
  `reply_pk` bigint(20) NOT NULL DEFAULT '0',
  `reply_fk` bigint(20) NOT NULL DEFAULT '0',
  `user_id` bigint(20) NOT NULL,
  `comment` longtext NOT NULL,
  `submittime` datetime NOT NULL,
  `ipaddress` varchar(255) DEFAULT NULL,
  `is_removed` tinyint(4) NOT NULL DEFAULT '0',
  `obj_pk_type` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `tb_comments_obj_pk_id` (`obj_pk_id`),
  KEY `tb_comments_reply_pk` (`reply_pk`),
  KEY `tb_comments_reply_fk` (`reply_fk`),
  KEY `tb_comments_user_id` (`user_id`),
  KEY `tb_comments_submittime` (`submittime`),
  KEY `tb_comments_is_removed` (`is_removed`),
  KEY `tb_comments_obj_pk_type` (`obj_pk_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


#
# Data for table "tb_comments"
#


#
# Structure for table "tb_link"
#

DROP TABLE IF EXISTS `tb_link`;
CREATE TABLE `tb_link` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `sitename` varchar(80) NOT NULL DEFAULT '',
  `siteavator` varchar(200) NOT NULL DEFAULT '/static/upload/default/user-default-60x60.png',
  `url` varchar(200) NOT NULL DEFAULT '',
  `sitedesc` varchar(300) NOT NULL DEFAULT '',
  `rank` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `tb_link_sitename` (`sitename`),
  KEY `tb_link_url` (`url`),
  KEY `tb_link_rank` (`rank`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

#
# Data for table "tb_link"
#

INSERT INTO `tb_link` VALUES (1,'爱在发烧','/static/upload/smallpic/20180619/1529369471932023700.jpg','http://azfashao.com/','一个非常棒的站点，博主也很厉害',99),(2,'AN STUDIO','/static/upload/smallpic/20180621/1529576340049076300.jpg','//shop59002320.taobao.com','外设韩国原单店铺',100);

#
# Structure for table "tb_mood"
#

DROP TABLE IF EXISTS `tb_mood`;
CREATE TABLE `tb_mood` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `content` longtext NOT NULL,
  `cover` varchar(70) NOT NULL DEFAULT '/static/upload/default/blog-default-0.png',
  `posttime` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `tb_mood_posttime` (`posttime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

#
# Data for table "tb_mood"
#


#
# Structure for table "tb_option"
#

DROP TABLE IF EXISTS `tb_option`;
CREATE TABLE `tb_option` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `value` longtext NOT NULL,
  PRIMARY KEY (`id`),
  KEY `tb_option_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

#
# Data for table "tb_option"
#

INSERT INTO `tb_option` VALUES (1,'sitename','inana用心交织的生活'),(2,'siteurl','https://inana.top/'),(3,'subtitle','带着她和她去旅行'),(4,'pagesize','15'),(5,'keywords','Python,MySQL,Golang,Windows,Linux'),(6,'description','来一场说走就走的旅行'),(7,'theme','double'),(8,'timezone','8'),(9,'stat',''),(10,'weibo','https://weibo.com/p/1005051484763434'),(11,'github','https://github.com/griffin702'),(12,'mybirth','1987-09-30'),(13,'albumsize','9'),(14,'nickname','云丶先生'),(15,'myoldcity','湖北省 黄石市'),(16,'mycity','湖北省 武汉市'),(17,'myprifessional','游戏运维攻城师'),(18,'myworkdesc','1、Windows、Linux服务器运维，主要包括IIS、Apache、Nginx、Firewall、MySQL、SQLServer等常用服务。
2、日常备份与灾备恢复等确保数据安全，以及DBA相关其他职能。
3、负责公司内部网络运维，硬件维护、内外网分离以及常用第三方软件运维，主要包括SVN、FTP、BugFree、企业邮箱等服务。
4、业务线部分Golang服务端维护及二次开发。'),(19,'mylang','Python、Golang、SQL、Shell'),(20,'mylike','旅行、游戏、技术');

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

INSERT INTO `tb_permission` VALUES (1,'user'),(2,'article'),(3,'album'),(4,'link'),(5,'mood'),(6,'tag'),(7,'system'),(8,'fileupload');

#
# Structure for table "tb_photo"
#

DROP TABLE IF EXISTS `tb_photo`;
CREATE TABLE `tb_photo` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `albumid` bigint(20) NOT NULL DEFAULT '0',
  `des` varchar(100) NOT NULL DEFAULT '',
  `posttime` datetime NOT NULL,
  `url` varchar(70) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `tb_photo_albumid` (`albumid`),
  KEY `tb_photo_des` (`des`),
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
  `user_id` bigint(20) NOT NULL,
  `title` varchar(100) NOT NULL DEFAULT '',
  `color` varchar(7) NOT NULL DEFAULT '',
  `urlname` varchar(100) NOT NULL DEFAULT '',
  `urltype` tinyint(4) NOT NULL DEFAULT '0',
  `content` longtext NOT NULL,
  `tags` varchar(100) NOT NULL DEFAULT '',
  `posttime` datetime NOT NULL,
  `views` bigint(20) NOT NULL DEFAULT '0',
  `status` tinyint(4) NOT NULL DEFAULT '0',
  `updated` datetime NOT NULL,
  `istop` tinyint(4) NOT NULL DEFAULT '0',
  `cover` varchar(70) NOT NULL DEFAULT '/static/upload/default/blog-default-0.png',
  PRIMARY KEY (`id`),
  KEY `tb_post_user_id` (`user_id`),
  KEY `tb_post_title` (`title`),
  KEY `tb_post_color` (`color`),
  KEY `tb_post_urlname` (`urlname`),
  KEY `tb_post_urltype` (`urltype`),
  KEY `tb_post_tags` (`tags`),
  KEY `tb_post_posttime` (`posttime`),
  KEY `tb_post_views` (`views`),
  KEY `tb_post_status` (`status`),
  KEY `tb_post_updated` (`updated`),
  KEY `tb_post_istop` (`istop`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

#
# Data for table "tb_post"
#


#
# Structure for table "tb_tag"
#

DROP TABLE IF EXISTS `tb_tag`;
CREATE TABLE `tb_tag` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(20) NOT NULL DEFAULT '',
  `count` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `tb_tag_name` (`name`),
  KEY `tb_tag_count` (`count`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

#
# Data for table "tb_tag"
#


#
# Structure for table "tb_tag_post"
#

DROP TABLE IF EXISTS `tb_tag_post`;
CREATE TABLE `tb_tag_post` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `tag_id` bigint(20) NOT NULL DEFAULT '0',
  `postid` bigint(20) NOT NULL DEFAULT '0',
  `poststatus` tinyint(4) NOT NULL DEFAULT '0',
  `posttime` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `tb_tag_post_tag_id` (`tag_id`),
  KEY `tb_tag_post_postid` (`postid`),
  KEY `tb_tag_post_poststatus` (`poststatus`),
  KEY `tb_tag_post_posttime` (`posttime`)
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
  `nickname` varchar(15) NOT NULL DEFAULT '',
  `email` varchar(50) NOT NULL DEFAULT '',
  `lastlogin` datetime NOT NULL,
  `logincount` bigint(20) NOT NULL DEFAULT '0',
  `lastip` varchar(32) NOT NULL DEFAULT '',
  `authkey` varchar(10) NOT NULL DEFAULT '',
  `active` tinyint(4) NOT NULL DEFAULT '0',
  `permission` varchar(100) NOT NULL DEFAULT '',
  `avator` varchar(150) NOT NULL DEFAULT '/static/upload/default/user-default-60x60.png',
  `upcount` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  KEY `tb_user_nickname` (`nickname`),
  KEY `tb_user_email` (`email`),
  KEY `tb_user_lastlogin` (`lastlogin`),
  KEY `tb_user_logincount` (`logincount`),
  KEY `tb_user_lastip` (`lastip`),
  KEY `tb_user_permission` (`permission`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

#
# Data for table "tb_user"
#

INSERT INTO `tb_user` VALUES (1,'admin','e10adc3949ba59abbe56e057f20f883e','云丶先生','117976509@qq.com','2018-07-12 12:55:55',0,'127.0.0.1','',1,'1|2|3|4|5|6|7|8','/static/upload/default/user-default-60x60.png',0);
