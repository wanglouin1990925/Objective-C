<?php
	include('./config.php');

	$string			= $_REQUEST["query"];
	$projectid  	= $_REQUEST["projectid"];
	
	$query = "UPDATE tbl_project SET ".$string." WHERE `index` = ".$projectid."";
	if(mysql_query($query))
	{
		$query = "select * from  tbl_project where `index` = ".$projectid."";
		$result = mysql_query($query);
		$row = @mysql_fetch_object($result);

		$profile = array();
		$profile = $row;
		
		$json_data = array("success"=>"1","detail"=>$profile);
	}
	else
	{
		$json_data = array("success"=>"0","detail"=>"Connection Error","query"=>$query);
	}
	
	echo json_encode($json_data);
?>