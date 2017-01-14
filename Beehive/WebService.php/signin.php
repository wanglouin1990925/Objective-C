<?php
	include('./config.php');

	$user_phone		= $_REQUEST["phone"];
	$user_password	= $_REQUEST["password"];
	$user_latitude	= $_REQUEST["latitude"];
	$user_longitude	= $_REQUEST["longitude"];
	
	$date			= date( "Y-m-d H:i:s" );
	
	$query = "select * from  tbl_user where user_phone= '".$user_phone."' and user_password = '".$user_password."'";

	if ( mysql_query($query) )
	{
		$result = mysql_query($query);
		$row = @mysql_fetch_object($result);
		
		if($row)
		{
			$query = "UPDATE tbl_user SET user_lastonline='".$date."',user_latitude='".$user_latitude."',user_longitude='".$user_longitude."' WHERE `user_phone` = ".$user_phone."";
			mysql_query($query);
		
			$query = "select * from  tbl_userphoto where `userid` = '".$row->user_id."'";
			$photoarray = array();
			if ( $result = mysql_query($query) )
			{
				while($row_photo = @mysql_fetch_object($result))
				{
					array_push($photoarray,$row_photo);
				}
			}
			
			$query = "select * from  tbl_groupuser where `userid` = '".$row->user_id."' and `status` = '1'";
			$grouparray = array();
			if ( $result = mysql_query($query) )
			{
				while($row_groupuser = @mysql_fetch_object($result))
				{
					$query = "select * from  tbl_group where `id` = '".$row_groupuser->groupid."'";
					$row_group = @mysql_fetch_object(mysql_query($query));
					
					if($row_group)	array_push($grouparray,$row_group);
				}
			}
			
			$query = "select * from  tbl_friend where `userid` = '".$row->user_id."'";
			$friendarray = array();
			if ($result =  mysql_query($query) )
			{
				while($row_friend = @mysql_fetch_object($result))
				{
					$query = "select * from  tbl_user where `user_id` = '".$row_friend->useridto."'";
					$row_user = @mysql_fetch_object(mysql_query($query));
					
					array_push($friendarray,$row_user);
				}
			}
			
			$query = "select * from  tbl_block where `userid` = '".$row->user_id."'";
			$blockarray = array();
			if ($result =  mysql_query($query) )
			{
				while($row_block = @mysql_fetch_object($result))
				{
					$query = "select * from  tbl_user where `user_id` = '".$row_block->useridto."'";
					$row_user = @mysql_fetch_object(mysql_query($query));
					
					array_push($blockarray,$row_user);
				}
			}
			
			$json_data = array("success"=>"1","detail"=>$row,"photoarray"=>$photoarray,"grouparray"=>$grouparray,"friendarray"=>$friendarray,"blockarray"=>$blockarray);
		}
		else
		{
			$json_data = array("success"=>"0","detail"=>"Incorrect Password");
		}
	}
	else
	{
		$json_data = array("success"=>"0","detail"=>"An unknown error occured");
	}
	
	echo json_encode($json_data);
?>