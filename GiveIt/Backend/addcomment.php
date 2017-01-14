<?php
	include('./config.php');

	$userid		= $_REQUEST["userid"];
	$postid		= $_REQUEST["postid"];
	$comment	= $_REQUEST["comment"];
	$date		= date( "Y-m-d H:i:s" );

	$query = "insert into tbl_comment (userid,postid,comment,date) values (\"$userid\",\"$postid\",\"$comment\",\"$date\")";
	if ( mysql_query($query) )
	{
		$query = "select * from  tbl_comment where postid= '".$postid."'";

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