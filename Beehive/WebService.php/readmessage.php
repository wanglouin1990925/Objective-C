<?php
	include('./config.php');

	$userid 	= $_REQUEST["userid"];
	$useridto 	= $_REQUEST["useridto"];
	
	$query = "UPDATE tbl_message SET status='0' WHERE `userid` = ".$userid." and `useridfrom` = ".$useridto."";
	mysql_query($query);
?>