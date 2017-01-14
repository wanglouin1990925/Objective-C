<?php
	include('./config.php');

	$userid		= $_REQUEST["userid"];
	$groupid	= $_REQUEST["groupid"];
	$date		= date( "Y-m-d H:i:s" );

	$query = "DELETE FROM tbl_groupuser WHERE groupid = '".$groupid."' and userid = '".$userid."'";	
	if (mysql_query($query))
	{
		$json_data = array("success"=>"1","detail"=>"Success");
		echo json_encode($json_data);
	}
	else
	{
		$json_data = array("success"=>"0","detail"=>"Connection Error");
		echo json_encode($json_data);
	}
?>