<?php
	include('./config.php');

	$userid		= $_REQUEST["userid"];
	$useridto	= $_REQUEST["useridto"];

	$query = "DELETE FROM tbl_block WHERE userid = '".$userid."' and useridto = '".$useridto."'";	
	if(mysql_query($query))
	{
		$query = "select * from  tbl_user where user_id= '".$useridto."'";
		$row = @mysql_fetch_object(mysql_query($query));
	
		$json_data = array("success"=>"1","detail"=>$row);
		echo json_encode($json_data);
	}
	else
	{
		$json_data = array("success"=>"0","detail"=>"Connection Error");
		echo json_encode($json_data);
	}
?>