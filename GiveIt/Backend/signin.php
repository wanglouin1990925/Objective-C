<?php
	include('./config.php');

	$user_username	= $_REQUEST["username"];
	$user_password	= $_REQUEST["password"];
	
	$query = "select * from  tbl_user where user_username= '".$user_username."' and user_password = '".$user_password."'";

	if ( mysql_query($query) )
	{
		$result = mysql_query($query);
		$row = @mysql_fetch_object($result);
		
		if($row)
		{
			$profile = array();
			$profile = $row;
		
			$json_data = array("success"=>"1","detail"=>$profile);
		}
		else
		{
			$json_data = array("success"=>"0","detail"=>"Password wrong");
		}
	}
	else
	{
		$json_data = array("success"=>"0","detail"=>"Connection Error");
	}
	
	echo json_encode($json_data);
?>