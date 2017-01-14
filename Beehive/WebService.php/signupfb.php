<?php
	include('./config.php');

	$fbid		= $_REQUEST["fbid"];	
	$phone		= $_REQUEST["phone"];
	$password	= $_REQUEST["password"];
	$username	= $_REQUEST["username"];
	$name		= $_REQUEST["name"];
	$birthday	= $_REQUEST["birthday"];
	$gender		= $_REQUEST["gender"];
	$latitude	= $_REQUEST["latitude"];
	$longitude	= $_REQUEST["longitude"];
	$date		= date( "Y-m-d H:i:s" );
	
	$query 	= "select * from  tbl_user where user_facebookid= '".$fbid."'";
	$nums 	= mysql_num_rows(mysql_query($query));
	if( $nums == 0 )
	{
		$query = "insert into tbl_user (user_phone,user_username,user_name,user_password,user_birthday,user_gender,user_latitude,user_longitude,user_lastonline,user_created,user_avatar,user_coverphoto,user_company,user_university,user_hometown,user_hobbies,user_music,user_books,user_movies,user_looking,user_aboutme,user_facebookid) values ('$phone','$username','$name','$password','$birthday','$gender','$latitude','$longitude','$date','$date','','','','','','','','','','','','$fbid')";
		mysql_query($query);
		
	}	

	$query = "select * from  tbl_user where user_facebookid= '".$fbid."'";
	if ( mysql_query($query) )
	{
		$result = mysql_query($query);
		$row = @mysql_fetch_object($result);
		
		if($row)
		{
			$query = "UPDATE tbl_user SET user_lastonline='".$date."',user_latitude='".$user_latitude."',user_longitude='".$user_longitude."' WHERE `user_facebookid` = ".$fbid."";
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
			$json_data = array("success"=>"0","detail"=>"An unknown error occured");
		}
	}
	else
	{
		$json_data = array("success"=>"0","detail"=>"An unknown error occured");
	}
	
	echo json_encode($json_data);
?>