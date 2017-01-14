<?php
	include('./config.php');

	$useridfrom	= $_REQUEST["useridfrom"];
	$userfbidto	= $_REQUEST["userfbidto"];
	$score		= $_REQUEST["score"];
	$comment	= $_REQUEST["comment"];
	$nickname	= $_REQUEST["nickname"];
	
	$facebookid	= $_REQUEST["userfbidto"];
	$firstname	= $_REQUEST["firstname"];
	$lastname	= $_REQUEST["lastname"];
 	$gender		= $_REQUEST["gender"];
 	$latitude	= $_REQUEST["latitude"];
 	$longitude	= $_REQUEST["longitude"];
 	$age		= $_REQUEST["age"];
 	$photo1		= $_REQUEST["photo1"];
	$photo2		= $_REQUEST["photo2"];
	$photo3		= $_REQUEST["photo3"];
	$photo4		= $_REQUEST["photo4"];
	$photo5		= $_REQUEST["photo5"];
	$photo6		= $_REQUEST["photo6"];
	$photo7		= $_REQUEST["photo7"];
	$photo8		= $_REQUEST["photo8"];
	$photo9		= $_REQUEST["photo9"];
	$photo10	= $_REQUEST["photo10"];
	$date		= date( "Y-m-d H:i:s" );	

	
	//Rate User
	$query = "delete from tbl_rate where `rat_useridfrom` = '".$useridfrom."' and `rat_userfbidto` = '".$userfbidto."'";
	mysql_query($query);
	
	$query = "insert into tbl_rate (rat_useridfrom,rat_userfbidto,rat_score,rat_comment,rat_date,rat_upvotes,rat_downvotes,rat_nickname) values (\"$useridfrom\",\"$userfbidto\",\"$score\",\"$comment\",\"$date\",'0','0',\"$nickname\")";
	mysql_query($query);
	
	$query = "insert into tbl_user (user_facebookid,user_firstname,user_lastname,user_gender,user_age,user_latitude,user_longitude,user_photo1,user_photo2,user_photo3,user_photo4,user_photo5,user_photo6,user_photo7,user_photo8,user_photo9,user_photo10) values (\"$facebookid\",\"$firstname\",\"$lastname\",\"$gender\",\"$age\",\"$latitude\",\"$longitude\",\"$photo1\",\"$photo2\",\"$photo3\",\"$photo4\",\"$photo5\",\"$photo6\",\"$photo7\",\"$photo8\",\"$photo9\",\"$photo10\")";
	mysql_query($query);
	
	$score1 = 2 * $score;
	$not_content = "You have been rated a ".$score1." stars";
	$query = "insert into tbl_notification (not_userid,not_userfbid,not_rateid,not_content,not_date) values ('',\"$userfbidto\",'',\"$not_content\",\"$date\")";
	mysql_query($query);
	
	$query = "select * from  tbl_user where `user_facebookid`= '".$facebookid."'";
	if($result = mysql_query($query))
	{
		$row = @mysql_fetch_object($result);
		
		//Get Score
		$query = "select * from tbl_rate where `rat_userfbidto` = '".$row->user_facebookid."' order by rat_date DESC";
		$result_rate = mysql_query($query);

		$totalscore = 0;
		$scorecount = 0;
	
		$ratearray = array();
		while($row_rate = @mysql_fetch_object($result_rate))
		{
			$totalscore = $totalscore + $row_rate->rat_score;
			$scorecount = $scorecount + 1;
		
			//Get Difference
			$diff = abs(strtotime($date) - strtotime($row_rate->rat_date));
			$row_rate->timediff = $diff;
			
			//Get Votes
			$query = "select * from  tbl_vote where vot_rateid= '".$row_rate->rat_id."'";
			$result_vote = mysql_query($query);
			
			$voteuserarray = array();
			while($row_vote = @mysql_fetch_object($result_vote))
			{
				array_push($voteuserarray,$row_vote->vot_useridfrom);					
			}				
			$row_rate->voteuserarray = $voteuserarray;
			//------
			
			//Get Comments				
			$query = "select * from tbl_comment where `cmt_rateid` = '".$row_rate->rat_id."'";
			$result_comment = mysql_query($query);
			
			$commentarray = array();
			while($row_comment = @mysql_fetch_object($result_comment))
			{
				$diff = abs(strtotime($date) - strtotime($row_comment->cmt_date));
				$row_comment->timediff = $diff;
	
				array_push($commentarray,$row_comment);			
			}
			$row_rate->commentarray = $commentarray;
			//-------
			
			array_push($ratearray,$row_rate);
		}
	
		if($scorecount !=0 )
			$totalscore = $totalscore/$scorecount;

		$json_data = array("success"=>"1","detail"=>$row,"comment"=>$ratearray,"rate"=>$totalscore);
	}
	else
	{
		$json_data = array("success"=>"0","detail"=>mysql_error());
	}		
	
	echo json_encode($json_data);
?>