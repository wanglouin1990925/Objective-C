<?php
	include('./config.php');

	$glstmsgid	= $_REQUEST["glstmsgid"];
	$lstmsgid	= $_REQUEST["lstmsgid"];

	if($lstmsgid == "")
	{
		$query = "DELETE FROM tbl_glstmsg WHERE `id` = ".$glstmsgid."";
	}
	else
	{
		$query = "DELETE FROM tbl_lstmsg WHERE `id` = ".$lstmsgid."";
	}

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