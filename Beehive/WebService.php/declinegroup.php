<?php
	include('./config.php');

	$userid		= $_REQUEST["userid"];
	$groupid	= $_REQUEST["groupid"];
	$date		= date( "Y-m-d H:i:s" );
	
	$query = "DELETE FROM tbl_groupuser WHERE userid = '".$userid."' and groupid = '".$groupid."'";
	if (mysql_query($query))
	{
		$json_data = array("success"=>"1","detail"=>"Sucess");
		echo json_encode($json_data);
	}
	else
	{
		$json_data = array("success"=>"0","detail"=>"Connection Error");
		echo json_encode($json_data);
	}
?>