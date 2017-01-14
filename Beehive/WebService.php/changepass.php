<?php
	include('./config.php');

	$userid		= $_REQUEST["userid"];
	$password	= $_REQUEST["password"];
	
	$query = "update tbl_user set user_password = '".$password."' where `user_id` = ".$userid."";
	if(mysql_query($query))
	{
		$query = "select * from  tbl_user where `user_id`= '".$userid."'";
		$row = @mysql_fetch_object( mysql_query($query));		
		
		$json_data = array("success"=>"1","detail"=>$row);
	}
	else
	{
		$json_data = array("success"=>"0","detail"=>"An unknown error occured");
	}	

	echo json_encode($json_data);
?>