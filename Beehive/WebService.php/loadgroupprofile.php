<?php
	include('./config.php');

	$groupid	= $_REQUEST["groupid"];
	$date		= date( "Y-m-d H:i:s" );
	
	$query = "select * from tbl_group where `id` = '".$groupid."'";

	if ( mysql_query($query) )
	{
		$result = mysql_query($query);
		$row = @mysql_fetch_object($result);
		
		if($row)
		{
			$query = "select * from  tbl_groupphoto where `groupid` = '".$row->id."'";
			$photoarray = array();
			if ( mysql_query($query) )
			{
				$result = mysql_query($query);
				while($row_photo = @mysql_fetch_object($result))
				{
					array_push($photoarray,$row_photo);
				}
			}
			
			$query = "select * from  tbl_groupuser where `groupid` = '".$row->id."' and `status` = '1'";
			$userarray = array();
			if ( mysql_query($query) )
			{
				$result = mysql_query($query);
				while($row_groupuser = @mysql_fetch_object($result))
				{
					$query = "select * from  tbl_user where `user_id` = '".$row_groupuser->userid."'";
					$row_user = @mysql_fetch_object(mysql_query($query));
					
					if($row_user)
						array_push($userarray,$row_user);
				}
			}
			
			$query = "select * from  tbl_groupuser where `groupid` = '".$row->id."' and `status` = '0'";
			$pendingarray = array();
			if ( mysql_query($query) )
			{
				$result = mysql_query($query);
				while($row_groupuser = @mysql_fetch_object($result))
				{
					$query = "select * from  tbl_user where `user_id` = '".$row_groupuser->userid."'";
					$row_user = @mysql_fetch_object(mysql_query($query));
					
					if($row_user)
						array_push($pendingarray,$row_user);
				}
			}
			
			$json_data = array("success"=>"1","detail"=>$row,"photoarray"=>$photoarray,"userarray"=>$userarray,"pending"=>$pendingarray);
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