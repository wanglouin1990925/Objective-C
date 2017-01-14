<?php
	include('./config.php');

	$userid	= $_REQUEST["userid"];
	
	$query = "select * from  tbl_follow where useridto= '".$userid."'";

	if ( mysql_query($query) )
	{
		$result = mysql_query($query);
		
		$followarray = array();
		while($row = @mysql_fetch_object($result))
		{
			$follow = array();
			$follow = $row;
			
			$query = "select * from  tbl_user where `index`= '".$follow->useridfrom."'";
			$row_user = @mysql_fetch_object(mysql_query($query));
			
			$follow->user_avatar = $row_user->user_avatar;
			$follow->username = $row_user->user_username;
			
			array_push($followarray,$follow);
		}
		
		///Get Like
		$query = "select * from  tbl_like where useridto= '".$userid."'";
		$result = mysql_query($query);
		
		$likearray = array();
		while($row = @mysql_fetch_object($result))
		{
			$like = array();
			$like = $row;
			
			$query = "select * from  tbl_user where `index`= '".$like->userid."'";
			$row_user = @mysql_fetch_object(mysql_query($query));
			
			$like->user_avatar = $row_user->user_avatar;
			$like->username = $row_user->user_username;
			
			$query = "select * from  tbl_post where `index`= '".$like->postid."'";
			$row_post = @mysql_fetch_object(mysql_query($query));
			
			$like->videourl = $row_post->videourl;

			array_push($likearray,$like);
		}
		
		$json_data = array("success"=>"1","detail"=>$followarray,"like"=>likearray);
	}
	else
	{
		$json_data = array("success"=>"0","detail"=>"Connection Error");
	}
	
	echo json_encode($json_data);
?>