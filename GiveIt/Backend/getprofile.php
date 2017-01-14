<?php
	include('./config.php');

	$userid	= $_REQUEST["userid"];
	$me	= $_REQUEST["me"];
	
	$query = "select * from  tbl_user where `index`= '".$userid."'";

	if ( mysql_query($query) )
	{
		$result = mysql_query($query);
		$row = @mysql_fetch_object($result);
		
		if($row)
		{
			$profile = array();
			$profile = $row;
			
			$query = "select * from  tbl_follow where useridto= '".$userid."'";
			$nums_follower = mysql_num_rows(mysql_query($query));
		
			$query = "select * from  tbl_follow where useridto= '".$userid."' and useridfrom='".$me."'";
			$isfollowing = mysql_num_rows(mysql_query($query));
		
			//Get Projects.
			$query = "select * from  tbl_project where userid= '".$userid."'";
			$result = mysql_query($query);
			
			$projectarray = array();
			while($row = @mysql_fetch_object($result))
			{
				$project = array();
				$project = $row;
								
				$projectid = $row->index;
				
				//Get Posts.
				$query = "select * from  tbl_post where projectid= '".$projectid."' ORDER BY convert(`daynumber`,decimal) ASC";
				$result_post = mysql_query($query);
				
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
				
				array_push($projectarray,$project);
			}
			
			$json_data = array("success"=>"1","detail"=>$profile,"follower"=>$nums_follower,"project"=>$projectarray,"isfollowing"=>$isfollowing);
		}
		else
		{
			$json_data = array("success"=>"0","detail"=>"Not Exist");
		}
	}
	else
	{
		$json_data = array("success"=>"0","detail"=>"Connection Error");
	}
	
	echo json_encode($json_data);
?>