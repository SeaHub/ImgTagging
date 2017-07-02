-- phpMyAdmin SQL Dump
-- version 4.5.2
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: 2017-06-30 13:18:38
-- 服务器版本： 5.7.9
-- PHP Version: 5.6.16

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `picture`
--

-- --------------------------------------------------------

--
-- 表的结构 `admin_info`
--

DROP TABLE IF EXISTS `admin_info`;
CREATE TABLE IF NOT EXISTS `admin_info` (
  `a_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '管理员信息id',
  `userId` int(10) UNSIGNED NOT NULL COMMENT '用户id',
  `name` varchar(50) NOT NULL COMMENT '管理员名字',
  PRIMARY KEY (`a_id`),
  UNIQUE KEY `userId` (`userId`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 表的结构 `failed_jobs`
--

DROP TABLE IF EXISTS `failed_jobs`;
CREATE TABLE IF NOT EXISTS `failed_jobs` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `connection` text COLLATE utf8_unicode_ci NOT NULL,
  `queue` text COLLATE utf8_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- 表的结构 `hobby_history`
--

DROP TABLE IF EXISTS `hobby_history`;
CREATE TABLE IF NOT EXISTS `hobby_history` (
  `hh_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `i_id` int(11) UNSIGNED NOT NULL COMMENT '图片id',
  `userId` int(11) UNSIGNED NOT NULL COMMENT '用户id',
  PRIMARY KEY (`hh_id`),
  KEY `i_id` (`i_id`),
  KEY `userId` (`userId`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='兴趣推送历史表';

-- --------------------------------------------------------

--
-- 表的结构 `image`
--

DROP TABLE IF EXISTS `image`;
CREATE TABLE IF NOT EXISTS `image` (
  `i_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '图片id',
  `userId` int(10) UNSIGNED NOT NULL COMMENT '管理员用户id',
  `url` varchar(255) NOT NULL COMMENT '图片url',
  `filename` varchar(100) NOT NULL COMMENT '图片文件本地命名',
  `created_at` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`i_id`)
) ENGINE=MyISAM AUTO_INCREMENT=780 DEFAULT CHARSET=utf8 COMMENT='图片存储表';

-- --------------------------------------------------------

--
-- 表的结构 `jobs`
--

DROP TABLE IF EXISTS `jobs`;
CREATE TABLE IF NOT EXISTS `jobs` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `queue` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8_unicode_ci NOT NULL,
  `attempts` tinyint(3) UNSIGNED NOT NULL,
  `reserved` tinyint(3) UNSIGNED NOT NULL,
  `reserved_at` int(10) UNSIGNED DEFAULT NULL,
  `available_at` int(10) UNSIGNED NOT NULL,
  `created_at` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  KEY `jobs_queue_reserved_reserved_at_index` (`queue`,`reserved`,`reserved_at`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- 表的结构 `migrations`
--

DROP TABLE IF EXISTS `migrations`;
CREATE TABLE IF NOT EXISTS `migrations` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `batch` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- 表的结构 `result`
--

DROP TABLE IF EXISTS `result`;
CREATE TABLE IF NOT EXISTS `result` (
  `i_id` int(11) UNSIGNED NOT NULL COMMENT '图片id',
  `tag1` varchar(100) NOT NULL COMMENT '标签1',
  `tag2` varchar(100) NOT NULL COMMENT '标签2',
  `tag3` varchar(100) NOT NULL COMMENT '标签3',
  `tag4` varchar(100) NOT NULL COMMENT '标签4',
  `tag5` varchar(100) NOT NULL COMMENT '标签5',
  `Alternation` smallint(6) NOT NULL DEFAULT '0' COMMENT '更迭次数',
  PRIMARY KEY (`i_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='结果集合';

-- --------------------------------------------------------

--
-- 表的结构 `score_history`
--

DROP TABLE IF EXISTS `score_history`;
CREATE TABLE IF NOT EXISTS `score_history` (
  `sh_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `i_id` int(11) UNSIGNED NOT NULL COMMENT '图片id',
  `userId` int(11) UNSIGNED NOT NULL COMMENT '用户id',
  PRIMARY KEY (`sh_id`),
  KEY `i_id` (`i_id`),
  KEY `userId` (`userId`)
) ENGINE=MyISAM AUTO_INCREMENT=17 DEFAULT CHARSET=utf8 COMMENT='分数推送历史表';

-- --------------------------------------------------------

--
-- 表的结构 `score_tag`
--

DROP TABLE IF EXISTS `score_tag`;
CREATE TABLE IF NOT EXISTS `score_tag` (
  `s_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `userId` int(11) UNSIGNED NOT NULL COMMENT '用户id',
  `t_id` int(11) UNSIGNED NOT NULL COMMENT '标签id',
  `score` tinyint(2) UNSIGNED NOT NULL DEFAULT '0' COMMENT '分数',
  PRIMARY KEY (`s_id`),
  KEY `userId` (`userId`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='用户标签评分表';

-- --------------------------------------------------------

--
-- 表的结构 `sequence_history`
--

DROP TABLE IF EXISTS `sequence_history`;
CREATE TABLE IF NOT EXISTS `sequence_history` (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `userId` int(10) UNSIGNED NOT NULL COMMENT '用户id',
  `start_id` int(11) UNSIGNED NOT NULL DEFAULT '0' COMMENT '开始id 默认为0',
  `last_id` int(11) UNSIGNED NOT NULL COMMENT '最后推送i_id',
  PRIMARY KEY (`id`),
  KEY `userId` (`userId`)
) ENGINE=MyISAM AUTO_INCREMENT=90 DEFAULT CHARSET=utf8 COMMENT='顺序推送历史表';

-- --------------------------------------------------------

--
-- 表的结构 `statistics_tag`
--

DROP TABLE IF EXISTS `statistics_tag`;
CREATE TABLE IF NOT EXISTS `statistics_tag` (
  `st_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `i_id` int(11) UNSIGNED NOT NULL COMMENT '图片id',
  `t_id` int(11) UNSIGNED NOT NULL COMMENT '标签id',
  `num` int(11) UNSIGNED NOT NULL DEFAULT '0' COMMENT '被选次数',
  PRIMARY KEY (`st_id`),
  KEY `i_id` (`i_id`),
  KEY `t_id` (`t_id`)
) ENGINE=MyISAM AUTO_INCREMENT=735 DEFAULT CHARSET=utf8 COMMENT='统计标签表';

-- --------------------------------------------------------

--
-- 表的结构 `tag`
--

DROP TABLE IF EXISTS `tag`;
CREATE TABLE IF NOT EXISTS `tag` (
  `t_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '标签id',
  `t_name` varchar(100) NOT NULL COMMENT '标签名',
  PRIMARY KEY (`t_id`),
  UNIQUE KEY `t_name` (`t_name`)
) ENGINE=MyISAM AUTO_INCREMENT=79 DEFAULT CHARSET=utf8 COMMENT='标签表';

-- --------------------------------------------------------

--
-- 表的结构 `update_record`
--

DROP TABLE IF EXISTS `update_record`;
CREATE TABLE IF NOT EXISTS `update_record` (
  `ur_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `i_id` int(11) UNSIGNED NOT NULL COMMENT '图片id',
  `t_id` int(11) UNSIGNED NOT NULL COMMENT '标签id',
  `filename` varchar(100) NOT NULL COMMENT '图片文件名(冗余)',
  `createTime` int(11) NOT NULL COMMENT '创建时间',
  `is_exec` tinyint(1) UNSIGNED NOT NULL DEFAULT '0' COMMENT '0 未执行 1准备执行或者执行中',
  PRIMARY KEY (`ur_id`),
  KEY `i_id` (`i_id`),
  KEY `t_id` (`t_id`)
) ENGINE=MyISAM AUTO_INCREMENT=16 DEFAULT CHARSET=utf8 COMMENT='准备要跑更新模型的记录';

-- --------------------------------------------------------

--
-- 表的结构 `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `username` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `password` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `remember_token` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `identity` smallint(6) NOT NULL COMMENT '0普通用户 1管理员',
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_username_unique` (`username`),
  KEY `identity` (`identity`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- 表的结构 `user_hobby`
--

DROP TABLE IF EXISTS `user_hobby`;
CREATE TABLE IF NOT EXISTS `user_hobby` (
  `h_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'id',
  `userId` int(10) UNSIGNED NOT NULL COMMENT '用户id',
  `hobby_name` varchar(50) NOT NULL COMMENT '用户名称',
  `weight` tinyint(5) UNSIGNED NOT NULL DEFAULT '0' COMMENT '兴趣权重',
  PRIMARY KEY (`h_id`),
  KEY `userId` (`userId`)
) ENGINE=MyISAM AUTO_INCREMENT=15 DEFAULT CHARSET=utf8 COMMENT='用户兴趣表';

-- --------------------------------------------------------

--
-- 表的结构 `user_info`
--

DROP TABLE IF EXISTS `user_info`;
CREATE TABLE IF NOT EXISTS `user_info` (
  `u_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '用户信息id',
  `name` varchar(50) DEFAULT NULL COMMENT '用户昵称',
  `userId` int(10) UNSIGNED NOT NULL COMMENT '用户id',
  `avatar` varchar(255) DEFAULT NULL COMMENT '头像url',
  `finish_num` int(8) UNSIGNED NOT NULL DEFAULT '0' COMMENT '已完成的标注',
  `score` int(8) UNSIGNED NOT NULL DEFAULT '0' COMMENT '积分',
  PRIMARY KEY (`u_id`),
  UNIQUE KEY `userId` (`userId`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COMMENT='普通用户信息表';

-- --------------------------------------------------------

--
-- 表的结构 `user_tag`
--

DROP TABLE IF EXISTS `user_tag`;
CREATE TABLE IF NOT EXISTS `user_tag` (
  `ut_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `userId` int(11) UNSIGNED NOT NULL COMMENT '用户id',
  `t_id` int(11) UNSIGNED NOT NULL COMMENT '标签id',
  `i_id` int(11) UNSIGNED NOT NULL COMMENT '图片id',
  `created_at` date NOT NULL,
  `updated_at` date NOT NULL,
  PRIMARY KEY (`ut_id`),
  KEY `t_id` (`t_id`),
  KEY `i_id` (`i_id`),
  KEY `t_id_2` (`t_id`)
) ENGINE=MyISAM AUTO_INCREMENT=3849 DEFAULT CHARSET=utf8;

--
-- 限制导出的表
--

--
-- 限制表 `admin_info`
--
ALTER TABLE `admin_info`
  ADD CONSTRAINT `admin_info_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- 限制表 `user_info`
--
ALTER TABLE `user_info`
  ADD CONSTRAINT `user_info_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
