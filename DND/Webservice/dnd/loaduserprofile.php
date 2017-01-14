<?php
	include('./config.php');

	$facebookid 	= $_REQUEST["facebookid"]; 
	$date			= date( "Y-m-d H:i:s" );
	
	$query = "select * from  tbl_user where `user_facebookid`= '".$facebookid."'";
	if($result = mysql_query($query))
	{
		if($row = @mysql_fetch_object($result))		//Registered User
		{
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
	
			$json_data = array("success"=>"1","existing"=>"1","detail"=>$row,"comment"=>$ratearray,"rate"=>$totalscore);
		}
		else										//Unregistered User
		{
			//Get Score
			$query = "select * from tbl_rate where `rat_userfbidto` = '".$facebookid."' order by rat_date DESC";
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
				//---------
				
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
		
			$json_data = array("success"=>"1","existing"=>"0","comment"=>$ratearray,"rate"=>$totalscore);
		}		
	}
	else
	{
		$json_data = array("success"=>"0","detail"=>mysql_error());
	}		
	
	echo json_encode($json_data);
?>