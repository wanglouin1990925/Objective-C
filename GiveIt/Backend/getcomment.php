<?php
	include('./config.php');

	$postid	= $_REQUEST["postid"];
	
	$query = "select * from  tbl_comment where postid= '".$postid."'";

	if ( mysql_query($query) )
	{
		$result = mysql_query($query);
		
		$commentarray = array();
		while($row = @mysql_fetch_object($result))
		{
			$comment = array();
			$comment = $row;
			
			$query = "select * from  tbl_user where `index`= '".$comment->userid."'";
			$row_user = @mysql_fetch_object(mysql_query($query));
			
			$comment->user_avatar = $row_user->user_avatar;
			$comment->username = $row_user->user_username;
			
			array_push($commentarray,$comment);
		}
		$json_data = array("success"=>"1","detail"=>$commentarray);
	}
	else
	{
		$json_data = array("success"=>"0","detail"=>"Connection Error");
	}
	
	echo json_encode($json_data);
?>