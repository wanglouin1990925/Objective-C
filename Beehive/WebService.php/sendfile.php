<?php
	include('./config.php');
	
	$useridfrom	= $_REQUEST["useridfrom"];
	$useridto	= $_REQUEST["useridto"];
	$filetype	= $_REQUEST["type"];
	$date		= date( "Y-m-d H:i:s" );
	$date1		= date( "Y-m-d-H-i-s" );	
	
	$query = "SELECT * FROM tbl_block WHERE userid = '".$useridto."' and useridto = '".$useridfrom."'";
	$row_block = @mysql_fetch_object(mysql_query($query));		
	if($row_block)
	{
		$json_data = array("success"=>"2");
		echo json_encode($json_data);
		return;
	}
	
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
	
	$query = "INSERT INTO tbl_message (userid,useridfrom,useridto,message,date,status) values (\"$useridto\",\"$useridfrom\",\"$useridto\",\"$message\",\"$date\",'1')";
	
	if (mysql_query($query))
	{
		//Update Last Message Table
		$query = "DELETE FROM `tbl_lstmsg` WHERE (userid = '".$useridfrom."' and useridto = '".$useridto."') or (userid = '".$useridto."' and useridto = '".$useridfrom."')";
		mysql_query($query);
		
		$query = "INSERT INTO `tbl_lstmsg`(userid, useridto, message, direction ,date) VALUES (\"$useridfrom\",\"$useridto\",\"$message\",'1',\"$date\")";
		mysql_query($query);
		
		$query = "INSERT INTO `tbl_lstmsg`(userid, useridto, message, direction ,date) VALUES (\"$useridto\",\"$useridfrom\",\"$message\",'2',\"$date\")";
		mysql_query($query);
		//------------------
		
		$query = "INSERT INTO tbl_message (userid,useridfrom,useridto,message,date,status) values (\"$useridfrom\",\"$useridfrom\",\"$useridto\",\"$message\",\"$date\",'0')";
		mysql_query($query);
	
		$query = "SELECT * FROM `tbl_message` WHERE userid = '".$useridfrom."' and useridfrom = '".$useridfrom."' and useridto = '".$useridto."' and date = '".$date."'";
		$row = @mysql_fetch_object(mysql_query($query));
		
		$diff			= abs(strtotime($date) - strtotime($row->date));
		$row->diff		= $diff;	
						
		//Inbound
		$query = "SELECT * FROM tbl_inbound WHERE userid = '".$useridfrom."' and useridto = '".$useridto."'";
		$row_inbound = @mysql_fetch_object(mysql_query($query));
		
		if($row_inbound)
		{
			if(!$row_inbound->sent)
			{
				$query = "UPDATE tbl_inbound set sent='1' where userid = '".$useridfrom."' and useridto = '".$useridto."'";
				mysql_query($query);
			}
		}
		else
		{
			$query = "INSERT INTO tbl_inbound (userid,useridto,sent,received) values (\"$useridfrom\",\"$useridto\",'1','0')";
			mysql_query($query);
			
			$query = "INSERT INTO tbl_inbound (userid,useridto,sent,received) values (\"$useridto\",\"$useridfrom\",'0','1')";
			mysql_query($query);
		}
		//-----------------				
		
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