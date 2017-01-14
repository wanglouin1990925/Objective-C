<?php
	include('./config.php');

	$userid		= $_REQUEST["userid"];
	$date		= date( "Y-m-d H:i:s" );
	
	if($userid == "-1")
	{
		$json_data = array("success"=>"0");
		echo json_encode($json_data);
		
		return;
	}
	
	//Individual Chat
	$query = "SELECT * FROM tbl_lstmsg WHERE userid = '".$userid."'";
	$result = mysql_query($query);

	$lstmsgarray 	= array();
	while($row = @mysql_fetch_object($result))
	{
		$query = "SELECT * FROM tbl_user WHERE user_id = '".$row->useridto."'";
		$row_user =  @mysql_fetch_object(mysql_query($query));
		
		$diff 			= abs(strtotime($date) - strtotime($row->date));		
		$row->diff		= $diff;			
		$row->userinfo 	= $row_user;
		
		$query = "SELECT * FROM tbl_inbound WHERE userid = '".$userid."' and useridto = '".$row->useridto."'";
		$row_inbound =  @mysql_fetch_object(mysql_query($query));
		$row->sent = $row_inbound->sent;
		
		$query = "SELECT * FROM tbl_block WHERE userid = '".$userid."' and useridto = '".$row->useridto."'";
		$row_block = @mysql_fetch_object(mysql_query($query));		
		
		if(!$row_block && $row_user)
			array_push($lstmsgarray,$row);
	}
	
	$query = "SELECT * FROM  tbl_message WHERE userid = '".$userid."' and useridto = '".$userid."' and status = '1' order by useridfrom ASC";
	$result = mysql_query($query);
	
	$msgarray 	= array();
	while($row = @mysql_fetch_object($result))
	{
		$diff 			= abs(strtotime($date) - strtotime($row->date));		
		$row->diff		= $diff;
					
		array_push($msgarray,$row);
	}
	
	//Group Chat
	$query = "SELECT * FROM tbl_glstmsg WHERE userid = '".$userid."'";
	$result = mysql_query($query);

	$lstgmsgarray 	= array();
	while($row = @mysql_fetch_object($result))
	{
		$query = "SELECT * FROM tbl_group WHERE id = '".$row->groupid."'";
		$row_group =  @mysql_fetch_object(mysql_query($query));
	
		if($row_group)
		{
			$diff 			= abs(strtotime($date) - strtotime($row->date));		
			$row->diff		= $diff;	
			$row->groupinfo = $row_group;
		
			$query = "SELECT * FROM tbl_groupuser WHERE groupid = '".$row->groupid."' and status = '1'";
			$result_guser = mysql_query($query);
		
			$userarray = array();
			while($row_guser = @mysql_fetch_object($result_guser))
			{
				$query = "SELECT * FROM tbl_user WHERE user_id = '".$row_guser->userid."'";
				$row_user =  @mysql_fetch_object(mysql_query($query));
			
				if($row_user)
					array_push($userarray,$row_user);
			}
		
			$row->groupusers = $userarray;
			array_push($lstgmsgarray,$row);
		}
	}
	
	$query = "SELECT * FROM  tbl_gmessage WHERE userid = '".$userid."' and status = '1' order by groupid ASC";
	$result = mysql_query($query);
	
	$gmsgarray 	= array();
	while($row = @mysql_fetch_object($result))
	{
		$query = "SELECT * FROM  tbl_group WHERE id = '".$row->groupid."'";
		$row_group = @mysql_fetch_object(mysql_query($query));
		
		if($row_group)
		{
			$diff 			= abs(strtotime($date) - strtotime($row->date));		
			$row->diff		= $diff;
					
			array_push($gmsgarray,$row);
		}
	}
	
	$query = "SELECT * FROM  tbl_group WHERE createrid = '".$userid."'";
	$result = mysql_query($query);
	
	$requestarray 	= array();
	while($row = @mysql_fetch_object($result))
	{		
		$query = "SELECT * FROM  tbl_groupuser WHERE groupid = '".$row->id."' and status = '0'";
		$result_request = mysql_query($query);
		
		while($row_request = @mysql_fetch_object($result_request))
		{
			array_push($requestarray,$row_request);
		}
	}
	
	//Get Group List
	$query = "select * from  tbl_groupuser where `userid` = '".$userid."' and `status` = '1'";
	
	$grouparray = array();
	if ( $result = mysql_query($query) )
	{
		while($row_groupuser = @mysql_fetch_object($result))
		{
			$query = "select * from  tbl_group where `id` = '".$row_groupuser->groupid."'";
			$row_group = @mysql_fetch_object(mysql_query($query));
			
			if($row_group)
				array_push($grouparray,$row_group);
		}
	}
	
	$json_data = array("success"=>"1","income"=>$msgarray,"chats"=>$lstmsgarray,"gincome"=>$gmsgarray,"gchats"=>$lstgmsgarray,"requests"=>$requestarray,"groups"=>$grouparray);
	echo json_encode($json_data);
?>