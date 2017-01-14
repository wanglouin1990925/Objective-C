-- phpMyAdmin SQL Dump
-- version 4.0.8
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Jun 06, 2014 at 04:14 AM
-- Server version: 5.1.67-rel14.3-log
-- PHP Version: 5.3.17

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `three0da_apidb`
--

-- --------------------------------------------------------

--
-- Table structure for table `tbl_comment`
--

CREATE TABLE IF NOT EXISTS `tbl_comment` (
  `index` int(11) NOT NULL AUTO_INCREMENT,
  `postid` varchar(30) NOT NULL,
  `userid` varchar(30) NOT NULL,
  `comment` text NOT NULL,
  `date` datetime NOT NULL,
  PRIMARY KEY (`index`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=12 ;

--
-- Dumping data for table `tbl_comment`
--

INSERT INTO `tbl_comment` (`index`, `postid`, `userid`, `comment`, `date`) VALUES
(1, '2', '8', 'video is looping', '2014-03-04 17:40:46'),
(2, '7', '14', 'Not very exciting yet, I know !', '2014-03-09 23:29:07'),
(3, '8', '16', 'nice', '2014-03-18 13:46:26'),
(4, '8', '16', 'awesome', '2014-03-18 13:46:33'),
(5, '8', '16', '', '2014-03-18 13:46:38'),
(6, '8', '16', 'ccf', '2014-03-18 13:47:27'),
(7, '8', '16', '', '2014-03-18 13:47:27'),
(8, '8', '16', 'cvg', '2014-03-18 13:47:30'),
(9, '5', '16', 't', '2014-03-21 06:48:28'),
(10, '5', '16', 't', '2014-03-21 06:48:29'),
(11, '5', '16', 'q', '2014-03-21 06:48:32');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_follow`
--

CREATE TABLE IF NOT EXISTS `tbl_follow` (
  `index` int(11) NOT NULL AUTO_INCREMENT,
  `useridfrom` varchar(30) NOT NULL,
  `useridto` varchar(30) NOT NULL,
  `date` datetime NOT NULL,
  PRIMARY KEY (`index`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=6 ;

--
-- Dumping data for table `tbl_follow`
--

INSERT INTO `tbl_follow` (`index`, `useridfrom`, `useridto`, `date`) VALUES
(2, '3', '1', '2014-02-05 13:14:14'),
(5, '16', '1', '2014-03-18 13:44:59');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_like`
--

CREATE TABLE IF NOT EXISTS `tbl_like` (
  `index` int(11) NOT NULL AUTO_INCREMENT,
  `postid` varchar(30) NOT NULL,
  `userid` varchar(30) NOT NULL,
  `date` datetime NOT NULL,
  `useridto` varchar(30) NOT NULL,
  PRIMARY KEY (`index`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=12 ;

--
-- Dumping data for table `tbl_like`
--

INSERT INTO `tbl_like` (`index`, `postid`, `userid`, `date`, `useridto`) VALUES
(1, '2', '8', '2014-03-04 17:41:03', '3'),
(2, '6', '11', '2014-03-07 02:18:42', '11'),
(4, '7', '14', '2014-03-09 23:27:59', '14'),
(7, '8', '16', '2014-03-18 13:47:40', '14'),
(11, '5', '16', '2014-03-21 06:48:22', '8');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_post`
--

CREATE TABLE IF NOT EXISTS `tbl_post` (
  `index` int(11) NOT NULL AUTO_INCREMENT,
  `projectid` varchar(30) NOT NULL,
  `videourl` text NOT NULL,
  `date` varchar(10) NOT NULL,
  `daynumber` varchar(10) NOT NULL,
  PRIMARY KEY (`index`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=12 ;

--
-- Dumping data for table `tbl_post`
--

INSERT INTO `tbl_post` (`index`, `projectid`, `videourl`, `date`, `daynumber`) VALUES
(2, '2', 'upload/video/video_2_1.mp4', '2014-02-05', '1'),
(3, '3', 'upload/video/video_3_1.mp4', '2014-02-07', '1'),
(4, '4', 'upload/video/video_4_1.mp4', '2014-03-04', '1'),
(5, '5', 'upload/video/video_5_1.mp4', '2014-03-04', '1'),
(6, '6', 'upload/video/video_6_1.mp4', '2014-03-07', '1'),
(7, '8', 'upload/video/video_8_1.mp4', '2014-03-10', '1'),
(8, '8', 'upload/video/video_8_2.mp4', '2014-03-12', '2'),
(9, '8', 'upload/video/video_8_3.mp4', '2014-03-17', '3'),
(11, '9', 'upload/video/video_9_1.mp4', '2014-04-03', '1');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_project`
--

CREATE TABLE IF NOT EXISTS `tbl_project` (
  `index` int(11) NOT NULL AUTO_INCREMENT,
  `userid` varchar(30) NOT NULL,
  `title` text NOT NULL,
  `category` varchar(30) NOT NULL,
  PRIMARY KEY (`index`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=13 ;

--
-- Dumping data for table `tbl_project`
--

INSERT INTO `tbl_project` (`index`, `userid`, `title`, `category`) VALUES
(1, '1', 'making 30days', 'others'),
(2, '3', 'on my first project', 'others'),
(3, '1', 'testing', 'music'),
(4, '8', 'redesigning the front yard ', 'art and design'),
(5, '8', 'designing a 30 minute Bootcamp program', 'others'),
(6, '11', 'trying to get the best of me in ene', 'others'),
(7, '12', 'still deciding what to do', 'fitness'),
(8, '14', 'writing a short story', 'choose category'),
(9, '16', 'still deciding what to do', 'others'),
(12, '16', 'still deciding what to do', 'choose category');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_user`
--

CREATE TABLE IF NOT EXISTS `tbl_user` (
  `index` int(11) NOT NULL AUTO_INCREMENT,
  `user_username` varchar(30) NOT NULL,
  `user_password` varchar(30) NOT NULL,
  `user_avatar` text NOT NULL,
  `user_location` varchar(30) NOT NULL,
  `user_bio` varchar(2000) NOT NULL,
  `user_email` varchar(30) NOT NULL,
  PRIMARY KEY (`index`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=22 ;

--
-- Dumping data for table `tbl_user`
--

INSERT INTO `tbl_user` (`index`, `user_username`, `user_password`, `user_avatar`, `user_location`, `user_bio`, `user_email`) VALUES
(1, 'wangchao', '1', 'upload/avatar_1_2014-02-05-02-45-27.jpg', 'Dandong', 'Im ios Dev from china.\nIm making 30days.', 'wangchao90925@hotmail.com'),
(2, 'test', '111111', 'upload/avatar_2_2014-02-05-02-56-24.jpg', '', '', ''),
(3, 'michelle', 'MB150500', 'upload/avatar_3_2014-02-05-13-10-55.jpg', 'berkeley', 'It is me again', 'christianbaudry@gmail.com'),
(4, 'JGodault', 'JG241500', 'upload/avatar_4_2014-02-08-16-21-59.jpg', '', '', 'jgodault@gmail.com'),
(5, 'sixventures', 'SV241500', 'upload/avatar_5_2014-02-20-18-26-46.jpg', '', '', 'sixventures@gmail.com'),
(6, 'testtest', '123456', 'upload/avatar_6_2014-02-21-12-15-46.jpg', '', '', 'test@gmail.com'),
(7, 'WarriorPigs', '30daysBoyboypig100', 'upload/avatar_7_2014-03-04-02-13-05.jpg', 'Australia', 'Hi! I''m WarriorPigs!', 'warriorpigs@gmail.com'),
(8, 'MichuBarboot', 'Pongo77b', 'upload/avatar_8_2014-03-04-17-22-27.jpg', 'Orinda', 'Like to fly fish and garden\n', 'michethebarb@gmail.com'),
(9, 'chrbaudry', 'CB150500', 'upload/avatar_9_2014-03-04-17-55-25.jpg', '', '', 'Chrbaudry@gmail.com'),
(10, 'tammie1991', 'jade69', 'upload/avatar_10_2014-03-06-06-56-13.jpg', '', '', 'miss.tammie@live.com.au'),
(11, 'sensiblealtacto', '23-Alcuadrado', 'upload/avatar_11_2014-03-07-02-12-33.jpg', 'MÃ©xico', '', 'jaqueca@live.com'),
(12, 'Namuun M.', '123namuka', 'upload/avatar_12_2014-03-09-05-40-01.jpg', '', '', 'nana_nmn19@yahoo.com'),
(13, 'aunglada', 'aunglada9118', 'upload/avatar_13_2014-03-09-21-51-39.jpg', '', '', 'blossom_pinky1@hotmail.com'),
(14, 'RB', 'outremer', 'upload/avatar_14_2014-03-09-23-10-20.jpg', 'France', '', 'baudry.romain@gmail.com'),
(15, 'alex', 'went112', 'upload/avatar_15_2014-03-16-12-33-34.jpg', '', '', 'ala.glinka5@gmail.com'),
(16, 'ravinder521986', '123456', 'upload/avatar_16_2014-03-18-23-32-29.jpg', '', '\n\n\n\n\n', 'ravinderk_1986@yahoo.com'),
(17, 'scottharvey', 'diller22', 'upload/avatar_17_2014-03-25-22-26-48.jpg', '', '', 'scottharv@hotmail.com'),
(18, 'Kitkat0223', 'Ball741852', 'upload/avatar_18_2014-03-31-00-37-24.jpg', '', '', 'snow741852@yahoo.com'),
(19, 'fedka', 'fedka95', 'upload/avatar_19_2014-05-04-17-59-17.jpg', '', '', 'ikaplanova@list.ru'),
(20, 'Nika', '30days', 'upload/avatar_20_2014-05-21-05-51-56.jpg', 'Mongolia', '', 'dnika88@yahoo.com'),
(21, 'bnelli', 'kokomoorange', 'upload/avatar_21_2014-05-21-12-45-30.jpg', '', '', 'b.nellisoftball@gmail.com');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
