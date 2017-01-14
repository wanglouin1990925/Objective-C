<?php
	include('./config.php');

	$userid	= $_REQUEST["userid"];
	$postid	= $_REQUEST["postid"];
	$action	= $_REQUEST["action"];
	$date= date( "Y-m-d H:i:s" );
	
	$query = "delete from tbl_like where userid = '".$userid."' and postid = '".$postid."'";
	mysql_query($query);
	
	$query = "select * from  tbl_post where `index`= '".$postid."'";
	$row = @mysql_fetch_object(mysql_query($query));
	
	$query = "select * from  tbl_project where `index`= '".$row->projectid."'";
	$row = @mysql_fetch_object(mysql_query($query));
	
	$useridto = $row->userid;
	
	if($action == "0")
	{
		$query = "insert into tbl_like (userid,postid,date,useridto) values (\"$userid\",\"$postid\",\"$date\",\"$useridto\")";
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
	}else
	{
			$json_data = array("success"=>"1","detail"=>"Success");
			echo json_encode($json_data);
	}
?>