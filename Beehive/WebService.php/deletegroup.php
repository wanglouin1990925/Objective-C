<?php
	include('./config.php');

	$groupid	= $_REQUEST["groupid"];
	$userid	= $_REQUEST["userid"];
	$date		= date( "Y-m-d H:i:s" );
	
	$query = "DELETE FROM tbl_group WHERE id = '".$groupid."'";
	if(mysql_query($query))
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