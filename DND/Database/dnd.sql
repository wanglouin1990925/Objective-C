-- phpMyAdmin SQL Dump
-- version 4.0.4.1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Dec 22, 2014 at 05:42 PM
-- Server version: 5.6.12
-- PHP Version: 5.5.3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `dnd`
--
CREATE DATABASE IF NOT EXISTS `dnd` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `dnd`;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_comment`
--

CREATE TABLE IF NOT EXISTS `tbl_comment` (
  `cmt_id` int(11) NOT NULL AUTO_INCREMENT,
  `cmt_useridfrom` int(11) NOT NULL,
  `cmt_description` text NOT NULL,
  `cmt_date` datetime NOT NULL,
  `cmt_rateid` int(11) NOT NULL,
  PRIMARY KEY (`cmt_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=8 ;

--
-- Dumping data for table `tbl_comment`
--

INSERT INTO `tbl_comment` (`cmt_id`, `cmt_useridfrom`, `cmt_description`, `cmt_date`, `cmt_rateid`) VALUES
(1, 1, 'http://www.google.com', '2014-11-13 04:12:38', 6),
(2, 1, 'http://www', '2014-11-13 04:13:20', 6),
(3, 4, 'asdfasdfasdf', '2014-12-03 21:39:11', 14),
(4, 4, 'asdfasdf', '2014-12-03 21:46:53', 14),
(5, 4, 'hhhhh', '2014-12-03 21:48:18', 14),
(6, 4, 'asdf', '2014-12-03 21:51:13', 14),
(7, 4, 'asfaf', '2014-12-03 22:07:36', 14);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_notification`
--

CREATE TABLE IF NOT EXISTS `tbl_notification` (
  `not_id` int(11) NOT NULL AUTO_INCREMENT,
  `not_userid` int(11) NOT NULL,
  `not_rateid` int(11) NOT NULL,
  `not_content` text NOT NULL,
  `not_date` datetime NOT NULL,
  `not_userfbid` bigint(11) NOT NULL,
  PRIMARY KEY (`not_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=29 ;

--
-- Dumping data for table `tbl_notification`
--

INSERT INTO `tbl_notification` (`not_id`, `not_userid`, `not_rateid`, `not_content`, `not_date`, `not_userfbid`) VALUES
(6, 0, 0, 'You have been rated a 8 stars', '2014-11-13 03:35:24', 100003775919014),
(7, 0, 6, 'You have new review', '2014-11-13 04:12:38', 100003775919014),
(8, 0, 6, 'You have new review', '2014-11-13 04:13:20', 100003775919014),
(9, 0, 0, 'You have been rated a 10 stars', '2014-11-13 04:15:58', 100003775919014),
(10, 0, 0, 'You have been rated a 8.8 stars', '2014-11-13 12:00:20', 1509015),
(11, 0, 0, 'You have been rated a 10 stars', '2014-11-13 14:55:23', 100004465176649),
(12, 0, 0, 'You have been rated a 6.2 stars', '2014-11-13 14:57:39', 100005262379539),
(13, 0, 0, 'You have been rated a 8 stars', '2014-11-13 15:37:19', 100003775919014),
(14, 0, 0, 'You have been rated a 10 stars', '2014-11-13 15:38:00', 100003775919014),
(15, 0, 0, 'You have been rated a 10 stars', '2014-11-16 14:30:35', 100005262379539),
(16, 0, 0, 'You have been rated a 8 stars', '2014-11-17 04:42:12', 1509015),
(17, 0, 0, 'You have been rated a 10 stars', '2014-11-17 04:42:33', 3702790),
(18, 0, 0, 'You have been rated a 10 stars', '2014-11-17 09:57:28', 6822176),
(19, 0, 14, 'You have new review', '2014-12-03 21:39:11', 100003775919014),
(20, 0, 14, 'You have new review', '2014-12-03 21:46:53', 100003775919014),
(21, 0, 14, 'You have new review', '2014-12-03 21:48:18', 100003775919014),
(22, 0, 14, 'You have new review', '2014-12-03 21:51:13', 100003775919014),
(23, 0, 14, 'You have new review', '2014-12-03 22:07:36', 100003775919014),
(24, 0, 0, 'You have been rated a 6.4 stars', '2014-12-03 22:08:13', 100003775919014),
(25, 0, 0, 'You have been rated a 6 stars', '2014-12-09 20:09:11', 6822176),
(26, 0, 0, 'You have been rated a 5.8 stars', '2014-12-09 20:12:45', 6822176),
(27, 0, 0, 'You have been rated a 10 stars', '2014-12-09 21:24:54', 6854784),
(28, 0, 0, 'You have been rated a 10 stars', '2014-12-09 21:49:19', 100007540273254);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_photo`
--

CREATE TABLE IF NOT EXISTS `tbl_photo` (
  `pot_id` int(11) NOT NULL,
  `pot_userid` int(11) NOT NULL,
  `pot_url` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_rate`
--

CREATE TABLE IF NOT EXISTS `tbl_rate` (
  `rat_id` bigint(11) NOT NULL AUTO_INCREMENT,
  `rat_useridfrom` bigint(20) NOT NULL,
  `rat_userfbidto` bigint(20) NOT NULL,
  `rat_score` float NOT NULL,
  `rat_date` datetime NOT NULL,
  `rat_comment` text NOT NULL,
  `rat_upvotes` int(11) NOT NULL,
  `rat_downvotes` int(11) NOT NULL,
  `rat_nickname` text NOT NULL,
  PRIMARY KEY (`rat_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=24 ;

--
-- Dumping data for table `tbl_rate`
--

INSERT INTO `tbl_rate` (`rat_id`, `rat_useridfrom`, `rat_userfbidto`, `rat_score`, `rat_date`, `rat_comment`, `rat_upvotes`, `rat_downvotes`, `rat_nickname`) VALUES
(7, 1, 100003775919014, 5, '2014-11-13 04:15:58', 'asfasdfasdfasdfas', 0, 0, 'Friend'),
(9, 4, 1509015, 5, '2014-11-13 14:46:01', 'testtestestset', 0, 0, 'Boyfriend'),
(10, 4, 3702790, 3.7, '2014-11-13 14:47:05', 'asfdasdfasdfasdfasdfasfasdf', 0, 0, 'Ex-Boyfriend'),
(11, 4, 100004465176649, 5, '2014-11-13 14:55:23', 'asdfasdfasdf', 2, 0, 'Friend'),
(12, 4, 100005262379539, 3.1, '2014-11-13 14:57:39', 'asdfasdfasdfasdf', 1, 1, 'Girlfriend'),
(15, 1, 100005262379539, 5, '2014-11-16 14:30:35', 'Hello asdfsadfsdfsdaf', 2, 0, 'Girlfriend'),
(16, 1, 1509015, 4, '2014-11-17 04:42:12', 'Asdfsadfsdafsadfsdfsadfsadfsdfsadfsdafsadfsadfsdafsdafsdafasdfsdafsadfsdafdsafsadfsdafsadf', 1, 0, 'Boyfriend'),
(17, 1, 3702790, 5, '2014-11-17 04:42:33', 'adsfsdzxcvzxcvadsfxzcvasdfxzcvxzvadsfdsafsdafxzcvzxcvsdafsadfsadf', 0, 0, 'Ex-Girlfriend'),
(18, 4, 6822176, 5, '2014-11-17 09:57:28', 'Testing', 0, 0, 'Boyfriend'),
(19, 4, 100003775919014, 3.2, '2014-12-03 22:08:13', 'asdfasdfasdfadsfasdfasdfsadfdsaf', 0, 0, 'Ex-Girlfriend'),
(20, 1, 6822176, 3, '2014-12-09 20:09:11', 'asdfasfsadfsadfsadfsadf', 0, 0, 'Ex-Boyfriend'),
(21, 3, 6822176, 2.9, '2014-12-09 20:12:45', 'asdfsadfasdfasdfasdfasdf', 0, 0, 'Girlfriend'),
(22, 4, 6854784, 5, '2014-12-09 21:24:54', 'Nice pic!!! I would like this guys', 0, 0, 'Boyfriend'),
(23, 1, 100007540273254, 5, '2014-12-09 21:49:19', 'Good guy!!!', 0, 0, 'Boyfriend');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_user`
--

CREATE TABLE IF NOT EXISTS `tbl_user` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_facebookid` bigint(50) NOT NULL,
  `user_firstname` text NOT NULL,
  `user_lastname` text NOT NULL,
  `user_gender` text NOT NULL,
  `user_age` int(11) NOT NULL,
  `user_latitude` float NOT NULL,
  `user_longitude` float NOT NULL,
  `user_photo1` text NOT NULL,
  `user_photo2` text NOT NULL,
  `user_photo3` text NOT NULL,
  `user_photo4` text NOT NULL,
  `user_photo5` text NOT NULL,
  `user_photo6` text NOT NULL,
  `user_photo7` text NOT NULL,
  `user_photo8` text NOT NULL,
  `user_photo9` text NOT NULL,
  `user_photo10` text NOT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=10 ;

--
-- Dumping data for table `tbl_user`
--

INSERT INTO `tbl_user` (`user_id`, `user_facebookid`, `user_firstname`, `user_lastname`, `user_gender`, `user_age`, `user_latitude`, `user_longitude`, `user_photo1`, `user_photo2`, `user_photo3`, `user_photo4`, `user_photo5`, `user_photo6`, `user_photo7`, `user_photo8`, `user_photo9`, `user_photo10`) VALUES
(1, 100004465176649, 'Yang', 'Xiaomin', 'female', 23, 40.1167, 124.383, 'https://fbcdn-sphotos-d-a.akamaihd.net/hphotos-ak-xpa1/v/t1.0-9/10311228_366162366875933_1031949552494069609_n.jpg?oh=d3b74047cffe5064c03683537f670dfd&oe=54E1E93E&__gda__=1424566662_6f882a14667a683afe88426945ea6620', 'https://scontent-b.xx.fbcdn.net/hphotos-xap1/v/t1.0-9/10301365_366161656876004_7949854552752865004_n.jpg?oh=15c0987319cc1d58ebbcb65be69808fd&oe=54E614E6', 'https://scontent-a.xx.fbcdn.net/hphotos-xpa1/v/t1.0-9/10676188_366161586876011_6514499160423425878_n.jpg?oh=4f32db8dc651502ed4207341c243de7c&oe=54D920C4', 'https://scontent-a.xx.fbcdn.net/hphotos-xpf1/v/t1.0-9/1234865_366161543542682_7804375638197967001_n.jpg?oh=71c27e91700b49bee1bcc21c1855c500&oe=54D8AA80', 'https://scontent-a.xx.fbcdn.net/hphotos-xpa1/v/l/t1.0-9/10409178_366161493542687_2736405158307974364_n.jpg?oh=7884af20ad18e3639489c014d4633941&oe=54E7AB37', 'https://scontent-a.xx.fbcdn.net/hphotos-xfa1/v/t1.0-9/10365876_366161436876026_1160139999559168485_n.jpg?oh=6c2131176e8e6771c15809a001ab8bac&oe=54EF3ABF', 'https://fbcdn-sphotos-f-a.akamaihd.net/hphotos-ak-xfa1/v/t1.0-9/1379760_366161390209364_8150704961521815937_n.jpg?oh=d5780d8ebe8232be1c02b7f029c418ef&oe=54AA1634&__gda__=1424866660_21b30b121e9f54c74e39de1a3c836a0c', 'https://scontent-b.xx.fbcdn.net/hphotos-xap1/v/t1.0-9/1236104_366161323542704_7506414774628313625_n.jpg?oh=a472dda3f235b26ab5e97a2e7b2fed25&oe=54E2BAFD', 'https://fbcdn-sphotos-b-a.akamaihd.net/hphotos-ak-xpf1/v/t1.0-9/10625105_366161216876048_7734103046819384129_n.jpg?oh=f6b3425ebc5a478736a09068b68e2e36&oe=54EF5F2B&__gda__=1425167169_f4208e5955d3a73c1665a3b3f70108c3', 'https://scontent-b.xx.fbcdn.net/hphotos-xpa1/v/t1.0-9/10734041_366156160209887_6185884541936983408_n.jpg?oh=e4d3b07ca91203097dcb6bebc16e07b5&oe=54F4B245'),
(2, 100007540273254, 'Wang', 'Chao', 'male', 22, 40.1167, 120.383, 'https://scontent-a.xx.fbcdn.net/hphotos-xpa1/v/t1.0-9/15095_1384762511785078_169349987_n.jpg?oh=1138caa70c3e90f2a4188f11bdca8a46&oe=54E3BA78', '', '', '', '', '', '', '', '', ''),
(3, 100003775919014, 'Jinbu', 'Cui', 'male', 28, 40.1167, 123.383, 'https://fbcdn-sphotos-f-a.akamaihd.net/hphotos-ak-xfa1/v/t1.0-9/1975041_434509736684886_6047037049682250092_n.jpg?oh=7d347c1b9af53c958c5c183ea627872f&oe=54EF959F&__gda__=1423300559_5d9669ab959ac3834024ede1743109f7', 'https://fbcdn-sphotos-c-a.akamaihd.net/hphotos-ak-xfp1/v/t1.0-9/960105_195018010654698_1922805832_n.jpg?oh=5eb38a017333096485cdfaa3384100f1&oe=54DA0728&__gda__=1424463561_bed3b64ce1fb91352d4140433be36b90', 'https://fbcdn-sphotos-a-a.akamaihd.net/hphotos-ak-frc3/t31.0-8/856527_348595735276287_1040622730_o.jpg', 'https://scontent-a.xx.fbcdn.net/hphotos-xpa1/l/t31.0-8/10520694_476397915829401_1547225399410556758_o.jpg', 'https://scontent-a.xx.fbcdn.net/hphotos-xaf1/v/t1.0-9/10257376_464503573685502_1293089123477555784_n.jpg?oh=16be11194f2628ffa89f87df1d21cf1c&oe=54F5BBD1', 'https://scontent-a.xx.fbcdn.net/hphotos-xpa1/v/t1.0-9/10455996_464503227018870_2262113053872928613_n.jpg?oh=5a7918fad00adf5d7aa47ec59708e1c8&oe=54E67500', 'https://fbcdn-sphotos-e-a.akamaihd.net/hphotos-ak-xpa1/v/t1.0-9/1526320_464503203685539_5710877317015901238_n.jpg?oh=f2e6baa48a9cf07e4f5e510e942c05bf&oe=54E108F6&__gda__=1424448715_df7ff1a59ca31187c6192646a0b50361', 'https://scontent-b.xx.fbcdn.net/hphotos-xap1/v/t1.0-9/10353173_464503133685546_8288549472547966638_n.jpg?oh=3adb832b1b4c0385a9be1f1955447100&oe=54D4410C', 'https://fbcdn-sphotos-f-a.akamaihd.net/hphotos-ak-xfa1/v/t1.0-9/1975041_434509736684886_6047037049682250092_n.jpg?oh=7d347c1b9af53c958c5c183ea627872f&oe=54EF959F&__gda__=1423300559_5d9669ab959ac3834024ede1743109f7', 'https://fbcdn-sphotos-h-a.akamaihd.net/hphotos-ak-xfa1/t31.0-8/1795837_417348665067660_2127334756_o.jpg'),
(4, 10153644153842524, 'Kpaul', 'Multani', 'male', 22, 37.3323, 37.3323, 'https://scontent-b.xx.fbcdn.net/hphotos-xfa1/v/t1.0-9/1450261_10152772585649526_7297172799236024026_n.jpg?oh=20e8425c68665c8e100524e56ea180ce&oe=54E5EBCD', 'https://fbcdn-sphotos-c-a.akamaihd.net/hphotos-ak-xap1/v/t1.0-9/10676176_10152772585074526_1158110623257436870_n.jpg?oh=cb0b01b342b49c79e8c805dfcaf6c53c&oe=54DC51CF&__gda__=1423410842_c9c49046b28dc60464d054bdbfa1dda3', 'https://fbcdn-sphotos-f-a.akamaihd.net/hphotos-ak-xfp1/t31.0-8/10714269_10152756100344526_217598069931378565_o.jpg', 'https://scontent-a.xx.fbcdn.net/hphotos-xpa1/v/t1.0-9/10469772_10152756063784526_141482206658675298_n.jpg?oh=eb3da93fc754b2993b56fcb6cdfe9e30&oe=551ACC01', 'https://fbcdn-sphotos-a-a.akamaihd.net/hphotos-ak-xpa1/v/t1.0-9/154500_10152756061174526_8038335798594229062_n.jpg?oh=1db68d7cd08847d14239c95faf3b1fab&oe=54D48A51&__gda__=1424869097_f7a92d459b12e1b7c688e1dfd5aac71d', 'https://fbcdn-sphotos-d-a.akamaihd.net/hphotos-ak-xfp1/v/t1.0-9/10629567_10152756059454526_6852062157500258666_n.jpg?oh=31c69e26b31140ef965f9b8a77a78b8e&oe=54E4F100&__gda__=1424256357_3dd57514ae887e0ff4c25ff32261a9ad', 'https://fbcdn-sphotos-f-a.akamaihd.net/hphotos-ak-xpa1/v/t1.0-9/10384363_10152756059239526_6134889586633054046_n.jpg?oh=8b1e3c735a9e644793c0b79b7b22b031&oe=551D1CCF&__gda__=1424956377_c922bd4cff91ab27a0d118575b006635', 'https://fbcdn-sphotos-a-a.akamaihd.net/hphotos-ak-xpf1/t31.0-8/10733726_10152762249161327_7160905380647520824_o.jpg', 'https://scontent-b.xx.fbcdn.net/hphotos-ash3/v/t1.0-9/10409714_10152726934604526_1954688557879068710_n.jpg?oh=ed82f51fe2bc577d32489d328bb8ad34&oe=54DE44E5', 'https://scontent-a.xx.fbcdn.net/hphotos-xfp1/v/t1.0-9/10301354_10152687909724526_2648031415011081310_n.jpg?oh=538013c7ff2fc5e171db7c93a90ff5e0&oe=54DC35F7'),
(5, 100005262379539, 'Bai', 'Min', 'male', 22, 37.3323, 37.3323, 'https://scontent-a.xx.fbcdn.net/hphotos-xfa1/v/t1.0-9/1798866_314063002112443_4318307902421823298_n.jpg?oh=ea009eb5bff26ba05b7fbddcb650943b&oe=54D27D50', '', '', '', '', '', '', '', '', ''),
(6, 1509015, 'Matthew', 'Brennan', 'male', 0, 0, 0, 'http://graph.facebook.com/1509015/picture?type=large', '', '', '', '', '', '', '', '', ''),
(7, 3702790, 'Ari', 'Stillman', 'male', 0, 0, 0, 'https://scontent-a.xx.fbcdn.net/hphotos-xpa1/l/t31.0-8/1913279_10100286504788938_6988477990235635607_o.jpg', 'https://fbcdn-sphotos-e-a.akamaihd.net/hphotos-ak-xpa1/t31.0-8/10257116_10100277589545158_1649988799524508950_o.jpg', 'https://scontent-a.xx.fbcdn.net/hphotos-xpf1/t31.0-8/10550055_10100248368354658_2634659921798142654_o.jpg', 'https://scontent-a.xx.fbcdn.net/hphotos-xpa1/v/t1.0-9/1959804_10100231479869318_3607593698018914396_n.jpg?oh=51d42059c73eec1ee3b80df3e63e24f1&oe=54E5F927', 'https://scontent-b.xx.fbcdn.net/hphotos-xaf1/v/t1.0-9/10527338_10100213189942478_2639869553815227641_n.jpg?oh=19eca5c32e7c1115f75d9a87805c5a0e&oe=551B3D27', 'https://scontent-b.xx.fbcdn.net/hphotos-xpf1/v/t1.0-9/10306253_10100198053600828_709114715539519301_n.jpg?oh=616848d8aef76caf93c6d7c7e3d21a9a&oe=54E03C02', 'https://scontent-b.xx.fbcdn.net/hphotos-xfp1/v/t1.0-9/10313324_10100186187969648_7504539807460589577_n.jpg?oh=aeeb7797ffa20ba53ed29c48d8446895&oe=54D5F67C', 'https://scontent-a.xx.fbcdn.net/hphotos-xfa1/v/t1.0-9/1607076_10100170010120188_6278482940765412393_n.jpg?oh=9e67046c7d9f8647f8cf2b606c5e4150&oe=551A4466', 'https://fbcdn-sphotos-c-a.akamaihd.net/hphotos-ak-xfa1/t31.0-8/1973497_10100152534172128_127745241_o.jpg', 'https://fbcdn-sphotos-g-a.akamaihd.net/hphotos-ak-xfp1/t31.0-8/1493378_10100120439021068_875403202_o.jpg'),
(8, 6822176, 'Terrance', 'Dennie', 'male', 29, 0, 0, 'https://scontent-a.xx.fbcdn.net/hphotos-xfa1/v/t1.0-9/10734158_10104823620807099_9117096779274722054_n.jpg?oh=d0c617bf10415b07938d9f1e56046ff2&oe=54D2E7B1', 'https://fbcdn-sphotos-h-a.akamaihd.net/hphotos-ak-xfp1/t31.0-8/10557631_10104409531914559_8259469012370913792_o.jpg', 'https://fbcdn-sphotos-g-a.akamaihd.net/hphotos-ak-xfa1/v/t1.0-9/10527446_10104380028943749_1213912343338277542_n.jpg?oh=57c2aedfaae2daf4c9269603cdf8e3e2&oe=54E1BFE1&__gda__=1424418572_91d1fffe7f0609a7305bdcf79c43a081', 'https://fbcdn-sphotos-b-a.akamaihd.net/hphotos-ak-xap1/t31.0-8/10477560_10104339903799859_5772219790355637991_o.jpg', 'https://scontent-b.xx.fbcdn.net/hphotos-xap1/v/t1.0-9/10343505_10104274722329049_5105052746701371418_n.jpg?oh=b12331e53ed160dd215b1db76b560f9f&oe=5518344C', 'https://fbcdn-sphotos-c-a.akamaihd.net/hphotos-ak-xfa1/v/t1.0-9/10414419_10104274717438849_1457021848087501859_n.jpg?oh=9e7c9eca6f6b3f551948ad0bac346964&oe=5518D6CD&__gda__=1427656480_54ff58ffd44648fc73f525a29030f115', 'https://fbcdn-sphotos-d-a.akamaihd.net/hphotos-ak-xfp1/v/t1.0-9/1374809_10104141131610919_1628197282929476555_n.jpg?oh=94f84548ba19683a8ed7d02c8015ba54&oe=54E1520D&__gda__=1424320349_b2b395d6d22aa81d3dffcd33f3afc746', 'https://scontent-a.xx.fbcdn.net/hphotos-xpa1/t31.0-8/1932751_10103824770685749_2141334388_o.jpg', 'https://fbcdn-sphotos-c-a.akamaihd.net/hphotos-ak-xap1/t31.0-8/1015855_10103824767796539_1484959795_o.jpg', 'https://fbcdn-sphotos-b-a.akamaihd.net/hphotos-ak-xap1/t31.0-8/1890492_10103824764268609_1220597776_o.jpg'),
(9, 6854784, 'Ronak', 'Desai', 'male', 26, 0, 0, 'https://fbcdn-sphotos-b-a.akamaihd.net/hphotos-ak-xap1/v/t1.0-9/10599686_10104980366242989_4168031371317327324_n.jpg?oh=df68fd94f900e2aba94681e02cae39fc&oe=5516F7C1&__gda__=1430589076_bdfa66c88e94084bd07b2e683d9137fa', 'https://scontent-a.xx.fbcdn.net/hphotos-xpf1/v/t1.0-9/10644862_10104878758515689_904709819551686690_n.jpg?oh=4f53c351b29943a7dd278671eca841f7&oe=54FF7F0B', 'https://scontent-b.xx.fbcdn.net/hphotos-xfp1/v/t1.0-9/10687174_10104655582122969_1716106898294500356_n.jpg?oh=12ed12693fa686da60c77cd96c38f993&oe=54FC0241', 'https://fbcdn-sphotos-b-a.akamaihd.net/hphotos-ak-xaf1/t31.0-8/1278041_10104020156580849_2315504390933869259_o.jpg', 'https://scontent-b.xx.fbcdn.net/hphotos-xpa1/v/t1.0-9/1535722_10103692597596679_1595754185_n.jpg?oh=1711da7ee339869ba5ea692a47f00e82&oe=5501DD1F', 'https://scontent-b.xx.fbcdn.net/hphotos-xpf1/v/t1.0-9/1545215_10103692597257359_1378384535_n.jpg?oh=57bf7084fc0c34d35cc9b5e9fd4d9c9e&oe=5513D018', 'https://scontent-a.xx.fbcdn.net/hphotos-xap1/v/t1.0-9/1240357_10103281819609059_1981563467_n.jpg?oh=d13ff697ad615a547dac4a7cde25ef60&oe=550123D5', 'https://scontent-a.xx.fbcdn.net/hphotos-xfp1/t31.0-8/857557_10102527029599289_550266966_o.jpg', 'https://fbcdn-sphotos-b-a.akamaihd.net/hphotos-ak-xfa1/t31.0-8/468102_10102296600241569_1100923316_o.jpg', 'https://fbcdn-sphotos-h-a.akamaihd.net/hphotos-ak-frc3/v/t1.0-9/559364_10102187283328539_1957776270_n.jpg?oh=096c94f0c758f1db8423e52283a490cd&oe=55036DC0&__gda__=1425651853_fc9d7384162048e18884d74d71cdc7ca');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_vote`
--

CREATE TABLE IF NOT EXISTS `tbl_vote` (
  `vot_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `vot_useridfrom` bigint(20) NOT NULL,
  `vot_rateid` int(11) NOT NULL,
  PRIMARY KEY (`vot_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=9 ;

--
-- Dumping data for table `tbl_vote`
--

INSERT INTO `tbl_vote` (`vot_id`, `vot_useridfrom`, `vot_rateid`) VALUES
(1, 1, 15),
(2, 1, 12),
(3, 1, 11),
(4, 4, 16),
(5, 4, 11),
(6, 4, 15),
(7, 4, 12),
(8, 4, 14);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
