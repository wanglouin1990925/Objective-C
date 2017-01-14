<?php
	include('./config.php');
	
	$userid		= $_REQUEST["userid"];
	$userfbid	= $_REQUEST["userfbid"];
	$date		= date( "Y-m-d H:i:s" );
	
	//Get Notification				
	$query = "select * from tbl_notification where `not_userid` = '".$userid."' or `not_userfbid` = '".$userfbid."' order by not_date DESC";
	if($result_notification = mysql_query($query))
	{
		$notificationarray = array();
		while($row_notification = @mysql_fetch_object($result_notification))
		{
			$diff = abs(strtotime($date) - strtotime($row_notification->not_date));
			$row_notification->timediff = $diff;

			array_push($notificationarray,$row_notification);			
		}
		
		$json_data = array("success"=>"1","detail"=>$notificationarray);
	}
	else
	{
		$json_data = array("success"=>"0","detail"=>mysql_error());
	}
	
	echo json_encode($json_data);
?>