<?php
	include('./config.php');
	
	$useridfrom	= $_REQUEST["useridfrom"];
	$groupid	= $_REQUEST["groupid"];
	$groupusers	= $_REQUEST["groupusers"];
	$filetype	= $_REQUEST["type"];
	$date		= date( "Y-m-d H:i:s" );
	$date1		= date( "Y-m-d-H-i-s" );	
	
// 	$query = "SELECT * FROM tbl_block WHERE userid = '".$useridto."' and useridto = '".$useridfrom."'";
// 	$row_block = @mysql_fetch_object(mysql_query($query));		
// 	if($row_block)
// 	{
// 		$json_data = array("success"=>"2");
// 		echo json_encode($json_data);
// 		return;
// 	}
	
	if($filetype == "photo")
	{
		$file_url = "photo/photo_".$useridfrom."_".$useridto."_".$date1.".jpg" ;
		$message = "!@#!xyz!@#!".$file_url;
	}
	else if($filetype == "video")
	{
		$file_url = "video/video_".$useridfrom."_".$useridto."_".$date1.".mp4" ;
		$message = "!@!x#yz!@#!".$file_url;
	}
	else if($filetype == "voice")
	{
		$file_url = "voice/voice_".$useridfrom."_".$useridto."_".$date1.".aac" ;
		$message = "!@!xy#z!@#!".$file_url;
	}
	
	$groupusers = ",".$groupusers.",";
	$userarray 	= explode(",", $groupusers);
		
	for ($i = 0; $i < count($userarray); $i++) 
	{
		$userid = $userarray[$i];
		if($userid != "")
		{
			$status = "1";
			if($userid == $useridfrom)
				$status = "0";
				
			$query = "INSERT INTO tbl_gmessage (userid,groupid,useridfrom,message,date,status) values (\"$userid\",\"$groupid\",\"$useridfrom\",\"$message\",\"$date\",\"$status\")";
			mysql_query($query);
			
			$query = "DELETE FROM tbl_glstmsg WHERE userid = '".$userid."' and groupid = '".$groupid."'";
			mysql_query($query);
			
			$query = "INSERT INTO tbl_glstmsg (userid,groupid,useridfrom,message,date) VALUES (\"$userid\",\"$groupid\",\"$useridfrom\",\"$message\",\"$date\")";
			mysql_query($query);
		}
	}
	
	$query = "SELECT * FROM `tbl_gmessage` WHERE userid = '".$useridfrom."' and groupid = '".$groupid."' and date = '".$date."'";
	if ($result = mysql_query($query))
	{
		$row = @mysql_fetch_object($result);
		
		$diff			= abs(strtotime($date) - strtotime($row->date));
		$row->diff		= $diff;	
						
		$json_data = array("success"=>"1","detail"=>$row);
		echo json_encode($json_data);
		
		move_uploaded_file( $_FILES['file']['tmp_name'], $file_url );
	}
	else
	{
		$json_data = array("success"=>"0","detail"=>"Connection Error");
		echo json_encode($json_data);
	}
?>