<?php
	include('./config.php');

	$userid		= $_REQUEST["userid"];
	$category		= $_REQUEST["category"];
	
	if($category == "recommended") $query = "select * from  tbl_project";
	else $query = "select * from  tbl_project where category = '".$category."'";
	
	$result = mysql_query($query);

	if($result)
	{
		$projectarray = array();
		
		while($row = @mysql_fetch_object($result))
		{
			$project = array();
			$project = $row;
					
			$projectid = $row->index;
			
			//Get Posts.
			
			$query = "select * from  tbl_post where projectid= '".$projectid."' ORDER BY daynumber DESC LIMIT 3";
			$result_post = mysql_query($query);
			
			$nums = mysql_num_rows($result_post);
			if($nums > 0)
			{
				$postarray = array();
				while($row_post = @mysql_fetch_object($result_post))
				{
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
		
					array_push($postarray,$post);
				}
	
				$project->posts = $postarray;
			
				$puserid = $row->userid;
			
				$query = "select * from  tbl_user where `index`= '".$puserid."'";
				$result_user = @mysql_fetch_object(mysql_query($query));
			
				$userinfo = array();
				$userinfo = $result_user;
			
				$project->userinfo = $userinfo;
	
				array_push($projectarray,$project);
			}
		}
		$json_data = array("success"=>"1","detail"=>$projectarray);
	}
	else
	{
		$json_data = array("success"=>"0","detail"=>"Connection Error");
	}
		
	echo json_encode($json_data);
?>