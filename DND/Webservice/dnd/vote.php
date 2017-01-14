<?php
	include('./config.php');

	$userid		= $_REQUEST["userid"];
	$rateid		= $_REQUEST["rateid"];
	$type 		= $_REQUEST["type"];
	
	$query = "insert into tbl_vote (vot_useridfrom,vot_rateid) values (\"$userid\",\"$rateid\")";
	mysql_query($query);
	
	$query = "select * from tbl_rate where `rat_id` = '".$rateid."' order by rat_date DESC";
	if($result = mysql_query($query))
	{
		$row = @mysql_fetch_object($result);
		
		$upvotes 	= $row->rat_upvotes;
		$downvotes 	= $row->rat_downvotes;
		
		if($type == "up")
			$upvotes = $upvotes + 1;
		else if($type == "down")
			$downvotes = $downvotes + 1;
	
		$query = "update tbl_rate set rat_upvotes = '".$upvotes."' ,rat_downvotes = '".$downvotes."' where `rat_id`='".$rateid."'";
		if(mysql_query($query))
		{
			$row->rat_upvotes = $upvotes;
			$row->rat_downvotes = $downvotes;
			
			$query = "select * from  tbl_vote where vot_rateid= '".$row->rat_id."'";
			$result_vote = mysql_query($query);
			
			$voteuserarray = array();
			while($row_vote = @mysql_fetch_object($result_vote))
			{
				array_push($voteuserarray,$row_vote->vot_useridfrom);					
			}
			
			$row->voteuserarray = $voteuserarray;
			
			
			//Get Comments				
			$query = "select * from tbl_comment where `cmt_rateid` = '".$row->rat_id."'";
			$result_comment = mysql_query($query);
			
			$commentarray = array();
			while($row_comment = @mysql_fetch_object($result_comment))
			{
				$diff = abs(strtotime($date) - strtotime($row_comment->cmt_date));
				$row_comment->timediff = $diff;
	
				array_push($commentarray,$row_comment);			
			}
			$row->commentarray = $commentarray;
			//-------
			
			$json_data = array("success"=>"1","detail"=>$row);
		}
		else
		{
			$json_data = array("success"=>"0","detail"=>mysql_error());
		}
	}
	else
	{
		$json_data = array("success"=>"0","detail"=>mysql_error());
	}
	
	echo json_encode($json_data);
?>