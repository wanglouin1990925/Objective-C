<?php
	include('./config.php');

	$userid 	= $_REQUEST["userid"];
	$groupid 	= $_REQUEST["groupid"];
	
	$query = "UPDATE tbl_gmessage SET status='0' WHERE `userid` = ".$userid." and `groupid` = ".$groupid."";
	mysql_query($query);
?>