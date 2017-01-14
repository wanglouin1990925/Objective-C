<?php
	include('./config.php');

	$userid			= $_REQUEST["userid"];
	$rateid			= $_REQUEST["rateid"];
	$comment 		= $_REQUEST["comment"];
	$date			= date( "Y-m-d H:i:s" );
	
	$query = "insert into tbl_comment (cmt_useridfrom,cmt_rateid,cmt_description,cmt_date) values (\"$userid\",\"$rateid\",\"$comment\",\"$date\")";
	if(mysql_query($query))
	{
		$query = "select * from tbl_rate where `rat_id` = '".$rateid."'";
		$row = @mysql_fetch_object(mysql_query($query));
		
		$userfbidto = $row->rat_userfbidto;
		$not_content = "You have new review";
		$query = "insert into tbl_notification (not_userid,not_userfbid,not_rateid,not_content,not_date) values ('',\"$userfbidto\",\"$rateid\",\"$not_content\",\"$date\")";
		mysql_query($query);
		
		$query = "select * from tbl_comment where `cmt_rateid` = '".$rateid."'";
		if($result = mysql_query($query))
		{
			$commentarray = array();
			while($row = @mysql_fetch_object($result))
			{
				$diff = abs(strtotime($date) - strtotime($row->cmt_date));
				$row->timediff = $diff;
			
				array_push($commentarray,$row);			
			}
			
			$json_data = array("success"=>"1","detail"=>$commentarray);
		}
		
		//Send Push Notification
// 		$APPLICATION_ID = "L5ffbFXwkXzIktNcPU8QZyB12Szb1m1MZGEB6J2v";
// 		$REST_API_KEY 	= "7QUQmHFMhPxV09keQF1ByG2Z4nLkBgjB8gDNSm4U";
// 		$MESSAGE 		= $not_content;
// 		
// 		$url = 'https://api.parse.com/1/push';
// 		$data = array(
// 		  'type' => 'ios',
// 		  'expiry' => 1451606400,
// 		  'channels' => ["c".$userfbidto],
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