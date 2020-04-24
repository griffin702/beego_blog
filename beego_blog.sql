-- MySQL dump 10.13  Distrib 5.6.13, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: beego_blog
-- ------------------------------------------------------
-- Server version	5.6.13

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `tb_album`
--

DROP TABLE IF EXISTS `tb_album`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_album`
--

LOCK TABLES `tb_album` WRITE;
/*!40000 ALTER TABLE `tb_album` DISABLE KEYS */;
INSERT INTO `tb_album` VALUES (1,'家庭','/static/upload/bigsmallpic/20180907/1536309802225600500_small.jpeg','2018-09-04 00:42:50',0,1,11),(2,'长沙行','/static/upload/bigsmallpic/20180913/1536829008659619500_small.jpeg','2018-09-05 16:46:12',0,0,16);
/*!40000 ALTER TABLE `tb_album` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_comments`
--

DROP TABLE IF EXISTS `tb_comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_comments`
--

LOCK TABLES `tb_comments` WRITE;
/*!40000 ALTER TABLE `tb_comments` DISABLE KEYS */;
INSERT INTO `tb_comments` VALUES (1,0,0,0,1,'欢迎各界人士留言，请不要胡乱填写，尊重他人就是尊重自己，祝每一位小伙伴开心顺利！','2018-09-06 16:30:24','219.140.149.212',0,1),(2,0,0,0,2,'友情链接交换吗朋友？https://www.7Ethan.top','2018-09-13 16:49:45','180.166.28.68',0,1),(3,0,2,2,1,'你好，可以，麻烦你的站点做好友链','2018-09-14 09:32:02','171.83.81.49',0,1),(4,4,0,0,3,'good','2018-10-18 11:29:00','183.14.133.79',0,0),(5,14,0,0,4,'aaaa','2018-10-30 08:54:20','116.7.97.220',0,0),(6,14,5,5,4,'不好意思，胡乱写了一条评论','2018-10-30 16:57:58','116.7.97.220',0,0);
/*!40000 ALTER TABLE `tb_comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_link`
--

DROP TABLE IF EXISTS `tb_link`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_link`
--

LOCK TABLES `tb_link` WRITE;
/*!40000 ALTER TABLE `tb_link` DISABLE KEYS */;
INSERT INTO `tb_link` VALUES (1,'爱在发烧','/static/upload/smallpic/20180906/1536222420635390400.jpg','http://azfashao.com/','一个非常棒的站点，博主也很厉害',99),(2,'AN STUDIO','/static/upload/smallpic/20180906/1536222414584019900.jpg','shop59002320.taobao.com','外设韩国原单店铺',100),(3,'7Ethan','/static/upload/smallpic/20180914/1536888919236890700.png','https://www.7ethan.top','很不错的一名野生程序员',0),(4,'360导航','/static/upload/smallpic/20180926/1537932733102310300.png','http://hao.360.cn/','360安全网址',0),(5,'360安全浏览器','/static/upload/smallpic/20180926/1537932721065971300.png','http://se.360.cn/','360安全浏览器',0);
/*!40000 ALTER TABLE `tb_link` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_mood`
--

DROP TABLE IF EXISTS `tb_mood`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_mood` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `content` longtext NOT NULL,
  `cover` varchar(70) NOT NULL DEFAULT '/static/upload/default/blog-default-0.png',
  `posttime` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `tb_mood_posttime` (`posttime`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_mood`
--

LOCK TABLES `tb_mood` WRITE;
/*!40000 ALTER TABLE `tb_mood` DISABLE KEYS */;
INSERT INTO `tb_mood` VALUES (1,'Golang之beego框架开发的博客站点终于给大家见面了。详情请关注本站置顶文章《优雅的语言开发优雅的站点》，由于近期发生了一件一辈子难得遇见的服务器安全事故，本站之前开发阶段所写的文章全部丢失，心情糟糕透了。','','2018-09-06 14:57:50'),(2,'时光流逝，眨眼间已过数十载，青春就这么走了。','','2018-10-24 10:21:17');
/*!40000 ALTER TABLE `tb_mood` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_option`
--

DROP TABLE IF EXISTS `tb_option`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_option` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `value` longtext NOT NULL,
  PRIMARY KEY (`id`),
  KEY `tb_option_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_option`
--

LOCK TABLES `tb_option` WRITE;
/*!40000 ALTER TABLE `tb_option` DISABLE KEYS */;
INSERT INTO `tb_option` VALUES (1,'sitename','inana用心交织的生活'),(2,'siteurl','https://inana.top/'),(3,'subtitle','带着她和她去旅行'),(4,'pagesize','15'),(5,'keywords','Python,MySQL,Golang,Windows,Linux'),(6,'description','来一场说走就走的旅行'),(7,'theme','double'),(8,'timezone','8'),(9,'stat',''),(10,'weibo','https://weibo.com/p/1005051484763434'),(11,'github','https://github.com/griffin702'),(12,'mybirth','1987-09-30'),(13,'albumsize','9'),(14,'nickname','云丶先生'),(15,'myoldcity','湖北省 黄石市'),(16,'mycity','湖北省 武汉市'),(17,'myprifessional','游戏运维攻城师'),(18,'myworkdesc','1、Windows、Linux服务器运维，主要包括IIS、Apache、Nginx、Firewall、MySQL、SQLServer等常用服务。\r\n2、日常备份与灾备恢复等确保数据安全，以及DBA相关其他职能。\r\n3、负责公司内部网络运维，硬件维护、内外网分离以及常用第三方软件运维，主要包括SVN、FTP、BugFree、企业邮箱等服务。\r\n4、业务线部分Golang服务端维护及二次开发。'),(19,'mylang','Python、Golang、SQL、Shell'),(20,'mylike','旅行、游戏、技术');
/*!40000 ALTER TABLE `tb_option` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_permission`
--

DROP TABLE IF EXISTS `tb_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_permission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(20) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_permission`
--

LOCK TABLES `tb_permission` WRITE;
/*!40000 ALTER TABLE `tb_permission` DISABLE KEYS */;
INSERT INTO `tb_permission` VALUES (3,'album'),(2,'article'),(8,'fileupload'),(4,'link'),(5,'mood'),(7,'system'),(6,'tag'),(1,'user');
/*!40000 ALTER TABLE `tb_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_photo`
--

DROP TABLE IF EXISTS `tb_photo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_photo`
--

LOCK TABLES `tb_photo` WRITE;
/*!40000 ALTER TABLE `tb_photo` DISABLE KEYS */;
INSERT INTO `tb_photo` VALUES (1,1,'C0EB6E1E-27E3-476A-9344-C4F18BD8BC53.jpeg','2018-09-07 16:43:22','/static/upload/bigsmallpic/20180907/1536309802225600500.jpeg'),(2,1,'7DC54235-FEC8-4BFE-9E4D-40B76478AE73.jpeg','2018-09-07 16:44:22','/static/upload/bigsmallpic/20180907/1536309861429045700.jpeg'),(3,1,'F4F4F69D-A0C6-4253-92BD-41B73CF8BE68.jpeg','2018-09-07 20:53:16','/static/upload/bigsmallpic/20180907/1536324795636339300.jpeg'),(4,1,'4C080A50-6969-48D8-8D80-41D3534D0706.jpeg','2018-09-07 20:54:12','/static/upload/bigsmallpic/20180907/1536324852622902500.jpeg'),(5,1,'81B03695-7726-4BFE-90BC-5172C342E597.jpeg','2018-09-07 20:54:25','/static/upload/bigsmallpic/20180907/1536324865631214500.jpeg'),(6,1,'A749340A-EA4D-47F2-A6B0-44A218EBDA34.jpeg','2018-09-07 20:54:54','/static/upload/bigsmallpic/20180907/1536324893898901500.jpeg'),(7,1,'8E8D535A-330B-4A5E-9ED7-391D33C9E8BC.jpeg','2018-09-07 20:55:45','/static/upload/bigsmallpic/20180907/1536324945478030500.jpeg'),(8,1,'46255FE7-C825-45BF-9521-6FD333C47031.jpeg','2018-09-07 20:58:08','/static/upload/bigsmallpic/20180907/1536325088417112900.jpeg'),(9,1,'224FBD64-9C1A-4AE3-A3CF-DF194388F1EC.jpeg','2018-09-07 20:58:50','/static/upload/bigsmallpic/20180907/1536325129991951500.jpeg'),(10,1,'5BDBEA2E-9F77-4B76-8794-04F390E8132F.jpeg','2018-09-07 20:59:26','/static/upload/bigsmallpic/20180907/1536325166000170100.jpeg'),(11,1,'06AD5865-2324-480C-BC10-06C7DE3A2C78.jpeg','2018-09-07 21:00:07','/static/upload/bigsmallpic/20180907/1536325207256637100.jpeg'),(12,2,'D092A301-79F5-4A32-853F-8EC46DC84840.jpeg','2018-09-13 16:46:34','/static/upload/bigsmallpic/20180913/1536828393739992500.jpeg'),(16,2,'CFA0BB75-DDCB-4112-B7A1-F5015D07E2CE.jpeg','2018-09-13 16:53:07','/static/upload/bigsmallpic/20180913/1536828787363236500.jpeg'),(17,2,'656E7203-8AD9-467E-88B9-EFF33A4CA950.jpeg','2018-09-13 16:53:23','/static/upload/bigsmallpic/20180913/1536828802709910500.jpeg'),(18,2,'49F35BCB-5A9C-4123-A5C8-CD3DFBED1597.jpeg','2018-09-13 16:53:37','/static/upload/bigsmallpic/20180913/1536828816933609500.jpeg'),(19,2,'DF4EC1C3-362D-40B2-B732-8CBC1FA1BEC2.jpeg','2018-09-13 16:53:51','/static/upload/bigsmallpic/20180913/1536828830756943500.jpeg'),(20,2,'659E4D06-7C9C-4620-A67F-3448C80DA608.jpeg','2018-09-13 16:54:02','/static/upload/bigsmallpic/20180913/1536828841951539500.jpeg'),(21,2,'67D41B16-445F-4335-8E01-CBEF13D5313B.jpeg','2018-09-13 16:54:12','/static/upload/bigsmallpic/20180913/1536828852113975000.jpeg'),(23,2,'6B9E9FCF-CF4F-4190-B69B-2BA289591FE4.jpeg','2018-09-13 16:54:42','/static/upload/bigsmallpic/20180913/1536828881192192000.jpeg'),(24,2,'89E8BEA2-3072-466C-AAF5-B5C7DA860931.jpeg','2018-09-13 16:55:06','/static/upload/bigsmallpic/20180913/1536828905242410500.jpeg'),(25,2,'DEFF86A7-3945-44C2-92C4-74AFE974B34E.jpeg','2018-09-13 16:55:29','/static/upload/bigsmallpic/20180913/1536828927852291500.jpeg'),(26,2,'BECC1629-4D8E-480B-A278-6CC0E8D1D67D.jpeg','2018-09-13 16:55:44','/static/upload/bigsmallpic/20180913/1536828943217519000.jpeg'),(27,2,'2EEF3012-2FC0-4883-953A-3A1BD75A31F6.jpeg','2018-09-13 16:55:59','/static/upload/bigsmallpic/20180913/1536828958410882500.jpeg'),(28,2,'820BA459-1A3B-4703-9535-024352633649.jpeg','2018-09-13 16:56:14','/static/upload/bigsmallpic/20180913/1536828972998816000.jpeg'),(29,2,'E4DA9222-A0C1-4071-8AE2-39C31224CF63.jpeg','2018-09-13 16:56:34','/static/upload/bigsmallpic/20180913/1536828993385206500.jpeg'),(30,2,'EBC5C07C-2A74-4C15-BF95-1E181C84F3FF.jpeg','2018-09-13 16:56:49','/static/upload/bigsmallpic/20180913/1536829008659619500.jpeg'),(31,2,'20DE1497-6366-4AC8-BF57-D7C356A3BBE3.jpeg','2018-09-13 16:57:13','/static/upload/bigsmallpic/20180913/1536829032399311000.jpeg');
/*!40000 ALTER TABLE `tb_photo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_post`
--

DROP TABLE IF EXISTS `tb_post`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_post`
--

LOCK TABLES `tb_post` WRITE;
/*!40000 ALTER TABLE `tb_post` DISABLE KEYS */;
INSERT INTO `tb_post` VALUES (1,1,'站点又重新回来了，必须纪念一下本次事故','#FF6633','',0,'本站又一次与大家见面了，希望新的开始，会给我带来好运，希望本站人气会越来越旺，更希望Golang爱好者的交流会越来越多，这能够让我们共同进步。\r\n\r\n近期发生了特别感动的一件事情，我的站点崩了，何故呢？**中了勒索病毒**，登录服务器发现赫然一封英文勒索信在我的服务器中随处可见，作为一名专业的运维人员，我服了，这是我职业生涯中第一次遇到如此不符合常理的安全事故，以下事故截图供大家观赏。\r\n\r\n![](/static/upload/bigpic/20180907/1536302903028064300_small.jpeg)\r\n\r\n![](/static/upload/bigpic/20180907/1536302942819631300_small.jpeg)\r\n\r\n![](/static/upload/bigpic/20180907/1536302974804257900_small.jpeg)\r\n\r\n受到攻击的服务器不仅是本站这1台，还有另外3台涉及到公司业务的服务器，缓过神来的时候简直不敢相信这是真的，大兄弟，大神啊，你这何必呢？你虽然牛B的让我五体投地，但这世上是有备份这么一回事的，你能赚到什么钱我就想问，我很好奇你能不能再牛b一点把全世界所有的服务器同时攻下再来勒索？你有这能耐你还用得着勒索？我就纳闷了，你攻击我这么一个如此渺小的目标是何必呢？假如所有的运维工作者把备份这项工作都做好了，你的攻击是不是没有意义反而损人不利己成为众矢之的？这种钱你们赚的于心何安。\r\n\r\n哎，公司服务器紧急停服维护，重装系统数据恢复测试开服，你牛B你再来啊（大神，开个玩笑啊，别再找我了，谢谢！）。。\r\n\r\n发发牢骚舒服一点了，公司影响不大，可本站当时还处于开发阶段，备份工作还没开始做，期间写的好几篇文章还有一些心情记录都没了，可惜啊。。遇此一劫，我记录下来最重要的目的还是提醒一下大家重要数据一定要做好异地灾备，有条件的一定要多备份几台甚至定期备份到移动硬盘中确保万无一失，全世界那么多服务器，这些黑客毕竟不是神仙，只要你有备份，遇上这种事，至少不用乖乖去交赎金吧。虽然这种事可遇不可求，还是保险点好。真的碰上了，没有备份，数据又非常重要，你就欲哭无泪了。\r\n\r\n#### 好了，说了那么多废话，总结一句话，重要数据要备份，除此外无解！\r\n\r\n',',记录,','2018-09-06 14:58:19',220,0,'2018-09-13 16:16:35',0,'/static/upload/smallpic/20180906/1536221525710247400.png'),(2,1,'优雅的语言开发优雅的站点','#FF6600','',0,'本站是一款由Go语言的beego框架开发的个人博客型站点，此篇文章长期置顶，记录着站点更新的点点滴滴。\r\n\r\n#### 码云 Source:\r\n[https://gitee.com/griffin702/beego](https://gitee.com/griffin702/beego)\r\n#### Github Source:\r\n[https://github.com/griffin702/beego_blog](https://github.com/griffin702/beego_blog)\r\n\r\n#####默认不自动生成数据库，初次使用时可直接使用项目根目录下的beego_blog.sql手动导入数据库\r\n- 初始管理员账号密码：`admin 123456`\r\n\r\n#### 更新记录\r\n\r\n##### 2018/6/19\r\n1.0.0版本：\r\n1. 修复原项目代码中的BUG\r\n2. 优化整体逻辑及模型\r\n3. 更新新版bootstrap，优化PC与移动端自适应\r\n4. 页面整体优化\r\n\r\n##### 2018/7/10\r\n1. 新增评论模块，功能包括：登录评论，回复，引用，ajax无刷新提交，评论框自适应\r\n2. 继续完善所有模型，将原简单查询赋值改为高级联表外键查询\r\n3. 新增表查询频率很高的表索引，优化查询速度\r\n\r\n##### 2018/7/12\r\n1. 新增ipfilter模块\r\n简介：该模块在某较大规模的服务端线上使用，同时经过多年测试改版积累，逻辑清晰简单，然而稳定性却非常好。\r\n由于本站为个人站点性质，在整体框架不做改动的情况下，针对性改动算法规则，将该模块移植到本站。\r\n功能：IP计数器、访问时间每10次更新1次，10次之间的访问时长进行算法对比，\r\n目前算法为，每10次访问更新访问时间，并对比上次更新过的时间，间隔时长低于10s的被视为异常访问1次，\r\n累计异常达到10次，则全站返回500，默认2分钟后计数器自动归零，目前测试比较稳定。\r\n2. 在ipfilter模块的基础上，实验型植入评论模块，规则仅做小小的修改，异常提交评论每次警告，当超过10次，\r\n则全站会返回500，评论控制台则自然无法访问。\r\n3. 新增用户注册页面\r\n4. 评论列表访问时存在评论条数过大，从而导致表查询较慢，这个问题从两个方向着手处理\r\n	a、优化orm，新增表索引，将所有条件查询的字段都加上索引，优化后，查询速度提升较高。\r\n	b、评论列表分页显示，大大减少单页的查询次数。\r\n5. 修复部分敏感信息签名的bug\r\n\r\n##### 2018/7/20\r\n1. 后台管理页面重新排版，确保PC端与移动端都能正常自适应\r\n2. 原ueditor编辑器上传需要flash支持，目前很多浏览器开始弃用flash接口，无法在移动端上传，故改用xheditor。\r\n3. 添加图片预览界面，友好提示等优化体验\r\n4. 修复时区不一致问题\r\n5. 原上传模块太简陋，重新独立upload模块，并友好支持xheditor编辑器上传图片\r\n\r\n##### 2018/8/24\r\n1. 编辑器改用markdown，个人感觉更流畅一些\r\n2. 修复部分已知bug\r\n3. 新增归类页面，将标签集中起来\r\n4. 改用最新版lightgallery，新版功能更强大，且更好用，特别适合mood展示\r\n5. 页面样式整体细节优化\r\n\r\n##### 2018/9/9\r\n1. 文章页配图修改为可点击查看大图\r\n2. 修改upload模块，将文章页上传类型修改为保存小图，提供文章默认显示\r\n3. 上传图片长宽度限制为最高1280像素\r\n4. 修复部分已知bug\r\n\r\n##### 2018/9/13\r\n1. 新增FFmpeg视频截图功能，解决了视频上传没有封面的问题\r\n2. 修复部分已知bug\r\n\r\n##### 2018/9/25\r\n1. 修复文章、心情模块的内容字段，仅保存md格式的内容，通过md自动转换html格式。\r\n2. 修复部分已知bug',',记录,','2018-09-06 15:41:53',339,0,'2019-12-06 13:41:05',1,'/static/upload/smallpic/20180906/1536221534004638400.jpg'),(3,1,'Beego框架第1节——环境与初始','','',0,'从今起，还是从头再来，对于记录这件事，无论遇到什么挫折应当永不放弃。就从实战直接开始记录吧，更基础的东西只能在实战中逐步体现出来再记录好了。\r\n\r\n### 环境学习\r\n\r\n环境可以理解为当开发一个项目时，操作系统中辅助这个项目的一些工具或服务，目的是为了使开发项目更便捷更轻松。这里可以从几个方面简单了解一下：\r\n1. 开发所使用的IDE（集成开发环境）\r\n	- LiteIDE：官方推荐，轻量级，个人觉得还可以。\r\n	- Goland：个人非常喜欢，特别好用，功能完善。\r\n	- Eclipse：曾经的王者，如今跌落青铜，只能说很可惜。\r\n2. 操作系统环境变量\r\n	- GOROOT：Go在你电脑上的安装位置\r\n	- GOPATH：你的工作根目录，包含三个规定的目录：bin、pkg 和 src，分别用于存放可执行文件、包文件和源码文件。\r\n	**我的工作目录:`D:\\golang\\beego_gitee`，以下所有举例中都是以我个人电脑的环境为前提**\r\n![](/static/upload/bigpic/20180913/1536808863734917600_small.png)\r\n3. 一些会用到的第三方服务或工具\r\n	- MySQL：常用数据库，必定会用到的\r\n	- 浏览器：建议使用Google或火狐，前端调试的必要工具\r\n	- Nginx：反向代理，不是一定要使用它，个人习惯使用它，重要的是因为发布以后可能会需要https服务以及负载均衡等因素的考虑。如果仅仅是学习，可以放在以后有需要的时候再深入了解。\r\n	- SVN：版本管理系统，也不是一定要使用它，可它很重要，它与git一样，作为一切开发者最重要的两种代码管理的工具，必须要了解它。\r\n\r\n### 初始化beego项目\r\n\r\nbeego框架与许多web框架一样，可以通过简单的命令创建一个初始的项目结构，如果了解Python的django框架的朋友，我会告诉你，beego跟它真的好像，就感觉是一个系统出来的一样，本身Go与Python就感觉特别像，当我第一次接触到beego的时候，发现连框架都模仿的这么像，至于谁模仿谁就不清楚了，比较大的可能性是beego的作者有意把django一些比较好的东西借鉴了一番吧，个人猜测。回正题，beego也是一个典型MVC Web框架，作者是咱国人，应当支持一下，因此中文文档很丰富。\r\n- 官方网站：`https://beego.me/`\r\n- 源码地址：`https://github.com/astaxie/beego`\r\n- 官方工具：`https://github.com/beego/bee`\r\n\r\n```shell\r\ngo get github.com/astaxie/beego\r\ngo get github.com/beego/bee\r\n```\r\n\r\nbeego源码与bee工具源码都下载好之后，目录如下图：\r\n![](/static/upload/bigpic/20180913/1536807548352310600_small.png)\r\n![](/static/upload/bigpic/20180913/1536807568634215600_small.png)\r\n\r\n*（PS：请忽略绿色的打钩图标，它是SVN的状态标志）*\r\n\r\ngo的安装这里就不作赘述了，打开cmd命令行，安装bee：\r\n```shell\r\ngo install github.com\\beego\\bee\r\n```\r\n\r\n接着可以在工作根目录下的bin目录看到已生成的bee.exe：\r\n![](/static/upload/bigpic/20180913/1536808356051591100_small.png)\r\n\r\n然后将`D:\\golang\\beego_gitee\\bin`目录添加到系统path环境变量中：\r\n![](/static/upload/bigpic/20180913/1536808580270638600_small.png)\r\n\r\n测试bee是否安装好，在cmd命令行中输入：`bee`\r\n![](/static/upload/bigpic/20180913/1536808595609500600_small.png)\r\n\r\n至此，项目环境已经处理完成了。\r\n\r\n现在开始初始化beego项目，首先需要进入src目录之后再创建项目，如图：\r\n![](/static/upload/bigpic/20180913/1536809036301021100_small.png)\r\n\r\n个人有个习惯这里可以了解一下，如上图所示，在运行中打开cmd时，我需要手动输入命令进入src目录，这样比较麻烦，windows有个小功能，将shift键按着不动，鼠标在src目录中点击右键，菜单栏里会出现一个`在此处打开命令窗口`的菜单，如图：\r\n![](/static/upload/bigpic/20180913/1536809286540864100_small.png)\r\n\r\n如此就可以直接进入该目录，输入命令创建项目了：\r\n![](/static/upload/bigpic/20180913/1536809400689808100_small.png)\r\n\r\n接下来打开Goland：\r\n![](/static/upload/bigpic/20180913/1536809449478677600_small.png)\r\n\r\n首先打开刚创建的项目：\r\n![](/static/upload/bigpic/20180913/1536809711673810100_small.png)\r\n\r\n看一下项目目录结构：\r\n![](/static/upload/bigpic/20180913/1536809739333172600_small.png)\r\n\r\n然后可以到设置中核对一下GOPATH和GOROOT是否正确（Goland工具可以帮你添加或删除环境变量，**另注意GOPATH中如果有多个工作目录时，默认编译输出是以第一个为主的**）。\r\n![](/static/upload/bigpic/20180913/1536809526838960600_small.png)\r\n\r\n接下来可以简单查看一下conf目录下的app.conf：\r\n![](/static/upload/bigpic/20180913/1536810090648253700_small.png)\r\n\r\n默认写入的配置解释一下：\r\n- appname：创建时自定义的项目名称beego1\r\n- httpport：默认监听端口8080\r\n- runmode：该项目默认dev模式（即开发模式）`发布模式为：pro`\r\n\r\n接着开始配置编译器：\r\n![](/static/upload/bigpic/20180913/1536810350761757300_small.png)\r\n![](/static/upload/bigpic/20180913/1536810367554394300_small.png)\r\n![](/static/upload/bigpic/20180913/1536810384127296300_small.png)\r\n![](/static/upload/bigpic/20180913/1536810412398889700_small.png)\r\n![](/static/upload/bigpic/20180913/1536810426182622100_small.png)\r\n\r\n另外个人建议将conf添加一个参数：httpaddr\r\n![](/static/upload/bigpic/20180913/1536810819685036700_small.png)\r\n\r\n这样重新运行之后，可以直接点击上图所示的地址链接进入浏览器调试了。本地地址可以使用`127.0.0.1`或`localhost`。\r\n\r\n至此，你就可以在浏览器中输入`http://127.0.0.1:8080/`看初始页面了：\r\n![](/static/upload/bigpic/20180913/1536810622782944700_small.png)\r\n\r\n一个新的项目初始化完成了，本节重点知识在：\r\n- 环境的搭建\r\n- goland工具的使用\r\n- 前期开发比较难弄懂的环境变量等问题\r\n\r\n\r\n',',Golang,Beego,','2018-09-13 09:52:48',173,0,'2018-09-13 12:15:38',0,'/static/upload/smallpic/20180913/1536811152840407500.png'),(4,1,'Golang学习笔记之interface','','',0,'学习Golang有一段时间了，逐渐理解了为什么说Golang的灵魂在于并发与接口，的确如此，它使Golang在现代化语言以及多核集群化时代的大环境下，成为了一道亮丽的风景，本章节将深度解析Golang的接口（interface）。\r\n\r\n### 什么是interface\r\ninterface是典型的为面向对象编程而服务的，它将具有行为类似的对象统一起来供开发者调用，可以简单的理解为，许多不同的对象，具有类似的行为时，对象负责具体实现该行为，而接口负责提前抽象出来，统一定义该行为，这就可以形成一种先抽象再实现的编程思想。\r\n\r\n### 由浅入深去理解interface\r\n\r\n例1：\r\n```go\r\npackage main\r\n\r\nimport (\r\n	\"fmt\"\r\n)\r\n\r\n//定义一个动物接口，接口包含speak方法\r\ntype Animal interface {\r\n	Speak() string\r\n}\r\n\r\n//再定义一个Cat结构体，并实现speak方法\r\ntype Cat struct{}\r\nfunc (c Cat) Speak() string {\r\n	return \"喵!\"\r\n}\r\n//再定义一个Dog结构体，并实现speak方法\r\ntype Dog struct{}\r\nfunc (d Dog) Speak() string {\r\n	return \"汪!\"\r\n}\r\n\r\nfunc Test(params interface{}) {\r\n	fmt.Println(params)\r\n}\r\n\r\nfunc main() {\r\n	animals := []Animal{Cat{}, Dog{}}\r\n	for _, animal := range animals {\r\n		fmt.Println(animal.Speak())\r\n	}\r\n	Test(\"string\")\r\n	Test(123)\r\n	Test(true)\r\n}\r\n```\r\n输出：\r\n```shell\r\n喵!\r\n汪!\r\nstring\r\n123\r\ntrue\r\n```\r\n\r\n例1中，可这样理解，首先有两个不同的动物类型cat和dog，他们有着不同的叫声，目的是要让它们分别发出自己的叫声，那么就可以利用先抽象再实现的方式来完成这个任务，叫声虽不同，但同属动物发出声音，首先定义一个动物发声的行为接口，分别由不同类型的动物实现该行为接口，最后在调用时先实例化该动物列表，再循环调用每种动物的发声方法，从而达成目的。另可以看出，当interface{}作为函数形参时，可以接受不同类型的参数。\r\n\r\n接着再来一个更容易理解且具有较大实践价值的例子吧。\r\n\r\n例2：\r\n```go\r\npackage main\r\n\r\nimport \"fmt\"\r\n\r\n// 薪资计算器接口\r\ntype SalaryCalculator interface {\r\n	CalculateSalary() int\r\n}\r\n// 普通挖掘机员工\r\ntype Contract struct {\r\n	empId  int\r\n	basicpay int\r\n}\r\n// 有蓝翔技校证的员工\r\ntype Permanent struct {\r\n	empId  int\r\n	basicpay int\r\n	jj int // 奖金\r\n}\r\n\r\nfunc (p Permanent) CalculateSalary() int {\r\n	return p.basicpay + p.jj\r\n}\r\n\r\nfunc (c Contract) CalculateSalary() int {\r\n	return c.basicpay\r\n}\r\n// 总开支\r\nfunc totalExpense(s []SalaryCalculator) {\r\n	expense := 0\r\n	for _, v := range s {\r\n		expense = expense + v.CalculateSalary()\r\n	}\r\n	fmt.Printf(\"总开支 $%d\", expense)\r\n}\r\n\r\nfunc main() {\r\n	pemp1 := Permanent{1,3000,10000}\r\n	pemp2 := Permanent{2, 3000, 20000}\r\n	cemp1 := Contract{3, 3000}\r\n	employees := []SalaryCalculator{pemp1, pemp2, cemp1}\r\n	totalExpense(employees)\r\n}\r\n```\r\n输出：\r\n```shell\r\n总开支 $39000\r\n```\r\n\r\n例2虽然复杂了许多，但是interface的美感逐渐展现开来，题目是一家公司有很多员工，员工的级别不同薪资不同，需要每月核算薪资总开支，该如何实现。\r\n\r\n### 空接口\r\n\r\n例1：\r\n```go\r\npackage main\r\n\r\nimport (\r\n	\"fmt\"\r\n)\r\n\r\ntype Test1 interface {\r\n	Tester()\r\n}\r\n\r\ntype MyFloat float64\r\n\r\nfunc (m MyFloat) Tester() {\r\n	fmt.Println(m)\r\n}\r\n\r\nfunc describe(t Test1) {\r\n	fmt.Printf(\"Interface类型:%T,值:%v\\n\", t, t)\r\n}\r\n\r\nfunc main() {\r\n	var t Test1\r\n	f := MyFloat(88.8)\r\n	t = f\r\n	describe(t)\r\n	t.Tester()\r\n}\r\n```\r\n输出：\r\n```shell\r\nInterface类型:main.MyFloat,值:88.8\r\n88.8\r\n```\r\n\r\n例2：\r\n```go\r\npackage main\r\n\r\nimport (\r\n	\"fmt\"\r\n)\r\n\r\nfunc describe1(i interface{}) {\r\n	fmt.Printf(\"Type:%T,value:%v\\n\", i, i)\r\n}\r\n\r\nfunc main() {\r\n	// 任何类型的变量传入都可以\r\n	x := \"Hello World\"\r\n	y := 88\r\n	z := struct {name string}{\r\n		name: \"WuYun\",\r\n	}\r\n	describe1(x)\r\n	describe1(y)\r\n	describe1(z)\r\n}\r\n```\r\n输出：\r\n```shell\r\nType:string,value:Hello World\r\nType:int,value:88\r\nType:struct { name string },value:{WuYun}\r\n```\r\n\r\n### 类型断言\r\n例1：\r\n```go\r\npackage main\r\n\r\nimport(\r\n	\"fmt\"\r\n)\r\n\r\nfunc assert(i interface{}){\r\n	v, ok:= i.(int)\r\n	fmt.Println(v, ok)\r\n}\r\n\r\nfunc main(){\r\n	var s interface{} = 55\r\n	assert(s)\r\n	var i interface{} = \"Steven Paul\"\r\n	assert(i)\r\n}\r\n```\r\n输出：\r\n```shell\r\n55 true\r\n0 false\r\n```\r\n\r\n### 类型判断\r\n\r\n例1：\r\n```go\r\npackage main\r\n\r\nimport (\r\n	\"fmt\"\r\n)\r\n\r\nfunc findType(i interface{}) {\r\n	switch i.(type) {\r\n	case string:\r\n		fmt.Printf(\"String: %s\\n\", i.(string))\r\n	case int:\r\n		fmt.Printf(\"Int: %d\\n\", i.(int))\r\n	default:\r\n		fmt.Printf(\"Unknown type\\n\")\r\n	}\r\n}\r\nfunc main() {\r\n	findType(\"Naveen\")\r\n	findType(77)\r\n	findType(89.98)\r\n}\r\n```\r\n输出：\r\n```shell\r\nString: Naveen\r\nInt: 77\r\nUnknown type\r\n```\r\n\r\n例2：\r\n```go\r\npackage main\r\n\r\nimport \"fmt\"\r\n\r\ntype Describer interface {\r\n	Describe()\r\n}\r\ntype Person struct {\r\n	name string\r\n	age  int\r\n}\r\n\r\nfunc (p Person) Describe() {\r\n	fmt.Printf(\"%s is %d years old\", p.name, p.age)\r\n}\r\n\r\nfunc findType1(i interface{}) {\r\n	switch v := i.(type) {\r\n	case Describer:\r\n		v.Describe()\r\n	default:\r\n		fmt.Printf(\"unknown type\\n\")\r\n	}\r\n}\r\n\r\nfunc main() {\r\n	findType1(\"Naveen\")\r\n	p := Person{\r\n		name: \"Naveen R\",\r\n		age:  25,\r\n	}\r\n	findType1(p)\r\n}\r\n```\r\n输出：\r\n```shell\r\nunknown type\r\nNaveen R is 25 years old\r\n```\r\n\r\n',',Golang,interface,','2018-09-14 12:44:17',123,0,'2018-10-18 16:48:01',0,'/static/upload/default/blog-default-4.png'),(5,1,'Golang学习笔记之匿名函数与闭包','','',0,'说起来，一直不太理解匿名函数与闭包的运用，何时该用何时不该用，没有一个直观的感受，本节来解析一下。\r\n\r\n### 匿名函数与闭包的区别\r\n总有人说匿名函数就是闭包，个人认为应该不对，不应该混为一谈，单从字面意思上来看都大相径庭，只能说两者大多数情况下会同时出现，这会让很多新手云里雾里，甚至直接认为匿名函数就是闭包。\r\n+ 匿名函数\r\n	- 基本概念：简单的来说就是没有名字的函数，可视作一个没有名字的对象，供作用域之间使用。\r\n	- 第1种示例：`v1 := func(i int) int { return i * i }`\r\n	- 第2种示例：`func(i int) int { return i * i }(10)`\r\n+ 闭包\r\n	- 基本概念：可以理解为函数的嵌套，内层的函数可以使用外层函数的所有变量，即使外层函数已经执行完毕。\r\n\r\n### 深入理解\r\n- 闭包是可以包含自由（未绑定到特定对象）变量的代码块，这些变量不在这个代码块内或者任何全局上下文中定义，而是在定义代码块的环境中定义。要执行的代码块（由于自由变量包含在代码块中，所以这些自由变量以及它们引用的对象没有被释放）为自由变量提供绑定的计算环境（作用域）。\r\n- 个人理解：内层函数的状态被保存在闭包中，不使用闭包，就需要另起多个全局变量来保存函数以外的数据。如果说某函数被多方调用，且各方都需要各自存储各自的数据，则必须另起多个全局变量，具体使用哪一个，还要在函数内逐一判断，增加了重复代码量，因此合理运用闭包则有效解决了此问题。\r\n- 下面是运用闭包的一个简单示例：\r\n\r\n```go\r\npackage main\r\n\r\nimport (\r\n	\"fmt\"\r\n)\r\n\r\nfunc closure(x int) (func(), func(int)) {\r\n	fmt.Printf(\"初始值x为：%d，内存地址：%p\\n\", x, &x)\r\n	f1 := func() {\r\n		x = x + 5\r\n		fmt.Printf(\"x+5：%d，内存地址：%p\\n\", x, &x)\r\n	}\r\n	f2 := func(y int) {\r\n		x = x + y\r\n		fmt.Printf(\"x+%d：%d，内存地址：%p\\n\", y, x, &x)\r\n	}\r\n	return f1, f2\r\n}\r\n\r\nfunc main() {\r\n	func1, func2 := closure(10)\r\n	func1()\r\n	func2(10)\r\n	func2(20)\r\n}\r\n```\r\n输出：\r\n```shell\r\n初始值x为：10，内存地址：0xc042054080\r\nx+5：15，内存地址：0xc042054080\r\nx+10：25，内存地址：0xc042054080\r\nx+20：45，内存地址：0xc042054080\r\n```\r\n该例显而易见，即使外层的closure函数已经执行完毕，它所包含的自由变量并没有被释放，仍可以使用已经结束了的外层函数中的变量与匿名函数，且变量的地址没有变化。\r\n\r\n### 运用闭包的价值\r\n闭包的价值在于可以作为函数对象或者匿名函数，对于类型系统而言，这意味着不仅要表示数据还要表示代码。支持闭包的多数语言都将函数作为第一级对象，就是说这些函数可以存储到变量中作为参数传递给其他函数，最重要的是能够被函数动态创建和返回。\r\n\r\n`注：由于闭包会携带包含它的函数的作用域，因此会比其他函数占用更多的内存。过度使用闭包可能会导致内存占用过多。`\r\n\r\n',',Golang,','2018-09-18 17:31:56',122,0,'2018-09-19 15:52:21',0,'/static/upload/default/blog-default-5.png'),(6,1,'Golang学习笔记之初识并发特性（上）','','',0,'初始Go语言的并发特性，学习本节会对Go语言的并发形成一个清晰的概念，Go作为并发式语言，原生支持并发，具体来说它是通过Go协程（Goroutine）和信道（Channel）来处理并发的。\r\n\r\n### 并发是什么\r\n并发是指立即处理多个任务的能力。\r\n- 举个简单的例子说明：\r\n我们可以想象一个人正在跑步。假如在他晨跑时，鞋带突然松了。于是他停下来，系一下鞋带，接下来继续跑。这个例子就是典型的并发。这个人能够一下搞定跑步和系鞋带两件事，即立即处理多个任务。\r\n\r\n### 并发与并行的区别\r\n上例中可以看到一个人立即处理了多个任务，但并非同时完成的，这与并行是完全不同的，并行是指同时处理多个任务。\r\n- 同样举个跑步的例子说明：\r\n假如这个人在慢跑时，还在用他的iPod听着音乐。在这里，他是在跑步的同时听音乐，也就是同时处理多个任务。这称之为并行。\r\n\r\n### 再来从技术角度来看并发与并行\r\n假如我们正在编写一个web浏览器。这个web浏览器有各种组件。其中两个分别是web页面的渲染区和从网上下载文件的下载器。假设我们已经构建好了浏览器代码，各个组件也都可以相互独立地运行（通过像Java里的线程，或者通过即将介绍的Go语言中的Go协程来实现）。当浏览器在单核处理器中运行时，处理器会在浏览器的两个组件间进行上下文切换。它可能在一段时间内下载文件，转而又对用户请求的web页面进行渲染。这就是并发。并发的进程从不同的时间点开始，分别交替运行。在这里，就是在不同的时间点开始进行下载和渲染，并相互交替运行的。\r\n\r\n如果该浏览器在一个多核处理器上运行，此时下载文件的组件和渲染HTML的组件可能会在不同的核上同时运行。这称之为并行。\r\n- 如图所示：\r\n![](/static/upload/bigpic/20180920/1537414811862486100_small.png)\r\n\r\n并行不一定会加快运行速度，因为并行运行的组件之间可能需要相互通信。在我们浏览器的例子里，当文件下载完成后，应当对用户进行提醒，比如弹出一个窗口。于是，在负责下载的组件和负责渲染用户界面的组件之间，就产生了通信。在并发系统上，这种通信开销很小。但在多核的并行系统上，组件间的通信开销就很高了。所以，并行不一定会加快运行速度！\r\n\r\n### Go协程（Goroutine）是什么\r\nGo 协程是与其他函数或方法一起并发运行的函数或方法。Go 协程可以看作是轻量级线程。与线程相比，创建一个 Go 协程的成本很小。因此在 Go 应用中，常常会看到有数以千计的 Go 协程并发地运行。\r\n\r\n### Go协程相比于线程的优势\r\n- 相比线程而言，Go协程的成本极低。堆栈大小只有若干kb，并且可以根据应用的需求进行增减。而线程必须指定堆栈的大小，其堆栈是固定不变的。\r\n- Go协程会复用（Multiplex）数量更少的OS线程。即使程序有数以千计的Go协程，也可能只有一个线程。如果该线程中的某一Go协程发生了阻塞（比如说等待用户输入），那么系统会再创建一个OS线程，并把其余Go协程都移动到这个新的OS线程。所有这一切都在运行时进行，作为程序员，我们没有直接面临这些复杂的细节，而是有一个简洁的API来处理并发。\r\n- Go协程使用信道（Channel）来进行通信。信道用于防止多个协程访问共享内存时发生竞态条件（Race Condition）。信道可以看作是 Go协程之间通信的管道。信道（Channel）会在下一章节详细说明。\r\n\r\n### 如何启动一个Go协程\r\n调用函数或者方法时，在前面加上关键字go，可以让一个新的Go协程并发地运行。\r\n创建一个Go协程：\r\n```go\r\npackage main\r\n\r\nimport (\r\n    \"fmt\"\r\n)\r\n\r\nfunc hello() {\r\n    fmt.Println(\"Hello world goroutine\")\r\n}\r\nfunc main() {\r\n    go hello()\r\n    fmt.Println(\"main function\")\r\n}\r\n```\r\n在第11行，`go hello()`启动了一个新的Go协程。现在`hello()`函数与`main()`函数会并发地执行。主函数会运行在一个特有的Go协程上，它称为Go主协程（Main Goroutine）。\r\n运行该程序会惊讶发现并没有输出期望的打印内容，只输出了`main function`，这是什么原因呢？想要理解为什么，首先需要理解两个Go协程的主要性质。\r\n- 启动一个新的协程时，协程的调用会立即返回。与函数不同，程序控制不会去等待Go协程执行完毕。在调用Go协程之后，程序控制会立即返回到代码的下一行，忽略该协程的任何返回值。\r\n- 如果希望运行其他Go协程，Go主协程必须继续运行着。如果Go主协程终止，则程序终止，于是其他Go协程也不会继续运行。\r\n\r\n因此，我们刚才运行的Go协程没有运行。在第11行调用了`go hello()`之后，程序控制没有等待`hello`协程结束，立即返回到了代码下一行，打印`main function`。接着由于没有其他可执行的代码，Go主协程终止，于是`hello`协程就没有机会运行了。\r\n我们现在修复这个问题。\r\n```go\r\npackage main\r\n\r\nimport (\r\n    \"fmt\"\r\n    \"time\"\r\n)\r\n\r\nfunc hello() {\r\n    fmt.Println(\"Hello world goroutine\")\r\n}\r\nfunc main() {\r\n    go hello()\r\n    time.Sleep(1 * time.Second)\r\n    fmt.Println(\"main function\")\r\n}\r\n```\r\n我们让Go主协程休眠1秒，再终止之前，调用`go hello()`就有足够的时间来执行了，该程序首先打印`Hello world goroutine`，等待1秒钟之后，接着打印`main function`。这里我们是使用了休眠来等待协程执行完毕。\r\n\r\n### 启动多个 Go 协程\r\n为了更好地理解 Go 协程，我们再编写一个程序，启动多个 Go 协程。\r\n```go\r\npackage main\r\n\r\nimport (\r\n    \"fmt\"\r\n    \"time\"\r\n)\r\n\r\nfunc numbers() {\r\n    for i := 1; i <= 5; i++ {\r\n        time.Sleep(250 * time.Millisecond)\r\n        fmt.Printf(\"%d \", i)\r\n    }\r\n}\r\nfunc alphabets() {\r\n    for i := \'a\'; i <= \'e\'; i++ {\r\n        time.Sleep(400 * time.Millisecond)\r\n        fmt.Printf(\"%c \", i)\r\n    }\r\n}\r\nfunc main() {\r\n    go numbers()\r\n    go alphabets()\r\n    time.Sleep(3000 * time.Millisecond)\r\n    fmt.Println(\"main terminated\")\r\n}\r\n```\r\n在上面程序中的第21行和第22行，启动了两个Go协程。现在，这两个协程并发地运行。numbers协程首先休眠250微秒，接着打印1，然后再次休眠，打印2，依此类推，一直到打印5结束。alphabete协程同样打印从a到e的字母，并且每次有400微秒的休眠时间。Go主协程启动了numbers和alphabete两个Go协程，休眠了3000微秒后终止程序。\r\n\r\n该程序会输出：\r\n```shell\r\n1 a 2 3 b 4 c 5 d e main terminated\r\n```\r\n程序的运作如下图所示：\r\n![](/static/upload/bigpic/20180920/1537416706424492300_small.png)\r\n\r\n第一张蓝色的图表示numbers协程，第二张褐红色的图表示alphabets协程，第三张绿色的图表示Go主协程，而最后一张黑色的图把以上三种协程合并了，表明程序是如何运行的。在每个方框顶部，诸如0ms和250ms这样的字符串表示时间（以微秒为单位）。在每个方框的底部，1、2、3等表示输出。蓝色方框表示：250ms打印出1，500 ms打印出2，依此类推。最后黑色方框的底部的值会是 1 a 2 3 b 4 c 5 d e main terminated，这同样也是整个程序的输出。\r\n\r\n利用休眠这种方法只是用于理解Go协程如何工作的技巧，而实际运用中，这种方法并不可取，因此，Go的另一个灵魂特性Channel闪亮登场了。\r\n\r\n待续。。。\r\n\r\n\r\n\r\n\r\n\r\n\r\n',',Golang,Goroutine,Channel,','2018-09-20 11:05:29',72,0,'2018-09-20 12:19:02',0,'/static/upload/smallpic/20180920/1537412984670254300.png'),(7,1,'Golang学习笔记之初识并发特性（下）','','',0,'接着上一章节的学习，来到了Go语言的灵魂特性Channel，我们认真学习了Go协程之后，最重点的应该是需要利用Channel来完成Go协程之间的通信了。如上一章节讲到的当需要在其他协程结束执行之前，阻塞Go主协程，我们利用`sleep`方法是不可取的，而Channel可以更优雅的完成该工作，本章节会逐步剖析Channel。\r\n\r\n### 信道（Channel）是什么\r\n信道可以想像成 Go 协程之间通信的管道。如同管道中的水会从一端流到另一端，通过使用信道，数据也可以从一端发送，在另一端接收。\r\n\r\n### 信道的声明\r\n- 所有信道都关联了一个类型。信道只能运输这种类型的数据，而运输其他类型的数据都是非法的。\r\n- `chan T`表示T类型的信道。\r\n- 信道的零值为nil。信道的零值没有什么用，应该像对map和切片所做的那样，用`make`来定义信道。\r\n\r\n下面编写代码，声明一个信道：\r\n```go\r\npackage main\r\n\r\nimport \"fmt\"\r\n\r\nfunc main() {\r\n    var a chan int\r\n    if a == nil {\r\n        fmt.Println(\"channel a is nil, going to define it\")\r\n        a = make(chan int)\r\n        fmt.Printf(\"Type of a is %T\", a)\r\n    }\r\n}\r\n```\r\n输出：\r\n```shell\r\nchannel a is nil, going to define it\r\nType of a is chan int\r\n```\r\n由于信道的零值为nil，在第6行，信道a的值就是nil。于是，程序执行了if语句内的语句，定义了信道a。程序中a是一个int类型的信道。\r\n简短声明通常也是一种定义信道的简洁有效的方法。\r\n```go\r\na := make(chan int)\r\n```\r\n这一行代码同样定义了一个int类型的信道a。\r\n\r\n### 通过信道进行发送和接收\r\n如下所示，该语法通过信道发送和接收数据。\r\n```go\r\ndata := <- a // 读取信道a\r\na <- data // 写入信道a\r\n```\r\n\r\n信道旁的箭头方向指定了是发送数据还是接收数据。\r\n\r\n在第一行，箭头对于a来说是向外指的，因此我们读取了信道a的值，并把该值存储到变量data。\r\n\r\n在第二行，箭头指向了a，因此我们在把数据写入信道a。\r\n\r\n### 发送与接收默认是阻塞的\r\n发送与接收默认是阻塞的。这是什么意思？当把数据发送到信道时，程序控制会在发送数据的语句处发生阻塞，直到有其它Go协程从信道读取到数据，才会解除阻塞。与此类似，当读取信道的数据时，如果没有其它的协程把数据写入到这个信道，那么读取过程就会一直阻塞着。\r\n\r\n信道的这种特性能够帮助Go协程之间进行高效的通信，不需要用到其他编程语言常见的显式锁或条件变量。\r\n\r\n### 信道的代码示例\r\n回顾上章学习Go协程时写的程序\r\n```go\r\npackage main\r\n\r\nimport (\r\n    \"fmt\"\r\n    \"time\"\r\n)\r\n\r\nfunc hello() {\r\n    fmt.Println(\"Hello world goroutine\")\r\n}\r\nfunc main() {\r\n    go hello()\r\n    time.Sleep(1 * time.Second)\r\n    fmt.Println(\"main function\")\r\n}\r\n```\r\n我们接下来使用信道来重写上面代码。\r\n```go\r\npackage main\r\n\r\nimport (\r\n    \"fmt\"\r\n)\r\n\r\nfunc hello(done chan bool) {\r\n    fmt.Println(\"Hello world goroutine\")\r\n    done <- true\r\n}\r\nfunc main() {\r\n    done := make(chan bool)\r\n    go hello(done)\r\n    <-done\r\n    fmt.Println(\"main function\")\r\n}\r\n```\r\n\r\n在上述程序里，我们在第12行创建了一个bool类型的信道`done`，并把`done`作为参数传递给了`hello`协程。在第14行，我们通过信道`done`接收数据。这一行代码发生了阻塞，除非有协程向`done`写入数据，否则程序不会跳到下一行代码。于是，这就不需要用以前的`time.Sleep`来阻止Go主协程退出了。\r\n\r\n`<-done`这行代码通过协程接收信道`done`数据，但并没有使用数据或者把数据存储到变量中。这完全是合法的。\r\n\r\n现在我们的Go主协程发生了阻塞，等待信道`done`发送的数据。该信道作为参数传递给了协程`hello`，`hello`打印出`Hello world goroutine`，接下来向`done`写入数据。当完成写入时，Go主协程会通过信道`done`接收数据，于是它解除阻塞状态，打印出文本 `main function`。\r\n\r\n该程序输出：\r\n\r\n```shell\r\nHello world goroutine\r\nmain function\r\n```\r\n\r\n当然了，我们常在测试时，为了更容易理解程序运行过程，会经常用到sleep方法，我们稍微修改一下程序，以便更好地理解阻塞的概念。\r\n\r\n```go\r\npackage main\r\n\r\nimport (\r\n    \"fmt\"\r\n    \"time\"\r\n)\r\n\r\nfunc hello(done chan bool) {\r\n    fmt.Println(\"hello go routine is going to sleep\")\r\n    time.Sleep(4 * time.Second)\r\n    fmt.Println(\"hello go routine awake and going to write to done\")\r\n    done <- true\r\n}\r\nfunc main() {\r\n    done := make(chan bool)\r\n    fmt.Println(\"Main going to call hello go goroutine\")\r\n    go hello(done)\r\n    <-done\r\n    fmt.Println(\"Main received data\")\r\n}\r\n```\r\n\r\n在上面程序里，我们向`hello`函数里添加了4秒的休眠（第10行）。\r\n\r\n程序首先会打印`Main going to call hello go goroutine`。接着会开启`hello`协程，打印`hello go routine is going to sleep`。打印完之后，`hello`协程会休眠4秒钟，而在这期间，主协程会在`<-done`这一行发生阻塞，等待来自信道`done`的数据。4秒钟之后，打印`hello go routine awake and going to write to done`，接着再打印`Main received data`。\r\n\r\n输出：\r\n```shell\r\nMain going to call hello go goroutine\r\nhello go routine is going to sleep\r\nhello go routine awake and going to write to done\r\nMain received data\r\n```\r\n\r\n### 信道的另一个示例\r\n\r\n我们再编写一个程序来更好地理解信道。该程序会计算一个数中每一位的平方和与立方和，然后把平方和与立方和相加并打印出来。\r\n\r\n例如，如果输出是123，该程序会如下计算输出：\r\n\r\n```shell\r\nsquares = (1 * 1) + (2 * 2) + (3 * 3)\r\ncubes = (1 * 1 * 1) + (2 * 2 * 2) + (3 * 3 * 3)\r\noutput = squares + cubes = 50\r\n```\r\n\r\n我们会这样去构建程序：在一个单独的Go协程计算平方和，而在另一个协程计算立方和，最后在Go主协程把平方和与立方和相加。\r\n\r\n```go\r\npackage main\r\n\r\nimport (\r\n    \"fmt\"\r\n)\r\n\r\nfunc calcSquares(number int, squareop chan int) {\r\n    sum := 0\r\n    for number != 0 {\r\n        digit := number % 10\r\n        sum += digit * digit\r\n        number /= 10\r\n    }\r\n    squareop <- sum\r\n}\r\n\r\nfunc calcCubes(number int, cubeop chan int) {\r\n    sum := 0 \r\n    for number != 0 {\r\n        digit := number % 10\r\n        sum += digit * digit * digit\r\n        number /= 10\r\n    }\r\n    cubeop <- sum\r\n}\r\n\r\nfunc main() {\r\n    number := 589\r\n    sqrch := make(chan int)\r\n    cubech := make(chan int)\r\n    go calcSquares(number, sqrch)\r\n    go calcCubes(number, cubech)\r\n    squares, cubes := <-sqrch, <-cubech\r\n    fmt.Println(\"Final output\", squares + cubes)\r\n}\r\n```\r\n\r\n在第7行，函数`calcSquares`计算一个数每位的平方和，并把结果发送给信道`squareop`。与此类似，在第17行函数`calcCubes`计算一个数每位的立方和，并把结果发送给信道`cubop`。\r\n\r\n这两个函数分别在单独的协程里运行（第31行和第32行），每个函数都有传递信道的参数，以便写入数据。Go主协程会在第33行等待两个信道传来的数据。一旦从两个信道接收完数据，数据就会存储在变量`squares`和`cubes`里，然后计算并打印出最后结果。该程序会输出：\r\n\r\n```shell\r\nFinal output 1536\r\n```\r\n\r\n### 死锁\r\n\r\n使用信道需要考虑的一个重点是死锁。当Go协程给一个信道发送数据时，照理说会有其他Go协程来接收数据。如果没有的话，程序就会在运行时触发panic，形成死锁。\r\n\r\n同理，当有Go协程等着从一个信道接收数据时，我们期望其他的Go协程会向该信道写入数据，要不然程序就会触发panic。\r\n\r\n```go\r\npackage main\r\n\r\nfunc main() {\r\n    ch := make(chan int)\r\n    ch <- 5\r\n}\r\n```\r\n\r\n在上述程序中，我们创建了一个信道`ch`，接着在下一行`ch <- 5`，我们把`5`发送到这个信道。对于本程序，没有其他的协程从`ch`接收数据。于是程序触发panic，出现如下运行时错误。\r\n\r\n```shell\r\nfatal error: all goroutines are asleep - deadlock!\r\n\r\ngoroutine 1 [chan send]:\r\nmain.main()\r\n	D:/golang/1/test2.go:5 +0x57\r\n```\r\n\r\n### 单向信道\r\n\r\n我们目前讨论的信道都是双向信道，即通过信道既能发送数据，又能接收数据。其实也可以创建单向信道，这种信道只能发送或者接收数据。\r\n\r\n```go\r\npackage main\r\n\r\nimport \"fmt\"\r\n\r\nfunc sendData(sendch chan<- int) {\r\n    sendch <- 10\r\n}\r\n\r\nfunc main() {\r\n    sendch := make(chan<- int)\r\n    go sendData(sendch)\r\n    fmt.Println(<-sendch)\r\n}\r\n```\r\n\r\n上面程序的第10行，我们创建了唯送（Send Only）信道`sendch`。`chan<- int`定义了唯送信道，因为箭头指向了`chan`。在第12行，我们试图通过唯送信道接收数据，于是编译器报错：\r\n\r\n```shell\r\ninvalid operation: <-sendch (receive from send-only type chan<- int)\r\n```\r\n\r\n一切都很顺利，只不过一个不能读取数据的唯送信道究竟有什么意义呢？\r\n\r\n这就需要用到信道转换（Channel Conversion）了。把一个双向信道转换成唯送信道或者唯收（Receive Only）信道都是行得通的，但是反过来就不行。\r\n\r\n```go\r\npackage main\r\n\r\nimport \"fmt\"\r\n\r\nfunc sendData(sendch chan<- int) {\r\n    sendch <- 10\r\n}\r\n\r\nfunc main() {\r\n    cha1 := make(chan int)\r\n    go sendData(cha1)\r\n    fmt.Println(<-cha1)\r\n}\r\n```\r\n\r\n在上述程序的第10行，我们创建了一个双向信道`cha1`。在第11行`cha1`作为参数传递给了`sendData`协程。在第5行，函数`sendData`里的参数`sendch chan<- int`把`cha1`转换为一个唯送信道。于是该信道在`sendData`协程里是一个唯送信道，而在Go主协程里是一个双向信道。该程序最终打印输出`10`。\r\n\r\n### 关闭信道和使用 for range 遍历信道\r\n\r\n数据发送方可以关闭信道，通知接收方这个信道不再有数据发送过来。\r\n\r\n当从信道接收数据时，接收方可以多用一个变量来检查信道是否已经关闭。\r\n\r\n```go\r\nv, ok := <- ch\r\n```\r\n\r\n上面的语句里，如果成功接收信道所发送的数据，那么`ok`等于 true。而如果`ok`等于false，说明我们试图读取一个关闭的通道。从关闭的信道读取到的值会是该信道类型的零值。例如，当信道是一个`int`类型的信道时，那么从关闭的信道读取的值将会是`0`。\r\n\r\n```go\r\npackage main\r\n\r\nimport (\r\n    \"fmt\"\r\n)\r\n\r\nfunc producer(chnl chan int) {\r\n    for i := 0; i < 10; i++ {\r\n        chnl <- i\r\n    }\r\n    close(chnl)\r\n}\r\nfunc main() {\r\n    ch := make(chan int)\r\n    go producer(ch)\r\n    for {\r\n        v, ok := <-ch\r\n        if ok == false {\r\n            break\r\n        }\r\n        fmt.Println(\"Received \", v, ok)\r\n    }\r\n}\r\n```\r\n\r\n在上述的程序中，`producer`协程会从0到9写入信道`chn1`，然后关闭该信道。主函数有一个无限的for循环（第16行），使用变量`ok`（第18行）检查信道是否已经关闭。如果`ok`等于false，说明信道已经关闭，于是退出for循环。如果`ok`等于true，会打印出接收到的值和`ok`的值。\r\n\r\n```shell\r\nReceived  0 true\r\nReceived  1 true\r\nReceived  2 true\r\nReceived  3 true\r\nReceived  4 true\r\nReceived  5 true\r\nReceived  6 true\r\nReceived  7 true\r\nReceived  8 true\r\nReceived  9 true\r\n```\r\n\r\nfor range 循环用于在一个信道关闭之前，从信道接收数据。\r\n\r\n接下来我们使用 for range 循环重写上面的代码。\r\n\r\n```go\r\npackage main\r\n\r\nimport (\r\n    \"fmt\"\r\n)\r\n\r\nfunc producer(chnl chan int) {\r\n    for i := 0; i < 10; i++ {\r\n        chnl <- i\r\n    }\r\n    close(chnl)\r\n}\r\nfunc main() {\r\n    ch := make(chan int)\r\n    go producer(ch)\r\n    for v := range ch {\r\n        fmt.Println(\"Received \",v)\r\n    }\r\n}\r\n```\r\n\r\n在第16行，for range循环从信道`ch`接收数据，直到该信道关闭。一旦关闭了`ch`，循环会自动结束。该程序会输出：\r\n\r\n```shell\r\nReceived  0\r\nReceived  1\r\nReceived  2\r\nReceived  3\r\nReceived  4\r\nReceived  5\r\nReceived  6\r\nReceived  7\r\nReceived  8\r\nReceived  9\r\n```\r\n\r\n我们可以使用for range循环，重写信道的另一个示例这一节里面的代码，提高代码的可重用性。\r\n\r\n最后，我们再来回顾一下刚刚计算平方与立方和的例子，如果你仔细观察这段代码，会发现获得一个数里的每位数`digit`的计算在`calcSquares`和`calcCubes`两个函数内多次重复。我们将把这段代码抽离出来，放在一个单独的函数里，然后并发地调用它。\r\n\r\n```go\r\npackage main\r\n\r\nimport (\r\n    \"fmt\"\r\n)\r\n\r\nfunc digits(number int, dchnl chan int) {\r\n    for number != 0 {\r\n        digit := number % 10\r\n        dchnl <- digit\r\n        number /= 10\r\n    }\r\n    close(dchnl)\r\n}\r\nfunc calcSquares(number int, squareop chan int) {\r\n    sum := 0\r\n    dch := make(chan int)\r\n    go digits(number, dch)\r\n    for digit := range dch {\r\n        sum += digit * digit\r\n    }\r\n    squareop <- sum\r\n}\r\n\r\nfunc calcCubes(number int, cubeop chan int) {\r\n    sum := 0\r\n    dch := make(chan int)\r\n    go digits(number, dch)\r\n    for digit := range dch {\r\n        sum += digit * digit * digit\r\n    }\r\n    cubeop <- sum\r\n}\r\n\r\nfunc main() {\r\n    number := 589\r\n    sqrch := make(chan int)\r\n    cubech := make(chan int)\r\n    go calcSquares(number, sqrch)\r\n    go calcCubes(number, cubech)\r\n    squares, cubes := <-sqrch, <-cubech\r\n    fmt.Println(\"Final output\", squares+cubes)\r\n}\r\n```\r\n\r\n上述程序里的`digits`函数，包含了获取一个数的每位数的逻辑，并且`calcSquares`和`calcCubes`两个函数并发地调用了`digits`。当计算完数字里面的每一位数时，第13行就会关闭信道。`calcSquares`和`calcCubes`两个协程使用for range循环分别监听了它们的信道，直到该信道关闭。程序的其他地方不变，该程序同样会输出：\r\n\r\n```shell\r\nFinal output 1536\r\n```\r\n\r\n',',Golang,Goroutine,Channel,','2018-09-20 14:51:49',86,0,'2018-09-21 10:21:07',0,'/static/upload/default/blog-default-6.png'),(8,1,'Golang学习笔记之五大阶段','','',0,'个人认为学习Go语言，分为五个阶段：\r\n### 基础知识\r\n与大多数编程语言相同，一开始都必须得啃光所对应的基础知识，包括如下几个面：\r\n\r\n1. 语言背景、环境安装、Hello world！\r\n2. 变量、类型、常量\r\n3. 包、条件语句、循环、switch\r\n4. 实参、形参、可变参数等函数\r\n5. 数组切片、map、字符串、指针\r\n\r\n### 第二阶段\r\n1. 方法、结构体\r\n2. interface\r\n3. channel、协程\r\n\r\n### 第三阶段\r\n1. 缓冲channel、工作池\r\n2. select、mutex\r\n3. defer、错误处理\r\n4. panic、recover、反射\r\n\r\n### 第四阶段\r\n1. 匿名函数、闭包\r\n2. 面向对象的实现（类、继承、多态）\r\n\r\n### 第五阶段\r\n1. 框架学习与实战\r\n2. 二次开发\r\n3. github、svn、git\r\n4. 项目部署\r\n\r\n之所以把整个学习进程描述出来，是希望自己能够更有条理的将后面的重点知识记录的更加清晰明确，更好的巩固所学。\r\n',',Golang,','2018-09-26 09:23:42',46,0,'2018-09-26 10:24:54',0,'/static/upload/default/blog-default-1.png'),(9,1,'Golang学习笔记之select','','',0,'### 什么是Select\r\n\r\n随着channel学习的深入，Go语言有专用于channel操作的`select`语法，与`switch`类似，非常实用，所不同的是`select`的每个`case`语句都是channel操作，具体是用于在多个发送/接收的信道操作中进行选择，`select`语句会一直阻塞，直到发送/接收操作准备就绪。如果有多个信道操作准备完毕，`select`会随机地选取其中之一执行。先来个实际例子看看吧：\r\n```go\r\npackage main\r\n\r\nimport (\r\n    \"fmt\"\r\n    \"time\"\r\n)\r\n\r\nfunc server1(ch chan string) {\r\n    time.Sleep(6 * time.Second)\r\n    ch <- \"from server1\"\r\n}\r\nfunc server2(ch chan string) {\r\n    time.Sleep(3 * time.Second)\r\n    ch <- \"from server2\"\r\n\r\n}\r\nfunc main() {\r\n    output1 := make(chan string)\r\n    output2 := make(chan string)\r\n    go server1(output1)\r\n    go server2(output2)\r\n    select {\r\n    case s1 := <-output1:\r\n        fmt.Println(s1)\r\n    case s2 := <-output2:\r\n        fmt.Println(s2)\r\n    }\r\n}\r\n```\r\n输出：\r\n```go\r\nfrom server2\r\n```\r\n\r\n`select`会一直发生阻塞，除非其中有`case`准备就绪。在上述程序里，`server1`协程会在6秒之后写入`output1`信道，而`server2`协程在3秒之后就写入了`output2`信道。因此`select`语句会阻塞3秒钟，`output2`信道率先准备好，select则会选择该信道并完成执行。\r\n\r\n### Select的应用\r\n\r\n在上面程序中，函数之所以取名为`server1`和`server2`，是为了展示`select`的实际应用。\r\n\r\n假设我们有一个关键性应用，需要尽快地把输出返回给用户。这个应用的数据库复制并且存储在世界各地的服务器上。假设函数`server1`和`server2`与这样不同区域的两台服务器进行通信。每台服务器的负载和网络时延决定了它的响应时间。我们向两台服务器发送请求，并使用`select`语句等待相应的信道发出响应。`select`会选择首先响应的服务器，而忽略其它的响应。使用这种方法，我们可以向多个服务器发送请求，并给用户返回最快的响应了。\r\n\r\n### Default\r\n\r\n在没有`case`准备就绪时，可以执行`select`语句中的默认情况（Default Case）。这通常用于防止`select`语句一直阻塞。\r\n\r\n```go\r\npackage main\r\n\r\nimport (\r\n    \"fmt\"\r\n    \"time\"\r\n)\r\n\r\nfunc process(ch chan string) {\r\n    time.Sleep(10500 * time.Millisecond)\r\n    ch <- \"process successful\"\r\n}\r\n\r\nfunc main() {\r\n    ch := make(chan string)\r\n    go process(ch)\r\n    for {\r\n        time.Sleep(1000 * time.Millisecond)\r\n        select {\r\n        case v := <-ch:\r\n            fmt.Println(\"received value: \", v)\r\n            return\r\n        default:\r\n            fmt.Println(\"no value received\")\r\n        }\r\n    }\r\n}\r\n```\r\n输出：\r\n```go\r\nno value received\r\nno value received\r\nno value received\r\nno value received\r\nno value received\r\nno value received\r\nno value received\r\nno value received\r\nno value received\r\nno value received\r\nreceived value:  process successful\r\n```\r\n\r\n主协程启动了一个无限循环。这个无限循环在每一次迭代开始时，都会先休眠1000毫秒（1秒），然后执行一个`select`操作。由于`process`协程在10500毫秒后才会向`ch`信道写入数据，因此`select`语句的第一个`case`（即`case v := <-ch:`）并未就绪。所以在这期间，程序会执行默认情况，该程序会打印10次`no value received`。\r\n\r\n在10.5秒之后，`process`协程会在第10行向`ch`写入`process successful`。主协程就会执行`select`语句的第一个`case`了。\r\n\r\n### 死锁\r\n```go\r\npackage main\r\n\r\nfunc main() {\r\n    ch := make(chan string)\r\n    select {\r\n    case <-ch:\r\n    }\r\n}\r\n```\r\n输出panic：\r\n```go\r\nfatal error: all goroutines are asleep - deadlock!\r\n\r\ngoroutine 1 [chan receive]:\r\nmain.main()\r\n	D:/golang/1/select.go:6 +0x59\r\n```\r\n\r\n上面的程序中，我们在第4行创建了一个信道`ch`。我们在`select`内部（第6行），试图读取信道`ch`。由于没有Go协程向该信道写入数据，因此 `select`语句会一直阻塞，导致死锁。\r\n\r\n如果存在默认情况，就不会发生死锁，因为在没有其他`case`准备就绪时，会执行默认情况。我们用默认情况重写后，程序如下：\r\n\r\n```go\r\npackage main\r\n\r\nimport \"fmt\"\r\n\r\nfunc main() {\r\n    ch := make(chan string)\r\n    select {\r\n    case <-ch:\r\n    default:\r\n        fmt.Println(\"default case executed\")\r\n    }\r\n}\r\n```\r\n输出：\r\n```go\r\ndefault case executed\r\n```\r\n\r\n如果`select`只含有值为`nil`的信道，也同样会执行默认情况。\r\n\r\n```go\r\npackage main\r\n\r\nimport \"fmt\"\r\n\r\nfunc main() {\r\n    var ch chan string\r\n    select {\r\n    case v := <-ch:\r\n        fmt.Println(\"received value\", v)\r\n    default:\r\n        fmt.Println(\"default case executed\")\r\n\r\n    }\r\n}\r\n```\r\n输出：\r\n```go\r\ndefault case executed\r\n```\r\n\r\n### 随机选取\r\n\r\n当`select`由多个`case`准备就绪时，将会随机地选取其中之一去执行。\r\n\r\n```go\r\npackage main\r\n\r\nimport (\r\n    \"fmt\"\r\n    \"time\"\r\n)\r\n\r\nfunc server1(ch chan string) {\r\n    ch <- \"from server1\"\r\n}\r\nfunc server2(ch chan string) {\r\n    ch <- \"from server2\"\r\n\r\n}\r\nfunc main() {\r\n    output1 := make(chan string)\r\n    output2 := make(chan string)\r\n    go server1(output1)\r\n    go server2(output2)\r\n    time.Sleep(1 * time.Second)\r\n    select {\r\n    case s1 := <-output1:\r\n        fmt.Println(s1)\r\n    case s2 := <-output2:\r\n        fmt.Println(s2)\r\n    }\r\n}\r\n```\r\n输出可能会是`from server1`，也可能会是`from server2`。\r\n\r\n### 空Select\r\n```go\r\npackage main\r\n\r\nfunc main() {\r\n    select {}\r\n}\r\n```\r\n输出：\r\n```go\r\nfatal error: all goroutines are asleep - deadlock!\r\n\r\ngoroutine 1 [select (no cases)]:\r\nmain.main()\r\n	D:/golang/1/select.go:4 +0x27\r\n```\r\n我们已经知道，除非有`case`执行，`select`语句就会一直阻塞着。在这里，`select`语句没有任何`case`，因此它会一直阻塞并且没有任何协程的情况下，会导致死锁。该程序会触发`panic`。\r\n**这里特别说明**，为什么有空select的存在，是因为有很多情况下需要将main函数进入永久阻塞状态，有很多办法，最常用和简便的方法就是使用`select{}`，只要在空select之前存在协程可以运行，是不会导致死锁，并且会一直阻塞。\r\n下面举个简单常用的例子：\r\n```go\r\npackage main\r\n\r\nimport (\r\n	\"time\"\r\n	\"fmt\"\r\n)\r\n\r\nfunc main(){\r\n	for i := 0; i < 20; i++ { //启动20个协程处理消息队列中的消息\r\n		go thrind(i)\r\n	}\r\n	select {} // 阻塞\r\n}\r\nfunc thrind( i int){\r\n	for range time.Tick(1000 * time.Millisecond) {\r\n		fmt.Println(\"线程：\",i)\r\n	}\r\n}\r\n```\r\n该例会创建20个协程循环输出，启动之后main程序会一直阻塞，这里就是运用了空select来阻塞，你创建的协程是一个不停息的循环状态，假如所有协程都停止了，还是会报死锁panic。比如将循环注释掉试试：\r\n```go\r\npackage main\r\n\r\nimport (\r\n	\"fmt\"\r\n)\r\n\r\nfunc main(){\r\n	for i := 0; i < 20; i++ { //启动20个协程处理消息队列中的消息\r\n		go thrind(i)\r\n	}\r\n	select {} // 阻塞\r\n}\r\nfunc thrind( i int){\r\n	//for range time.Tick(1000 * time.Millisecond) {\r\n		fmt.Println(\"线程：\",i)\r\n	//}\r\n}\r\n\r\n```\r\n当20个协程执行完毕，程序仍会panic：\r\n```go\r\nfatal error: all goroutines are asleep - deadlock!\r\n\r\ngoroutine 1 [select (no cases)]:\r\nmain.main()\r\n	D:/golang/1/select.go:11 +0x5d\r\n线程： 0\r\n线程： 1\r\n线程： 5\r\n线程： 3\r\n线程： 4\r\n线程： 8\r\n线程： 6\r\n线程： 7\r\n线程： 10\r\n线程： 9\r\n线程： 11\r\n线程： 12\r\n线程： 13\r\n线程： 14\r\n线程： 15\r\n线程： 16\r\n线程： 17\r\n线程： 18\r\n线程： 2\r\n线程： 19\r\n```',',Golang,Select,','2018-09-26 10:25:01',70,0,'2018-10-10 11:32:29',0,'/static/upload/default/blog-default-2.png'),(10,1,'MySQL之学习经验','','',0,'MySQL作为当前非常受宠的关系型数据库来说，由于其开源免费，加之其体积小、性能卓越，一定是IT从业者必备的技能之一。\r\n\r\n------------\r\n\r\n### 什么是MySQL\r\nMySQL是一个关系型数据库管理系统，由瑞典MySQL AB公司开发，目前属于Oracle旗下产品。MySQL是最流行的关系型数据库管理系统之一，在WEB应用方面，MySQL是最好的RDBMS(Relational Database Management System，关系数据库管理系统)应用软件。\r\n\r\nMySQL是一种关系数据库管理系统，关系数据库将数据保存在不同的表中，而不是将所有数据放在一个大仓库内，这样就增加了速度并提高了灵活性。\r\n\r\nMySQL所使用的SQL语言是用于访问数据库的最常用标准化语言。MySQL软件采用了双授权政策，分为社区版和商业版，由于其体积小、速度快、总体拥有成本低，尤其是开放源码这一特点，一般中小型网站的开发都选择MySQL作为网站数据库。\r\n\r\n### LAMP\r\n与其他大型数据库例如Oracle、DB2、SQL Server等相比，MySQL自有它的不足之处，但是这丝毫也没有减少它受欢迎的程度。对于一般的个人使用者和中小型企业来说，MySQL提供的功能已经绰绰有余，加之其开源免费，所以一套稳定而免费的网站系统环境被业界所认可，称之为“LAMP”。\r\n- Linux：免费操作系统就不多说了。\r\n- Apache：免费Web服务器，另外Nginx也非常受欢迎，因此很多时候也会出现LNMP组合。\r\n- MySQL：免费数据库\r\n- PHP：不得不说它是目前网站开发使用最多的语言，但并不影响我对Python与Go的青睐，并且这套组合的P并不仅仅指的就是PHP，还包括Perl和Python。\r\n\r\n### 新手如何学习MySQL\r\n1. 弄清关系型数据库是做什么的\r\n数据库顾名思义就是存储数据的仓库，而关系型数据库则是建立在关系模型基础上的数据库，特点就是可以保存具有关系的数据。\r\n数据库的基本组成：\r\n	- 数据以表格的形式出现\r\n	- 每行为各种记录名称\r\n	- 每列为记录名称所对应的数据域\r\n	- 许多的行和列组成一张表单\r\n	- 若干的表单组成database\r\n2. 了解RDBMS术语\r\n开始学习MySQL数据库前，先了解下RDBMS的一些术语：\r\n	- **数据库**: 数据库是一些关联表的集合。\r\n	- **数据表**: 表是数据的矩阵。在一个数据库中的表看起来像一个简单的电子表格。\r\n	- **列**: 一列（数据元素）包含了相同的数据, 例如邮政编码的数据。\r\n	- **行**：一行（=元组，或记录）是一组相关的数据，例如一条包括账号、密码、邮箱等用户资料的数据。\r\n	- **冗余**：数据集合中重复的数据称为数据冗余，冗余降低了性能，但提高了数据的安全性。\r\n	- **主键**：主键是唯一的。一个数据表中只能包含一个主键。你可以使用主键来查询数据。\r\n	- **外键**：外键用于关联两个表。\r\n	- **复合键**：复合键（组合键）将多个列作为一个索引键，一般用于复合索引。\r\n	- **索引**：使用索引可快速访问数据库表中的特定信息。索引是对数据库表中一列或多列的值进行排序的一种结构。类似于书籍的目录。\r\n	- **参照完整性**: 参照的完整性要求关系中不允许引用不存在的实体。与实体完整性是关系模型必须满足的完整性约束条件，目的是保证数据的一致性。\r\n3. 安装与使用\r\n4. 批量导入导出数据\r\n5. 学习SQL语言并动手练习各种数据库操作\r\n6. 用户与权限\r\n7. 备份与还原\r\n',',MySQL,','2018-09-28 10:10:54',64,0,'2018-09-28 15:21:17',0,'/static/upload/smallpic/20180928/1538100799296484700.jpeg'),(11,1,'CentOS7防火墙firewall基础必学','','',0,'### Firewall是什么\r\n常说的防火墙，一般指的是网络层防火墙，网络层防火墙可视为一种IP封包过滤器，运作在底层的TCP/IP协议堆栈上。我们可以以枚举的方式，只允许符合特定规则的封包通过，其余的一概禁止穿越防火墙。这些规则通常可以经由管理员定义或修改，不过某些防火墙设备可能只能套用内置的规则。\r\n主流操作系统以及许多网络设备都已内置防火墙功能，如常用的：Windows防火墙、CentOS6的`iptables`、CentOS7的`firewall`等，作为运维的必备知识点，一定要掌握各种常用防火墙的操作。\r\n\r\n### CentOS7的firewall\r\n- 开启防火墙\r\n```shell\r\nsystemctl start firewalld\r\n```\r\n\r\n- 查看当前状态\r\n```shell\r\nsystemctl status firewalld\r\n```\r\n\r\n- 查看活动区域\r\n```shell\r\nfirewall-cmd --get-active-zones\r\n```\r\n\r\n- 查看所有支持的服务\r\n```shell\r\nfirewall-cmd --get-service --permanent\r\n```\r\n\r\n- 开启、关闭应急模式（阻断、恢复所有网络连接）\r\n```shell\r\nfirewall-cmd --panic-on\r\nfirewall-cmd --panic-off\r\n```\r\n\r\n- 重新加载防火墙\r\n```shell\r\nfirewall-cmd --reload\r\n```\r\n\r\n- 开启某个端口（这里有点别扭，无法指定黑白名单）\r\n```shell\r\nfirewall-cmd --permanent --zone=public --add-port=8080-8081/tcp\r\n```\r\n\r\n- 开启某个服务\r\n```shell\r\nfirewall-cmd --permanent --zone=public --add-service=https\r\n```\r\n\r\n- 查看已开启的服务\r\n```shell\r\nfirewall-cmd --permanent --zone=public --list-services\r\n```\r\n\r\n- 查看已开启的端口\r\n```shell\r\nfirewall-cmd --permanent --zone=public --list-ports\r\n```\r\n\r\n- 到这里需要说一下了，系统默认开启的是public区域，permanent参数表示永久添加规则，不带该参数仅临时添加规则，重启后会恢复，另外所有add或remove之后必须reload重载才会生效。\r\n\r\n- 最后有一个重要的点就是针对IP段来限制端口的访问，刚提高过，开启端口时并没有黑白名单的功能，不过这里还是有富规则来单独处理的，其实用起来还是有点别扭的，本可以在一条规则中提现的，不明白为什么非要单独出来配置，尽管如此，弄清楚就行了，假如需要针对22端口，仅允许192.168.8.88这个IP访问该端口，该如下设置：\r\n```shell\r\nfirewall-cmd --permanent --add-rich-rule=\"rule family=\"ipv4\" source address=\"192.168.8.88\" port protocol=\"tcp\" port=\"22\" accept\"\r\nfirewall-cmd --permanent --remove-service=ssh\r\nfirewall-cmd --permanent --remove-port=22/tcp\r\nfirewall-cmd --reload\r\n```\r\n这里关闭ssh服务与关闭22端口，是将该端口可能对外直接开放的地方都关掉，仅添加一条白名单的富规则来限制22端口的访问，这样才能达到目的，否则如ssh服务或22端口是开启状态，添加的白名单富规则没有任何实质效果，还是会继续对外开放该端口，这就是我说比较别扭的地方，感觉真的没有windows防火墙舒服，不过对于CentOS而言，防火墙的改变确实要比6时代的iptables更清晰明了一些。\r\n**另外发现一个小Bug，在CentOS7图形桌面手动操作防火墙时，无法手动添加富规则，用命令行才可以加上去，没找到原因，试了很多遍还是放弃了，所以记录一下，也许是我没弄对。。**\r\n\r\n- 查看已添加的富规则\r\n```shell\r\nfirewall-cmd --permanent --list-rich-rules\r\n```\r\n',',CentOS,firewall,','2018-10-08 15:00:00',44,0,'2018-10-08 16:16:05',0,'/static/upload/default/blog-default-1.png'),(12,1,'CentOS7安装nginx服务','','',0,'最近想重新在linux上练练手，顺便把nginx的安装记录一下，nginx不用多说，前面windows的环境安装就说过，个人非常喜欢它，好用又强大，nginx本身就最适合linux服务器的运行环境，只是安装起来相对windows要稍复杂一点。另外之前也简单介绍过LNMP组合环境，该组合就是Linux安装nginx的必学指引。\r\n\r\n- gcc安装\r\n安装nginx需要先将官网下载的源码进行编译，编译依赖gcc环境。\r\n```shell\r\nyum install gcc-c++\r\n```\r\n\r\n- PCRE pcre-devel安装\r\nPCRE(Perl Compatible Regular Expressions)是一个Perl库，包括perl兼容的正则表达式库。nginx的http模块使用pcre来解析正则表达式，所以需要在linux上安装pcre库，pcre-devel是使用pcre开发的一个二次开发库。\r\n```shell\r\nyum install -y pcre pcre-devel\r\n```\r\n\r\n- zlib安装\r\nzlib库提供了很多种压缩和解压缩的方式，nginx使用zlib对http包的内容进行gzip。\r\n```shell\r\nyum install -y zlib zlib-devel\r\n```\r\n\r\n- OpenSSL安装\r\nOpenSSL是一个强大的安全套接字层密码库，囊括主要的密码算法、常用的密钥和证书封装管理功能及SSL协议，并提供丰富的应用程序供测试或其它目的使用。nginx不仅支持http协议，还支持https（即在ssl协议上传输http）。\r\n```shell\r\nyum install -y openssl openssl-devel\r\n```\r\n\r\n- 直接下载.tar.gz安装包，地址：\r\n[https://nginx.org/en/download.html]( https://nginx.org/en/download.html?_blank)\r\n![](/static/upload/bigpic/20181009/1539056575840717300_small.png)\r\n\r\n- 或者wget命令下载（推荐）。\r\n```shell\r\nwget -c https://nginx.org/download/nginx-1.12.2.tar.gz\r\n```\r\n我下载的是1.12.2版本，个人用了很久目前来说没什么问题的版本。\r\n\r\n- 解压配置安装，默认配置即可：\r\n```shell\r\ntar -zxvf nginx-1.12.2.tar.gz\r\ncd nginx-1.12.2\r\n./configure --prefix=/usr/local/nginx --with-http_stub_status_module --with-http_ssl_module\r\nmake & make install\r\n```\r\n\r\n- 查找默认安装路径：\r\n```shell\r\nwhereis nginx\r\n```\r\n输出\r\n```shell\r\nnginx: /usr/local/nginx\r\n```\r\n\r\n- 启动、停止、重载\r\n```shell\r\ncd /usr/local/nginx/sbin/\r\n./nginx\r\n./nginx -s stop\r\n./nginx -s quit\r\n./nginx -s reload\r\n```\r\n`./nginx -s quit`:此方式停止步骤是待nginx进程处理任务完毕进行停止。\r\n`./nginx -s stop`:此方式相当于先查出nginx进程id再使用kill命令强制杀掉进程。\r\n\r\n- 查询nginx进程\r\n```shell\r\nps aux|grep nginx\r\n```\r\n\r\n- 后面就进入该如何使用nginx的范畴了，此节忽略。另外修改配置后，需要重载才会生效。\r\n\r\n- 开机自启动：\r\n```shell\r\nvim /etc/rc.local\r\n```\r\n增加一行`/usr/local/nginx/sbin/nginx`\r\n设置执行权限：\r\n```shell\r\nchmod 755 /etc/rc.local\r\n```\r\n![](/static/upload/bigpic/20181009/1539057463186313500_small.png)\r\n\r\n- 最后还可以将nginx添加到系统服务，其实个人觉得没什么太大必要，也忽略。',',CentOS,Nginx,','2018-10-09 11:07:24',91,0,'2019-12-17 14:19:19',0,'/static/upload/default/blog-default-3.png'),(13,1,'leetcode基础算法学习之FindIndex','','',0,'### 习题一：\r\n给定一个整数数组，使其中两个数字相加得到特定目标而返回两个数字的索引。假设每个输入只有一个解决方案，并且不会两次使用相同的元素。\r\n给定：`nums = [2, 7, 11, 15], target = 22`\r\n由于：`nums[1] + nums[3] = 7 + 15 = 22`\r\n输出：`[1, 3]`\r\n\r\n### 解题思路：\r\n首先由最笨的方法逐步转入利用巧妙的算法，尽量多培养自己逐渐升级思维的习惯，这样才可以深入理解各种算法带来的精髓。\r\n\r\n### 方法一：蛮力\r\n循环遍历每个元素x并找出是否有另一个值等于target-x\r\n```go\r\nfunc twoSum1(nums []int, target int) []int {\r\n	for i := 0; i < len(nums); i++ {\r\n		for j := i + 1; j < len(nums); j++ {\r\n			if nums[j] == target - nums[i] {\r\n				return []int{i, j}\r\n			}\r\n		}\r\n	}\r\n	return []int{}\r\n}\r\n```\r\n此方法看似简单，可实际遍历后的时间复杂度为：n²\r\n\r\n### 方法二：two-pass map\r\n为了提高效率，我们可以利用map保存元素和对应的索引，利用高效的map来单次遍历查询，时间复杂度可以减少为：n\r\n```go\r\nfunc twoSum2(nums []int, target int) []int {\r\n	h_table := map[int]int{}\r\n	for i := 0; i < len(nums); i++ {\r\n		h_table[nums[i]] = i\r\n	}\r\n	for i := 0; i < len(nums); i++ {\r\n		diff := target - nums[i]\r\n		if _, ok := h_table[diff]; ok && h_table[diff] != i{\r\n			return []int{i, h_table[diff]}\r\n		}\r\n	}\r\n	return []int{}\r\n}\r\n```\r\n可这里还是看起来很别扭，因为还是进行了2次遍历。\r\n\r\n### 方法三：one-pass map\r\n事实上，只需要1次就行了。当我们迭代并将元素插入表中时，我们还可以回顾检查表中是否已存在当前元素的补码。如果存在，我们找到了解决方案并立即返回。\r\n```go\r\nfunc twoSum3(nums []int, target int) []int {\r\n	h_table := map[int]int{}\r\n	for i := 0; i < len(nums); i++ {\r\n		diff := target - nums[i]\r\n		if _, ok := h_table[diff]; ok && h_table[diff] != i{\r\n			return []int{h_table[diff], i}\r\n		} else {\r\n			h_table[nums[i]] = i\r\n		}\r\n	}\r\n	return []int{}\r\n}\r\n```\r\n最后看看3种方法的运行结果吧\r\n```go\r\nfmt.Println(twoSum1([]int{2,7,11,15}, 22))\r\nfmt.Println(twoSum2([]int{2,7,11,15}, 22))\r\nfmt.Println(twoSum3([]int{2,7,11,15}, 22))\r\n```\r\n输出：\r\n```go\r\n[1 3]\r\n[1 3]\r\n[1 3]\r\n```\r\n最后，还可以使用多一些的测试用例，测试一下3种方法运行时间的差别，即可深入理解算法带来的效率。',',算法,','2018-10-18 16:48:06',44,0,'2018-10-19 13:40:04',0,'/static/upload/default/blog-default-8.png'),(14,1,'leetcode基础算法学习之addTwoNumbers','','',0,'### 习题二：\r\n您将获得两个非空链表，表示两个非负整数。数字以相反的顺序存储，每个节点包含一个数字。两个数字相加并将其作为链表返回。您可以假设这两个数字不包含任何前导零，除了数字0本身。\r\nInput: `(2 -> 4 -> 3) + (5 -> 6 -> 4)`\r\nOutput: `7 -> 0 -> 8`\r\nExplanation: `342 + 465 = 807`\r\n\r\n### 解题思路\r\n- 基本思路：\r\n两个数值使用单链表来存储，链表每一个节点存储一个数字，从链表头开始，由低位到高位。如把两个链表都遍历一遍，算出所表示的数值，然后相加得到答案后再构建要返回的链表，这显然是不合理的，最好的解决办法一定是依靠链表的结构与所有位数数字相加进位来处理。首先是单个数字最大是9，那么算上上一位的进位，当前向高位的进位值最大是`1+9+9=19`，因此进位要么是1，要么就是0。\r\n- 考虑特殊情况：\r\n	+ 当一个列表比另一个列表长时。\r\n	+ 当一个列表为空时。\r\n	+ 总和之后可能会出现多1进位，这很容易忘记。如99+1=100\r\n\r\n### 实现代码\r\n```go\r\npackage main\r\n\r\nimport \"fmt\"\r\n\r\ntype ListNode struct {\r\n	Val int\r\n	Next *ListNode\r\n}\r\n\r\nfunc addTwoNumbers(l1 *ListNode, l2 *ListNode) *ListNode {\r\n	var dummyHead = &ListNode{}\r\n	var p, q = l1, l2\r\n	var curr = dummyHead\r\n	var carry int\r\n	for p != nil || q != nil {\r\n		x, y := 0, 0\r\n		if p != nil {\r\n			x = p.Val\r\n		}\r\n		if q != nil {\r\n			y = q.Val\r\n		}\r\n		sum := x + y + carry\r\n		carry = sum / 10\r\n		curr.Next = &ListNode{sum % 10, nil}\r\n		curr = curr.Next\r\n		if p != nil {\r\n			p = p.Next\r\n		}\r\n		if q != nil {\r\n			q = q.Next\r\n		}\r\n	}\r\n	if carry > 0 {\r\n		curr.Next = &ListNode{carry, nil}\r\n	}\r\n	return dummyHead.Next\r\n}\r\n\r\nfunc main() {\r\n	l1 := &ListNode{2, &ListNode{4, &ListNode{3, nil}}}\r\n	l2 := &ListNode{5, &ListNode{6, &ListNode{4, nil}}}\r\n	fmt.Println(addTwoNumbers(l1, l2))\r\n	fmt.Println(addTwoNumbers(l1, l2).Next)\r\n	fmt.Println(addTwoNumbers(l1, l2).Next.Next)\r\n}\r\n```\r\n\r\n### 代码总结\r\n- 首先定义好单链表结构，该结构是原出题者在题目中已经有所提示，按题目要求，函数应接收2个单链表，返回1个相加之后的单链表。\r\n- 第11行初始化一个临时容器`dummyHead`，在leetcode上称之为虚拟头，该容器指向一个内存地址，同时指定当前动态容器`curr`也为该指针，第25行当`curr.next`有改变时，同时代表着`dummyHead.next`在改变，而第26行`curr`自身的指针被重写绑定刚刚改变的`dummyHead.next`指针。\r\n- 第15行为了排除特殊情况1和2，让接收的2个链表一直循环到`nil`为止，任何1个链表没有`nil`都将进入循环。\r\n- 第34行为了排除特殊情况3，当循环结束时进位`carry`变量大于0时，则最后添加一个val=carry的新实例指针即可。\r\n- 最后强调一下，该习题所考核的重点是如何巧妙利用指针以及非常常用的整除求余（8%10=8, 12%10=2）与进位算法（12/10=1, 9/10=0），这在今后的项目实战中可能会经常用到。\r\n',',算法,','2018-10-19 13:40:19',59,0,'2018-10-19 16:35:28',0,'/static/upload/default/blog-default-0.png'),(15,1,'leetcode基础算法学习之LongestSubstr','','',0,'### 习题三：\r\n给定一个字符串，找到不重复字符的最长子字符串的长度。\r\nInput: `abcabcbb`\r\nOutput: `3`\r\nExplanation: 找到答案`abc`, 长度为`3`\r\nInput: `bbbbb`\r\nOutput: `1`\r\nExplanation: 找到答案`b`, 长度为`1`\r\nInput: `pwwkew`\r\nOutput: `3`\r\nExplanation: 找到答案`wke`, 长度为`3`\r\n注意：这里是最长子字符串，而不是最长子序列。如果是最长子序列应该是`pwke`\r\n\r\n### 方法一：暴力\r\n仍然采取由简入繁的方式来逐步寻找思路，首先第一解题的感觉肯定是逐个检查所有子字符串，看它是否没有重复的字符。这也是最笨的方法，不过还是用这方法先解一下：\r\n\r\n```go\r\npackage main\r\n\r\nimport (\r\n	\"math\"\r\n	\"fmt\"\r\n)\r\n\r\nfunc lengthOfLongestSubstring1(s string) int  {\r\n	n := len(s)\r\n	ans := float64(0)\r\n	for i := 0; i < n; i++ {\r\n		for j := i + 1; j <= n; j++ {\r\n			if allUnique(s, i, j) {\r\n				ans = math.Max(ans, float64(j - i))\r\n			}\r\n		}\r\n	}\r\n	return int(ans)\r\n}\r\n\r\nfunc allUnique(s string, start int, end int) bool {\r\n	h_table := map[string]int{}\r\n	for i := start; i < end; i++ {\r\n		ch := string(s[i])\r\n		if _, ok := h_table[ch]; ok {\r\n			return false\r\n		}\r\n		h_table[ch] = i\r\n	}\r\n	return true\r\n}\r\n\r\nfunc main() {\r\n	fmt.Println(lengthOfLongestSubstring2(\"abcabcbb\"))\r\n	fmt.Println(lengthOfLongestSubstring2(\"bbbbb\"))\r\n	fmt.Println(lengthOfLongestSubstring2(\"pwwkew\"))\r\n}\r\n```\r\n输出：\r\n```go\r\n3\r\n1\r\n3\r\n```\r\n用最笨的方法，可以简单得到想要的答案，可该方法很明显可以看出时间复杂度为n³（2次for循环，1次allUnique判断）。因此，肯定不是最有效率的办法。\r\n\r\n### 方法二：滑动窗口\r\n再来分析一下，我们反复检查一个子字符串，看它是否有重复的字符，这显然是不必要的，假设有1个子字符串为s[i:j-1]是不存在重复字符串的，我们仅需要检查s[j]是否在s[i:j-1]中就可以了，这种方法是我们在字符串或数组等问题中常用的1种抽象概念并命名为滑动窗口。另外我们检查是否有重复字符串时，也完全不需要扫描子字符串，我们可以使用map来检查当前需要查询的字符串，从这两点出发，理应会提高很多效率。\r\n```go\r\npackage main\r\n\r\nimport (\r\n	\"fmt\"\r\n	\"math\"\r\n)\r\n\r\nfunc lengthOfLongestSubstring2(s string) int  {\r\n	n := len(s)\r\n	h_table := map[string]int{}\r\n	ans := float64(0)\r\n	i, j := 0, 0\r\n	for i < n && j < n {\r\n		if _, ok := h_table[string(s[j])]; !ok {\r\n			h_table[string(s[j])] = i\r\n			j++\r\n			ans = math.Max(ans, float64(j - i))\r\n		} else {\r\n			delete(h_table, string(s[i]))\r\n			i++\r\n		}\r\n	}\r\n	return int(ans)\r\n}\r\n\r\nfunc main() {\r\n	fmt.Println(lengthOfLongestSubstring2(\"abcabcbb\"))\r\n	fmt.Println(lengthOfLongestSubstring2(\"bbbbb\"))\r\n	fmt.Println(lengthOfLongestSubstring2(\"pwwkew\"))\r\n}\r\n```\r\n输出：\r\n```go\r\n3\r\n1\r\n3\r\n```\r\n代码中可以看出，时间复杂度为n-2n，在最坏的情况下，每个角色将被访问2次i和j。\r\n\r\n### 方法三：\r\n我们还可以再度优化，让时间复杂度降低到n，我们可以将map的key和value分别映射为字符和字符索引，当找到重复字符时，可以立即跳过字符。\r\n```go\r\npackage main\r\n\r\nimport (\r\n	\"fmt\"\r\n	\"math\"\r\n)\r\n\r\nfunc lengthOfLongestSubstring3(s string) int  {\r\n	n := len(s)\r\n	h_table := map[string]int{}\r\n	ans := float64(0)\r\n	for j, i := 0, 0; j < n; j++ {\r\n		if key, ok := h_table[string(s[j])]; ok {\r\n			i = int(math.Max(float64(key), float64(i)))\r\n		}\r\n		ans = math.Max(ans, float64(j - i + 1))\r\n		h_table[string(s[j])] = j + 1\r\n	}\r\n	return int(ans)\r\n}\r\n\r\nfunc main() {\r\n	fmt.Println(lengthOfLongestSubstring3(\"abcabcbb\"))\r\n	fmt.Println(lengthOfLongestSubstring3(\"bbbbb\"))\r\n	fmt.Println(lengthOfLongestSubstring3(\"pwwkew\"))\r\n}\r\n```\r\n输出：\r\n```go\r\n3\r\n1\r\n3\r\n```\r\n\r\n### 方法四：\r\n前面我们已经做的很好了，时间复杂度已经降到了n，可前面的实现都没有对s的字符串的字符集进行假设，如果我们知道charset相当小，我们可以利用整数数组来代替直接访问map，数组的索引及代表字符集中的某个字符。\r\n常用的字符集数组有：\r\n- [26]int{} 用于字母`a-z`或`A-Z`\r\n- [128]int{} 用于`ASCII`\r\n- [256]int{} 用于`扩展ASCII`\r\n\r\n```go\r\npackage main\r\n\r\nimport (\r\n	\"fmt\"\r\n	\"math\"\r\n)\r\n\r\nfunc lengthOfLongestSubstring4(s string) int  {\r\n	n := len(s)\r\n	h_table := [128]int{}\r\n	ans := float64(0)\r\n	for j, i := 0, 0; j < n; j++ {\r\n		i = int(math.Max(float64(h_table[s[j]]), float64(i)))\r\n		ans = math.Max(ans, float64(j - i + 1))\r\n		h_table[s[j]] = j + 1\r\n	}\r\n	return int(ans)\r\n}\r\n\r\nfunc main() {\r\n	fmt.Println(lengthOfLongestSubstring4(\"abcabcbb\"))\r\n	fmt.Println(lengthOfLongestSubstring4(\"bbbbb\"))\r\n	fmt.Println(lengthOfLongestSubstring4(\"pwwkew\"))\r\n}\r\n```\r\n输出：\r\n```go\r\n3\r\n1\r\n3\r\n```\r\n时间复杂度与方法3一致，但在另一标准**空间复杂度**上明显要更低一些。\r\n\r\n### 习题小结\r\n本节重点是巧妙利用滑动窗口概念来处理字符串等效率问题，并大致了解一下空间复杂度是一个什么概念。',',算法,','2018-10-22 10:08:40',56,0,'2018-10-22 14:29:49',0,'/static/upload/default/blog-default-6.png'),(16,1,'leetcode基础算法学习之ReverseInt','','',0,'### 习题四：\r\n给定32位有符号整数，整数的反向数字。反向整数溢出时，函数返回0。\r\nInput: `123`\r\nOutput: `321`\r\nInput: `-123`\r\nOutput: `-321`\r\nInput: `120`\r\nOutput: `21`\r\n\r\n### 解题思路：\r\n第一直觉可以与反转字符串类似地完成反转整数。但这显然是不正确的做法，我们可以利用简单的数学算法，巧妙的反转过来，首先找到规律，反转前的个位数将会作为反转后的最高位，以此类推，这里需要注意的是题目给定的是32位有符号的整数，整数存在边界即最大值或最小值，加入反转之后得到的整数溢出边界，则要返回0。\r\n\r\n### 实现代码：\r\n```go\r\npackage main\r\n\r\nimport (\r\n	\"math\"\r\n	\"fmt\"\r\n)\r\n\r\nfunc reverse(x int) int {\r\n	rev := 0\r\n	for x != 0 {\r\n		pop := x % 10\r\n		x /= 10\r\n		if rev > math.MaxInt32/10 || (rev == math.MaxInt32/10 && pop > 7) {\r\n			return 0\r\n		}\r\n		if rev < math.MinInt32/10 || (rev == math.MinInt32/10 && pop < -8) {\r\n			return 0\r\n		}\r\n		rev = rev * 10 + pop\r\n	}\r\n	return rev\r\n}\r\n\r\nfunc main() {\r\n	fmt.Println(reverse(123))\r\n	fmt.Println(reverse(-123))\r\n	fmt.Println(reverse(120))\r\n}\r\n```\r\n输出：\r\n```go\r\n321\r\n-321\r\n21\r\n```\r\n\r\n### 知识点：\r\n1. 整数边界的处理\r\n2. 处理整数最常用的整除算法',',算法,','2018-10-22 14:28:39',37,0,'2018-10-22 14:52:12',0,'/static/upload/default/blog-default-6.png'),(17,1,'leetcode基础算法学习之maxArea','','',0,'### 习题四：\r\n- 给定n个非负整数`a1,a2,...,an`，其中每个表示坐标(i,ia)处的点，使得线的两个端点位于x轴与y轴的(i,ia)和(i,0)。\r\n- 找到两条线，它们与x轴一起形成一个可以含有最多水的容器。\r\n- 求出最大容器的平面面积，您可能不会倾斜容器，n至少为2。\r\n\r\nInput: `[1,8,6,2,5,4,8,3,7]`\r\nOutput: `49`\r\n如下图所示：\r\n![](/static/upload/bigpic/20181023/1540259599003727100_small.jpeg)\r\n上面的垂直线由数组`[1,8,6,2,5,4,8,3,7]`表示。在这种情况下，容器可容纳水的最大平面面积（蓝色部分）为`49`。\r\n\r\n### 解题思路：\r\n我们必须最大化可以在垂直线之间形成的区域，最简单可用的办法肯定是计算每一对可能线的面积，最终得得到最大面积。\r\n\r\n### 方法一：蛮力\r\n```go\r\npackage main\r\n\r\nimport (\r\n	\"fmt\"\r\n	\"math\"\r\n)\r\n\r\nfunc maxArea1(height []int) int {\r\n	maxarea := 0\r\n	r := len(height)\r\n	for i := 0; i < r; i++ {\r\n		for j := i + 1; j < r; j++ {\r\n			maxarea = int(math.Max(float64(maxarea), math.Min(float64(height[i]), float64(height[j])) * float64(j - i)))\r\n		}\r\n	}\r\n	return maxarea\r\n}\r\n\r\nfunc main() {\r\n	fmt.Println(maxArea1([]int{1,8,6,2,5,4,8,3,7}))\r\n}\r\n```\r\n输出：\r\n```go\r\n49\r\n```\r\n时间复杂度：`n²`\r\n很显然，既然提出了这种题目，肯定会有更优的办法来处理这种问题，可以自己先找一找直觉，还有什么方法可以降低时间复杂度呢？任何一种循环操作，如果找到中间的规律或要点，就有极大可能找到更优的办法，所以在这里总结一点经验，在学习阶段中，不要放过任何一个可以提升效率的机会，养成这样一个习惯，更不要任何问题都蛮力使用循环遍历，尽管循环遍历是最常用的，但也必须要让一些本身可能想不到的算法深刻引入脑中且同样成为自己处理问题的常用办法，毕竟效率是极重要的。\r\n\r\n### 方法二：类似滑动窗口概念\r\n个人觉得这个类似滑动窗口的概念，虽然不完全是。\r\n首先可以找到2个规律：\r\n1. 线与线之间形成的区域是受到较短线高度的限制。\r\n2. 线的间隔越远，获得的区域越多。\r\n\r\n因此我们可以指定两条最远的线为起点，向内逐一移动，移动时只移动其中较短的一条，因为移动较长的一条的话我们不会得到任何面积的增加，移动较短的一条才有可能增加面积。详细过程可查看下面的视频：\r\n<video controls=\"\" preload=\"none\" poster=\"/static/upload/media/mp4/20181023/1540268914601055300.jpg\"><source src=\"/static/upload/media/mp4/20181023/1540268914601055300.mp4\" type=\"video/mp4\"></video>\r\n\r\n```go\r\npackage main\r\n\r\nimport (\r\n	\"fmt\"\r\n	\"math\"\r\n)\r\n\r\nfunc maxArea2(height []int) int {\r\n	maxarea := 0\r\n	l := 0\r\n	r := len(height) - 1\r\n	for l < r {\r\n		maxarea = int(math.Max(float64(maxarea), math.Min(float64(height[l]), float64(height[r])) * float64(r - l)))\r\n		if height[l] < height[r] {\r\n			l++\r\n		} else {\r\n			r--\r\n		}\r\n	}\r\n	return maxarea\r\n}\r\n\r\nfunc main() {\r\n	fmt.Println(maxArea2([]int{1,8,6,2,5,4,8,3,7}))\r\n}\r\n```\r\n时间复杂度：`n`',',算法,','2018-10-23 09:36:07',39,0,'2018-10-23 12:40:25',0,'/static/upload/default/blog-default-5.png'),(18,1,'ansible学习记录-远程开启exe不能挂起UI界面','','',0,'### 问题的产生\r\n利用ansible批量管理windows服务器，肯定会遇到开启某程序exe无法挂起UI界面，仅仅挂起了后台进程，无论利用win_shell还是win_psexec,都始终无法挂起程序的UI界面。\r\n\r\n### 如何解决\r\n程序exe的UI界面，前提条件必须得有当前登录用户的标识所关联，否则就会仅开启后台进程的情况，因此仔细阅读win_psexec的官方文档后，发现有一个参数session，描述是Specifies the session ID to use.This parameter works in conjunction with interactive.It has no effect when interactive is set to no.（意思是：指定使用会话ID，此参数配合interactive使用，如果interactive设置为no则无效），虽然一开始没有联想到windows的用户标识，后来总是发现问题就出在为什么interactive这个参数设置了却始终无法开启UI界面，抱着尝试的心态，**将session这个参数带上，并选择当前windows登录账户的用户标识作关联**，结果真的成功了。困扰我一两个礼拜的问题终于解决了。',',ansible,','2019-11-11 10:02:05',27,0,'2019-11-11 10:26:59',0,'/static/upload/default/blog-default-6.png');
/*!40000 ALTER TABLE `tb_post` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_tag`
--

DROP TABLE IF EXISTS `tb_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_tag` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(20) NOT NULL DEFAULT '',
  `count` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `tb_tag_name` (`name`),
  KEY `tb_tag_count` (`count`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_tag`
--

LOCK TABLES `tb_tag` WRITE;
/*!40000 ALTER TABLE `tb_tag` DISABLE KEYS */;
INSERT INTO `tb_tag` VALUES (1,'记录',2),(2,'Golang',7),(3,'Beego',1),(4,'interface',1),(5,'Goroutine',2),(6,'Channel',2),(7,'Select',1),(8,'MySQL',1),(9,'CentOS',2),(10,'firewall',1),(11,'Nginx',1),(12,'算法',5),(13,'ansible',1);
/*!40000 ALTER TABLE `tb_tag` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_tag_post`
--

DROP TABLE IF EXISTS `tb_tag_post`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=130 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_tag_post`
--

LOCK TABLES `tb_tag_post` WRITE;
/*!40000 ALTER TABLE `tb_tag_post` DISABLE KEYS */;
INSERT INTO `tb_tag_post` VALUES (19,2,3,0,'2018-09-13 12:15:38'),(20,3,3,0,'2018-09-13 12:15:38'),(22,1,1,0,'2018-09-13 16:16:35'),(41,2,5,0,'2018-09-19 15:52:21'),(51,2,6,0,'2018-09-20 12:19:02'),(52,5,6,0,'2018-09-20 12:19:02'),(53,6,6,0,'2018-09-20 12:19:02'),(66,2,7,0,'2018-09-21 10:21:07'),(67,5,7,0,'2018-09-21 10:21:07'),(68,6,7,0,'2018-09-21 10:21:07'),(70,2,8,0,'2018-09-26 10:24:54'),(75,8,10,0,'2018-09-28 15:21:17'),(78,9,11,0,'2018-10-08 16:16:05'),(79,10,11,0,'2018-10-08 16:16:05'),(98,2,9,0,'2018-10-10 11:32:29'),(99,7,9,0,'2018-10-10 11:32:29'),(100,2,4,0,'2018-10-18 16:48:01'),(101,4,4,0,'2018-10-18 16:48:01'),(108,12,13,0,'2018-10-19 13:40:04'),(113,12,14,0,'2018-10-19 16:35:28'),(121,12,15,0,'2018-10-22 14:29:49'),(123,12,16,0,'2018-10-22 14:52:12'),(125,12,17,0,'2018-10-23 12:40:25'),(126,13,18,0,'2019-11-11 10:26:59'),(127,1,2,0,'2019-12-06 13:41:05'),(128,9,12,0,'2019-12-17 14:19:19'),(129,11,12,0,'2019-12-17 14:19:19');
/*!40000 ALTER TABLE `tb_tag_post` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_user`
--

DROP TABLE IF EXISTS `tb_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_user`
--

LOCK TABLES `tb_user` WRITE;
/*!40000 ALTER TABLE `tb_user` DISABLE KEYS */;
INSERT INTO `tb_user` VALUES (1,'admin','e10adc3949ba59abbe56e057f20f883e','云丶先生','117976509@qq.com','2019-12-17 14:18:44',63,'27.17.143.141','',1,'1|2|3|4|5|6|7','/static/upload/default/wuyun1.jpg',0),(2,'Ethan','4100a7b45c8063dd3a6db31c531639e4','Ethan','sergeychang@gmail.com','2018-09-17 00:09:13',2,'180.154.116.90','',1,'','/static/upload/default/user-default-60x60.png',3),(3,'kq1121','e10adc3949ba59abbe56e057f20f883e','kakafu','1312312@qq.com','2018-10-18 11:27:52',1,'183.14.133.79','',1,'','/static/upload/default/user-default-60x60.png',3),(4,'a_123456','e10adc3949ba59abbe56e057f20f883e','efg','123456@123.com','2018-10-30 08:54:14',1,'116.7.97.220','',1,'','/static/upload/default/user-default-60x60.png',3),(5,'test1','697d5b7cad47ee10fa690f98caad463a','test1','117976509@qq.com','2018-11-02 17:21:16',3,'58.49.22.242','',1,'','/static/upload/smallpic/20181102/1541150494141341900.jpeg',2),(6,'oNFtRcrnd','f5b2077d1c7e86575c4eef4e89d96ea0','XFHJnTwAfRdPQ','rolflyons8@gmail.com','2019-11-28 21:01:53',0,'113.172.18.14','',1,'','/static/upload/default/user-default-60x60.png',3),(7,'DvmoOHiMhALdrjn','c8c26d7ad83f34b09ad7a0e67b92afa9','erNqQvgKEfL','rolflyons8@gmail.com','2019-11-28 21:01:54',0,'113.172.18.14','',1,'','/static/upload/default/user-default-60x60.png',3),(8,'giHUzBVR','bf4fcab86410cb8b8c93586c2aa49a4f','DCEmibjNKBPgQh','georgelong214@gmail.com','2019-12-10 14:22:17',0,'37.114.176.85','',1,'','/static/upload/default/user-default-60x60.png',3);
/*!40000 ALTER TABLE `tb_user` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-12-17 15:43:25
