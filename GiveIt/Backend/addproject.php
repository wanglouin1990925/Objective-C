<?php
	include('./config.php');

	$userid		= $_REQUEST["userid"];
	$title		= $_REQUEST["title"];
	$category	= $_REQUEST["category"];
	
	$query = "insert into tbl_project (userid,title,category) values (\"$userid\",\"$title\",\"$category\")";
	if ( mysql_query($query) )
	{
		$json_data = array("success"=>"1","detail"=>"Success");
	}
	else
	{
		$json_data = array("success"=>"0","detail"=>"Connection Error");
	}
	
	echo json_encode($json_data);
?>