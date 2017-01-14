<?php
	include('./config.php');
	
	$userid		= $_REQUEST["userid"];
	$groupid	= $_REQUEST["groupid"];
	$title		= mysql_real_escape_string($_REQUEST["title"]);
	$place		= mysql_real_escape_string($_REQUEST["place"]);
	$about		= mysql_real_escape_string($_REQUEST["about"]);
	$latitude	= $_REQUEST["latitude"];
	$longitude	= $_REQUEST["longitude"];
	$date1		= date( "Y-m-d-H-i-s" );
	$date		= date( "Y-m-d H:i:s" );

	$query = "update tbl_group set title = '".$title."',about = '".$about."',location = '".$place."',latitude = '".$latitude."',longitude = '".$longitude."' where `id` = ".$groupid."";
	if(mysql_query($query))
	{
		$query = "select * from  tbl_group where `id`= '".$groupid."'";
		$row = @mysql_fetch_object( mysql_query($query));		
	
		$json_data = array("success"=>"1","detail"=>$row);
	}
	else
	{
// 		$json_data = array("success"=>"0","detail"=>"An unknown error occured");
		$json_data = array("success"=>"0","detail"=>mysql_error());
	}	

	echo json_encode($json_data);
?>