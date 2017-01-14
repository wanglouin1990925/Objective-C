<?php
	include('./config.php');

	$useridfrom	= $_REQUEST["useridfrom"];
	$useridto	= $_REQUEST["useridto"];
	$action		= $_REQUEST["action"];
	$date		= date( "Y-m-d H:i:s" );
	
	$query = "delete from tbl_follow where useridfrom = '".$useridfrom."' and useridto = '".$useridto."'";
	mysql_query($query);
	
	if($action == "0")
	{
		$query = "insert into tbl_follow (useridfrom,useridto,date) values (\"$useridfrom\",\"$useridto\",\"$date\")";
		if(mysql_query($query))
		{
			$query = "select * from  tbl_follow where useridto= '".$useridto."' and useridfrom='".$useridfrom."'";
			$isfollowing = mysql_num_rows(mysql_query($query));
			
			$query = "select * from  tbl_follow where useridto= '".$useridto."'";
			$nums_follower = mysql_num_rows(mysql_query($query));
			
			$json_data = array("success"=>"1","detail"=>$isfollowing,"follower"=>$nums_follower);
			echo json_encode($json_data);
		}
		else
		{
			$json_data = array("success"=>"0","detail"=>"Connection Error");
			echo json_encode($json_data);
		}
	}else
	{
			$query = "select * from  tbl_follow where useridto= '".$useridto."' and useridfrom='".$useridfrom."'";
			$isfollowing = mysql_num_rows(mysql_query($query));
			
			$query = "select * from  tbl_follow where useridto= '".$useridto."'";
			$nums_follower = mysql_num_rows(mysql_query($query));
			
			$json_data = array("success"=>"1","detail"=>$isfollowing,"follower"=>$nums_follower);
			echo json_encode($json_data);
	}
?>