<?php
	include('./config.php');

	$userid		= $_REQUEST["userid"];
	$date		= date( "Y-m-d H:i:s" );
	
	$query = "select * from tbl_user where user_id = '".$userid."'";

	if ( mysql_query($query) )
	{
		$result = mysql_query($query);
		$row = @mysql_fetch_object($result);
		
		if($row)
		{
			//Get Last Login
			$diff = abs(strtotime($date) - strtotime($row->user_lastonline));
			$row->lastlogin = $diff;
			
			$query = "select * from  tbl_userphoto where `userid` = '".$row->user_id."'";
			$photoarray = array();
			if ( mysql_query($query) )
			{
				$result = mysql_query($query);
				while($row_photo = @mysql_fetch_object($result))
				{
					array_push($photoarray,$row_photo);
				}
			}
			
			$query = "select * from  tbl_groupuser where `userid` = '".$row->user_id."' and `status` = '1'";
			$grouparray = array();
			if ( mysql_query($query) )
			{
				$result = mysql_query($query);
				while($row_groupuser = @mysql_fetch_object($result))
				{
					$query = "select * from  tbl_group where `id` = '".$row_groupuser->groupid."'";
					$row_group = @mysql_fetch_object(mysql_query($query));
					
					if($row_group)
						array_push($grouparray,$row_group);
				}
			}
			
			$json_data = array("success"=>"1","detail"=>$row,"photoarray"=>$photoarray,"grouparray"=>$grouparray);
		}
		else
		{
			$json_data = array("success"=>"0","detail"=>"An unknown error occured");
		}
	}
	else
	{
		$json_data = array("success"=>"0","detail"=>"An unknown error occured");
	}
	
	echo json_encode($json_data);
?>