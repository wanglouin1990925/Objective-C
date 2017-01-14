<?php
	include('./config.php');

	$projectid	= $_REQUEST["projectid"];

	$query = "delete from tbl_project where `index` = '".$projectid."'";
	mysql_query($query);
	
	$query = "delete from tbl_post where projectid = '".$projectid."'";
	mysql_query($query);
	
	$json_data = array("success"=>"1","detail"=>"Success");
	echo json_encode($json_data);
?>