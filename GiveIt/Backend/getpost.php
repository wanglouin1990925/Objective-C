<?php
	include('./config.php');

	$postid		= $_REQUEST["postid"];
	$userid		= $_REQUEST["userid"];
	
	//Get Posts.
	$query = "select * from  tbl_post where `index`= '".$postid."'";
	if($result_post = mysql_query($query))
	{
		$row_post = @mysql_fetch_object($result_post);

		$post = array();
		$post = $row_post;

		$postid = $row_post->index;

		$query = "select * from  tbl_like where postid= '".$postid."'";
		$nums_like = mysql_num_rows(mysql_query($query));

		$query = "select * from  tbl_comment where postid= '".$postid."'";
		$nums_comment = mysql_num_rows(mysql_query($query));

		$post->nums_like = $nums_like;
		$post->nums_comment = $nums_comment;

		$query = "select * from  tbl_like where postid= '".$postid."' and userid = '".$userid."'";
		$flike = mysql_fetch_object(mysql_query($query));

		if($flike) $post->islike = "1";
		else $post->islike = "0";

		$json_data = array("success"=>"1","detail"=>$post);
	}
	else
	{
		$json_data = array("success"=>"0","detail"=>"Connection Error");
	}
		
	echo json_encode($json_data);
?>