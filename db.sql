-- phpMyAdmin SQL Dump
-- version 4.0.10.7
-- http://www.phpmyadmin.net
--
-- Host: localhost:3306
-- Generation Time: Dec 16, 2015 at 06:01 PM
-- Server version: 5.5.46-cll
-- PHP Version: 5.4.31

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `gamplong_sms`
--

-- --------------------------------------------------------

--
-- Table structure for table `b8_wordlist`
--

CREATE TABLE IF NOT EXISTS `b8_wordlist` (
  `token` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `count` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`token`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `b8_wordlist`
--

INSERT INTO `b8_wordlist` (`token`, `count`) VALUES
('bayes*dbversion', '2'),
('bayes*texts.ham', '0'),
('bayes*texts.spam', '0');

-- --------------------------------------------------------

--
-- Table structure for table `daemons`
--

CREATE TABLE IF NOT EXISTS `daemons` (
  `Start` text NOT NULL,
  `Info` text NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `gammu`
--

CREATE TABLE IF NOT EXISTS `gammu` (
  `Version` int(11) NOT NULL DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `gammu`
--

INSERT INTO `gammu` (`Version`) VALUES
(13);

-- --------------------------------------------------------

--
-- Table structure for table `inbox`
--

CREATE TABLE IF NOT EXISTS `inbox` (
  `UpdatedInDB` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `ReceivingDateTime` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `Text` text NOT NULL,
  `SenderNumber` varchar(20) NOT NULL DEFAULT '',
  `Coding` enum('Default_No_Compression','Unicode_No_Compression','8bit','Default_Compression','Unicode_Compression') NOT NULL DEFAULT 'Default_No_Compression',
  `UDH` text NOT NULL,
  `SMSCNumber` varchar(20) NOT NULL DEFAULT '',
  `Class` int(11) NOT NULL DEFAULT '-1',
  `TextDecoded` text NOT NULL,
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `RecipientID` text NOT NULL,
  `Processed` enum('false','true') NOT NULL DEFAULT 'false',
  `id_folder` int(11) NOT NULL DEFAULT '1',
  `readed` enum('false','true') NOT NULL DEFAULT 'false',
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Triggers `inbox`
--
DROP TRIGGER IF EXISTS `inbox_timestamp`;
DELIMITER //
CREATE TRIGGER `inbox_timestamp` BEFORE INSERT ON `inbox`
 FOR EACH ROW BEGIN
    IF NEW.ReceivingDateTime = '0000-00-00 00:00:00' THEN
        SET NEW.ReceivingDateTime = CURRENT_TIMESTAMP();
    END IF;
END
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `kalkun`
--

CREATE TABLE IF NOT EXISTS `kalkun` (
  `version` text NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `kalkun`
--

INSERT INTO `kalkun` (`version`) VALUES
('0.7.1');

-- --------------------------------------------------------

--
-- Table structure for table `outbox`
--

CREATE TABLE IF NOT EXISTS `outbox` (
  `UpdatedInDB` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `InsertIntoDB` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `SendingDateTime` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `SendBefore` time NOT NULL DEFAULT '23:59:59',
  `SendAfter` time NOT NULL DEFAULT '00:00:00',
  `Text` text,
  `DestinationNumber` varchar(20) NOT NULL DEFAULT '',
  `Coding` enum('Default_No_Compression','Unicode_No_Compression','8bit','Default_Compression','Unicode_Compression') NOT NULL DEFAULT 'Default_No_Compression',
  `UDH` text,
  `Class` int(11) DEFAULT '-1',
  `TextDecoded` text NOT NULL,
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `MultiPart` enum('false','true') DEFAULT 'false',
  `RelativeValidity` int(11) DEFAULT '-1',
  `SenderID` varchar(255) DEFAULT NULL,
  `SendingTimeOut` timestamp NULL DEFAULT '0000-00-00 00:00:00',
  `DeliveryReport` enum('default','yes','no') DEFAULT 'default',
  `CreatorID` text NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `outbox_date` (`SendingDateTime`,`SendingTimeOut`),
  KEY `outbox_sender` (`SenderID`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `outbox`
--

INSERT INTO `outbox` (`UpdatedInDB`, `InsertIntoDB`, `SendingDateTime`, `SendBefore`, `SendAfter`, `Text`, `DestinationNumber`, `Coding`, `UDH`, `Class`, `TextDecoded`, `ID`, `MultiPart`, `RelativeValidity`, `SenderID`, `SendingTimeOut`, `DeliveryReport`, `CreatorID`) VALUES
('2015-11-26 10:17:40', '2015-11-26 03:17:40', '2015-11-26 03:17:40', '23:59:59', '00:00:00', NULL, '081320327642', 'Default_No_Compression', NULL, 1, 'Testt\n\n\nSender: @studentbook', 1, 'false', -1, NULL, '2015-11-26 10:17:40', 'default', '');

--
-- Triggers `outbox`
--
DROP TRIGGER IF EXISTS `outbox_timestamp`;
DELIMITER //
CREATE TRIGGER `outbox_timestamp` BEFORE INSERT ON `outbox`
 FOR EACH ROW BEGIN
    IF NEW.InsertIntoDB = '0000-00-00 00:00:00' THEN
        SET NEW.InsertIntoDB = CURRENT_TIMESTAMP();
    END IF;
    IF NEW.SendingDateTime = '0000-00-00 00:00:00' THEN
        SET NEW.SendingDateTime = CURRENT_TIMESTAMP();
    END IF;
    IF NEW.SendingTimeOut = '0000-00-00 00:00:00' THEN
        SET NEW.SendingTimeOut = CURRENT_TIMESTAMP();
    END IF;
END
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `outbox_multipart`
--

CREATE TABLE IF NOT EXISTS `outbox_multipart` (
  `Text` text,
  `Coding` enum('Default_No_Compression','Unicode_No_Compression','8bit','Default_Compression','Unicode_Compression') NOT NULL DEFAULT 'Default_No_Compression',
  `UDH` text,
  `Class` int(11) DEFAULT '-1',
  `TextDecoded` text,
  `ID` int(10) unsigned NOT NULL DEFAULT '0',
  `SequencePosition` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`ID`,`SequencePosition`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `pbk`
--

CREATE TABLE IF NOT EXISTS `pbk` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `GroupID` int(11) NOT NULL DEFAULT '-1',
  `Name` text NOT NULL,
  `Number` text NOT NULL,
  `id_user` int(11) NOT NULL,
  `is_public` enum('true','false') NOT NULL DEFAULT 'false',
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `pbk`
--

INSERT INTO `pbk` (`ID`, `GroupID`, `Name`, `Number`, `id_user`, `is_public`) VALUES
(1, -1, 'asbin', '083867139945', 1, 'true');

-- --------------------------------------------------------

--
-- Table structure for table `pbk_groups`
--

CREATE TABLE IF NOT EXISTS `pbk_groups` (
  `Name` text NOT NULL,
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `id_user` int(11) NOT NULL,
  `is_public` enum('true','false') NOT NULL DEFAULT 'false',
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `pbk_groups`
--

INSERT INTO `pbk_groups` (`Name`, `ID`, `id_user`, `is_public`) VALUES
('sb', 1, 1, 'true');

-- --------------------------------------------------------

--
-- Table structure for table `phones`
--

CREATE TABLE IF NOT EXISTS `phones` (
  `ID` text NOT NULL,
  `UpdatedInDB` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `InsertIntoDB` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `TimeOut` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `Send` enum('yes','no') NOT NULL DEFAULT 'no',
  `Receive` enum('yes','no') NOT NULL DEFAULT 'no',
  `IMEI` varchar(35) NOT NULL,
  `Client` text NOT NULL,
  `Battery` int(11) NOT NULL DEFAULT '-1',
  `Signal` int(11) NOT NULL DEFAULT '-1',
  `Sent` int(11) NOT NULL DEFAULT '0',
  `Received` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`IMEI`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `phones`
--

INSERT INTO `phones` (`ID`, `UpdatedInDB`, `InsertIntoDB`, `TimeOut`, `Send`, `Receive`, `IMEI`, `Client`, `Battery`, `Signal`, `Sent`, `Received`) VALUES
('', '2015-03-08 02:48:34', '2015-03-08 02:45:24', '2015-03-08 02:48:44', 'yes', 'yes', '353805011632796', 'Gammu 1.31.90, Linux, kernel 3.18.7+ (#755 PREEMPT Thu Feb 12 17:14:31 GMT 2015), GCC 4.6', 0, 48, 1, 0),
('', '2015-11-24 23:44:20', '2015-11-23 06:37:30', '2015-11-24 23:44:30', 'yes', 'yes', '012345678901234', 'Gammu 1.31.90, Linux, kernel 4.1.7+ (#817 PREEMPT Sat Sep 19 15:25:36 BST 2015), GCC 4.6', 0, 54, 392, 3);

--
-- Triggers `phones`
--
DROP TRIGGER IF EXISTS `phones_timestamp`;
DELIMITER //
CREATE TRIGGER `phones_timestamp` BEFORE INSERT ON `phones`
 FOR EACH ROW BEGIN
    IF NEW.InsertIntoDB = '0000-00-00 00:00:00' THEN
        SET NEW.InsertIntoDB = CURRENT_TIMESTAMP();
    END IF;
    IF NEW.TimeOut = '0000-00-00 00:00:00' THEN
        SET NEW.TimeOut = CURRENT_TIMESTAMP();
    END IF;
END
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `plugins`
--

CREATE TABLE IF NOT EXISTS `plugins` (
  `plugin_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `plugin_system_name` varchar(255) NOT NULL,
  `plugin_name` varchar(255) NOT NULL,
  `plugin_uri` varchar(120) DEFAULT NULL,
  `plugin_version` varchar(30) NOT NULL,
  `plugin_description` text,
  `plugin_author` varchar(120) DEFAULT NULL,
  `plugin_author_uri` varchar(120) DEFAULT NULL,
  `plugin_data` longtext,
  PRIMARY KEY (`plugin_id`),
  UNIQUE KEY `plugin_index` (`plugin_system_name`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `sentitems`
--

CREATE TABLE IF NOT EXISTS `sentitems` (
  `UpdatedInDB` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `InsertIntoDB` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `SendingDateTime` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `DeliveryDateTime` timestamp NULL DEFAULT NULL,
  `Text` text NOT NULL,
  `DestinationNumber` varchar(20) NOT NULL DEFAULT '',
  `Coding` enum('Default_No_Compression','Unicode_No_Compression','8bit','Default_Compression','Unicode_Compression') NOT NULL DEFAULT 'Default_No_Compression',
  `UDH` text NOT NULL,
  `SMSCNumber` varchar(20) NOT NULL DEFAULT '',
  `Class` int(11) NOT NULL DEFAULT '-1',
  `TextDecoded` text NOT NULL,
  `ID` int(10) unsigned NOT NULL DEFAULT '0',
  `SenderID` varchar(255) NOT NULL,
  `SequencePosition` int(11) NOT NULL DEFAULT '1',
  `Status` enum('SendingOK','SendingOKNoReport','SendingError','DeliveryOK','DeliveryFailed','DeliveryPending','DeliveryUnknown','Error') NOT NULL DEFAULT 'SendingOK',
  `StatusError` int(11) NOT NULL DEFAULT '-1',
  `TPMR` int(11) NOT NULL DEFAULT '-1',
  `RelativeValidity` int(11) NOT NULL DEFAULT '-1',
  `CreatorID` text NOT NULL,
  `id_folder` int(11) NOT NULL DEFAULT '3',
  PRIMARY KEY (`ID`,`SequencePosition`),
  KEY `sentitems_date` (`DeliveryDateTime`),
  KEY `sentitems_tpmr` (`TPMR`),
  KEY `sentitems_dest` (`DestinationNumber`),
  KEY `sentitems_sender` (`SenderID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Triggers `sentitems`
--
DROP TRIGGER IF EXISTS `sentitems_timestamp`;
DELIMITER //
CREATE TRIGGER `sentitems_timestamp` BEFORE INSERT ON `sentitems`
 FOR EACH ROW BEGIN
    IF NEW.InsertIntoDB = '0000-00-00 00:00:00' THEN
        SET NEW.InsertIntoDB = CURRENT_TIMESTAMP();
    END IF;
    IF NEW.SendingDateTime = '0000-00-00 00:00:00' THEN
        SET NEW.SendingDateTime = CURRENT_TIMESTAMP();
    END IF;
END
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `sms_used`
--

CREATE TABLE IF NOT EXISTS `sms_used` (
  `id_sms_used` int(11) NOT NULL AUTO_INCREMENT,
  `sms_date` date NOT NULL,
  `id_user` int(11) NOT NULL,
  `out_sms_count` int(11) NOT NULL DEFAULT '0',
  `in_sms_count` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id_sms_used`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=28 ;

--
-- Dumping data for table `sms_used`
--

INSERT INTO `sms_used` (`id_sms_used`, `sms_date`, `id_user`, `out_sms_count`, `in_sms_count`) VALUES
(1, '2015-03-08', 1, 79, 0),
(2, '2015-03-10', 1, 502, 0),
(3, '2015-03-11', 1, 1811, 0),
(4, '2015-11-01', 1, 248, 4),
(5, '2015-11-02', 1, 402, 4),
(6, '2015-11-03', 1, 159, 4),
(7, '2015-11-04', 1, 1459, 7),
(8, '2015-11-05', 1, 786, 23),
(9, '2015-11-06', 1, 4, 7),
(10, '2015-11-07', 1, 399, 7),
(11, '2015-11-08', 1, 0, 1),
(12, '2015-11-09', 1, 59, 1),
(13, '2015-11-10', 1, 120, 0),
(14, '2015-11-11', 1, 65, 3),
(15, '2015-11-12', 1, 58, 0),
(16, '2015-11-13', 1, 110, 4),
(17, '2015-11-14', 1, 72, 4),
(18, '2015-11-16', 1, 747, 1),
(19, '2015-11-17', 1, 562, 10),
(20, '2015-11-18', 1, 410, 4),
(21, '2015-11-19', 1, 73, 1),
(22, '2015-11-20', 1, 208, 3),
(23, '2015-11-21', 1, 884, 6),
(24, '2015-11-22', 1, 33, 0),
(25, '2015-11-23', 1, 65, 2),
(26, '2015-11-24', 1, 379, 2),
(27, '2015-11-26', 1, 1, 0);

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE IF NOT EXISTS `user` (
  `id_user` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(12) NOT NULL,
  `realname` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `phone_number` varchar(15) NOT NULL,
  `level` enum('admin','user') NOT NULL DEFAULT 'user',
  PRIMARY KEY (`id_user`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `phone_number` (`phone_number`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id_user`, `username`, `realname`, `password`, `phone_number`, `level`) VALUES
(1, 'studentbook', 'STUDENTBOOK', 'aca9ba52255174155a09be92ec6760bac7efe3a9', '083867139945', 'admin');

-- --------------------------------------------------------

--
-- Table structure for table `user_filters`
--

CREATE TABLE IF NOT EXISTS `user_filters` (
  `id_filter` int(11) NOT NULL AUTO_INCREMENT,
  `id_user` int(11) NOT NULL,
  `from` varchar(15) NOT NULL,
  `has_the_words` varchar(50) NOT NULL,
  `id_folder` int(11) NOT NULL,
  PRIMARY KEY (`id_filter`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `user_folders`
--

CREATE TABLE IF NOT EXISTS `user_folders` (
  `id_folder` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `id_user` int(11) NOT NULL,
  PRIMARY KEY (`id_folder`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=11 ;

--
-- Dumping data for table `user_folders`
--

INSERT INTO `user_folders` (`id_folder`, `name`, `id_user`) VALUES
(1, 'inbox', 0),
(2, 'outbox', 0),
(3, 'sent_items', 0),
(4, 'draft', 0),
(5, 'Trash', 0),
(6, 'Spam', 0);

-- --------------------------------------------------------

--
-- Table structure for table `user_forgot_password`
--

CREATE TABLE IF NOT EXISTS `user_forgot_password` (
  `id_user` int(11) NOT NULL,
  `token` varchar(255) NOT NULL,
  `valid_until` datetime NOT NULL,
  PRIMARY KEY (`id_user`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `user_group`
--

CREATE TABLE IF NOT EXISTS `user_group` (
  `id_group` int(11) NOT NULL AUTO_INCREMENT,
  `id_pbk` int(11) NOT NULL,
  `id_pbk_groups` int(11) NOT NULL,
  `id_user` int(11) NOT NULL,
  PRIMARY KEY (`id_group`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `user_group`
--

INSERT INTO `user_group` (`id_group`, `id_pbk`, `id_pbk_groups`, `id_user`) VALUES
(1, 1, 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `user_inbox`
--

CREATE TABLE IF NOT EXISTS `user_inbox` (
  `id_inbox` int(11) NOT NULL,
  `id_user` int(11) NOT NULL,
  `trash` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id_inbox`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `user_outbox`
--

CREATE TABLE IF NOT EXISTS `user_outbox` (
  `id_outbox` int(11) NOT NULL,
  `id_user` int(11) NOT NULL,
  PRIMARY KEY (`id_outbox`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `user_outbox`
--

INSERT INTO `user_outbox` (`id_outbox`, `id_user`) VALUES
(1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `user_sentitems`
--

CREATE TABLE IF NOT EXISTS `user_sentitems` (
  `id_sentitems` int(11) NOT NULL,
  `id_user` int(11) NOT NULL,
  `trash` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id_sentitems`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `user_settings`
--

CREATE TABLE IF NOT EXISTS `user_settings` (
  `id_user` int(11) NOT NULL,
  `theme` varchar(10) NOT NULL DEFAULT 'blue',
  `signature` varchar(50) NOT NULL,
  `permanent_delete` enum('true','false') NOT NULL DEFAULT 'false',
  `paging` int(2) NOT NULL DEFAULT '10',
  `bg_image` varchar(50) NOT NULL,
  `delivery_report` enum('default','yes','no') NOT NULL DEFAULT 'default',
  `language` varchar(20) NOT NULL DEFAULT 'english',
  `conversation_sort` enum('asc','desc') NOT NULL DEFAULT 'asc',
  `country_code` varchar(2) NOT NULL DEFAULT 'US',
  PRIMARY KEY (`id_user`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `user_settings`
--

INSERT INTO `user_settings` (`id_user`, `theme`, `signature`, `permanent_delete`, `paging`, `bg_image`, `delivery_report`, `language`, `conversation_sort`, `country_code`) VALUES
(1, 'green', 'true;', 'false', 20, 'true;background.jpg', 'default', 'indonesian', 'asc', 'ID');

-- --------------------------------------------------------

--
-- Table structure for table `user_templates`
--

CREATE TABLE IF NOT EXISTS `user_templates` (
  `id_template` int(11) NOT NULL AUTO_INCREMENT,
  `id_user` int(11) NOT NULL,
  `Name` varchar(64) NOT NULL,
  `Message` text NOT NULL,
  PRIMARY KEY (`id_template`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `user_templates`
--

INSERT INTO `user_templates` (`id_template`, `id_user`, `Name`, `Message`) VALUES
(1, 1, 'coba', 'coba\n\n');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
