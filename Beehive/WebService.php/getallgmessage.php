<?php
	include('./config.php');

	$userid			= $_REQUEST["userid"];
	$groupid 		= $_REQUEST["groupid"];
	$date  			= date( "Y-m-d H:i:s" );
	
	$query = "SELECT * FROM  tbl_gmessage WHERE userid = '".$userid."' and groupid = '".$groupid."'";
	if($result = mysql_query($query))
	{
		$msgarray 	= array();		

// 		$secret_key = "8660281B6051D071D94B5B230549F9DC851566DC";
// 		$iv 		= mcrypt_create_iv(mcrypt_get_iv_size(MCRYPT_RIJNDAEL_256, MCRYPT_MODE_ECB), MCRYPT_RAND);
		
		while($row = @mysql_fetch_object($result))
		{
			$diff		 	= abs(strtotime($date) - strtotime($row->date));
			$row->diff		= $diff;	
// 			$row->message	= mcrypt_decrypt(MCRYPT_RIJNDAEL_256, $secret_key, $row->message, MCRYPT_MODE_CBC, $iv);
	
			array_push($msgarray,$row);
		}
		
		$query = "UPDATE tbl_gmessage SET status='0' WHERE `userid` = '".$userid."' and groupid = '".$groupid."'";
		mysql_query($query);
		
		$json_data = array("success"=>"1","detail"=>$msgarray);
		echo json_encode($json_data );
	}
	else
	{
		$json_data = array("success"=>"0","detail"=>mysql_error());
		echo json_encode($json_data );
	}
?>