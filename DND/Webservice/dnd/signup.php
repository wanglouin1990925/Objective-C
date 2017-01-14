<?php
	include('./config.php');

	$facebookid	= $_REQUEST["facebookid"];
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
	
	$query = "select * from  tbl_user where user_facebookid= '".$facebookid."'";
	if($result = mysql_query($query))
	{
		$nums = mysql_num_rows($result);
		if( $nums > 0 )
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
			
			$row->rate = $totalscore;
			$row->comments = $ratearray;
			
			//Get Notification				
			$query = "select * from tbl_notification where `not_userid` = '".$row->user_id."' or `not_userfbid` = '".$row->user_facebookid."' order by not_date DESC";
			$result_notification = mysql_query($query);

			$notificationarray = array();
			while($row_notification = @mysql_fetch_object($result_notification))
			{
				$diff = abs(strtotime($date) - strtotime($row_notification->not_date));
				$row_notification->timediff = $diff;

				array_push($notificationarray,$row_notification);			
			}

			$json_data = array("success"=>"1","detail"=>$row,"notification"=>$notificationarray);
				
		}
		else
		{
			$query = "insert into tbl_user (user_facebookid,user_firstname,user_lastname,user_gender,user_age,user_latitude,user_longitude,user_photo1,user_photo2,user_photo3,user_photo4,user_photo5,user_photo6,user_photo7,user_photo8,user_photo9,user_photo10) values (\"$facebookid\",\"$firstname\",\"$lastname\",\"$gender\",\"$age\",\"$latitude\",\"$longitude\",\"$photo1\",\"$photo2\",\"$photo3\",\"$photo4\",\"$photo5\",\"$photo6\",\"$photo7\",\"$photo8\",\"$photo9\",\"$photo10\")";
	
			if ( mysql_query($query) )
			{
				$query = "select * from  tbl_user where user_facebookid= '".$facebookid."' order by rat_date DESC";
				
				if ( $result = mysql_query($query) )
				{
					$row = @mysql_fetch_object($result);
					
					//Get Score
					$query = "select * from tbl_rate where `rat_userfbidto` = '".$row->user_facebookid."'";
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
						$commentarray = array();
						while($row_comment = @mysql_fetch_object(mysql_query($query)))
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
			
					$row->rate 		= $totalscore;
					$row->comments 	= $ratearray;
					
					//Get Notification				
					$query = "select * from tbl_notification where `not_userid` = '".$row->userid."'  or `not_userfbid` = '".$row->user_facebookid."' order by not_date DESC";
					$result_notification = mysql_query($query);

					$notificationarray = array();
					while($row_notification = @mysql_fetch_object($result_notification))
					{
						$diff = abs(strtotime($date) - strtotime($row_notification->not_date));
						$row_notification->timediff = $diff;

						array_push($notificationarray,$row_notification);			
					}

					$json_data = array("success"=>"1","detail"=>$row,"notification"=>$notificationarray);
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
		}
	}
	else
	{
		$json_data = array("success"=>"0","detail"=>mysql_error());
	}
	
	echo json_encode($json_data);
?>