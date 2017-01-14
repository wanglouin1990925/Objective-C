<?php
	include('./config.php');

	$useridfrom	= $_REQUEST["useridfrom"];
	$userfbidto	= $_REQUEST["userfbidto"];
	$score		= $_REQUEST["score"];
 	$comment	= $_REQUEST["comment"];
 	$nickname	= $_REQUEST["nickname"];
	$date		= date( "Y-m-d H:i:s" );
	
	$query1 = "delete from tbl_rate where `rat_useridfrom` = '".$useridfrom."' and `rat_userfbidto` = '".$userfbidto."'";
	if(!mysql_query($query1))
	{
		$json_data = array("success"=>"0","detail"=>mysql_error());
		echo json_encode($json_data);
		return;
	}
	
	$query = "insert into tbl_rate (rat_useridfrom,rat_userfbidto,rat_score,rat_comment,rat_date,rat_upvotes,rat_downvotes,rat_nickname) values (\"$useridfrom\",\"$userfbidto\",\"$score\",\"$comment\",\"$date\",'0','0',\"$nickname\")";
	
	if($result = mysql_query($query))
	{
		$score1 = 2 * $score;
		$not_content = "You have been rated a ".$score1." stars";
		$query = "insert into tbl_notification (not_userid,not_userfbid,not_rateid,not_content,not_date) values ('',\"$userfbidto\",'',\"$not_content\",\"$date\")";
		mysql_query($query);
		
		$query = "select * from tbl_rate where `rat_userfbidto` = '".$userfbidto."' order by rat_date DESC";
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
			
		$json_data = array("success"=>"1","detail"=>"success","comment"=>$ratearray,"rate"=>$totalscore,"query"=>$query1);
		
		//Send Push Notification
// 		$APPLICATION_ID = "L5ffbFXwkXzIktNcPU8QZyB12Szb1m1MZGEB6J2v";
// 		$REST_API_KEY 	= "7QUQmHFMhPxV09keQF1ByG2Z4nLkBgjB8gDNSm4U";
// 		$MESSAGE 		= $not_content;
// 		
// 		$url = 'https://api.parse.com/1/push';
// 		$data = array(
// 		  'type' => 'ios',
// 		  'expiry' => 1451606400,
// 		  'where' => array(
// 			  'owner' => $userfbidto,
// 			),
// 		  'data' => array(
// 			 'alert' => $MESSAGE,
// 			 'sound' => 'push.caf',
// 		  ),
// 		);
// 		$_data = json_encode($data);
// 		$headers = array(
// 		  'X-Parse-Application-Id: ' . $APPLICATION_ID,
// 		  'X-Parse-REST-API-Key: ' . $REST_API_KEY,
// 		  'Content-Type: application/json',
// 		  'Content-Length: ' . strlen($_data),
// 		);
// 
// 		$curl = curl_init($url);
// 		curl_setopt($curl, CURLOPT_POST, 1);
// 		curl_setopt($curl, CURLOPT_POSTFIELDS, $_data);
// 		curl_setopt($curl, CURLOPT_HTTPHEADER, $headers);
// 		curl_setopt($curl, CURLOPT_RETURNTRANSFER,1);
// 		curl_exec($curl);
		//--------------
	}
	else
	{
		$json_data = array("success"=>"0","detail"=>mysql_error());
	}
	
	echo json_encode($json_data);
?>