<?php
	include('./config.php');

	$userid			= $_REQUEST["userid"];
	$useridto 		= $_REQUEST["useridto"];
	$date  			= date( "Y-m-d H:i:s" );
	
	$query = "SELECT * FROM  tbl_message WHERE userid = '".$userid."' and (useridfrom = '".$useridto."' or useridto = '".$useridto."')";
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
		
		$query = "UPDATE tbl_message SET status='0' WHERE `userid` = '".$userid."' and (useridfrom = '".$useridto."' or useridto = '".$useridto."')";
		mysql_query($query);
		
		$block = "0";
		$query = "select * from  tbl_block where useridto= '".$userid."' and userid= '".$useridto."'";
		$row = @mysql_fetch_object(mysql_query($query));		
		if($row)
		{
			$block = "1";
		}
		
		$blocking = "0";
		$query = "select * from  tbl_block where useridto= '".$useridto."' and userid= '".$userid."'";
		$row = @mysql_fetch_object(mysql_query($query));		
		if($row)
		{
			$blocking = "1";
		}
		
		$json_data = array("success"=>"1","detail"=>$msgarray,"block"=>$block,"blocking"=>$blocking);
		echo json_encode($json_data );
	}
	else
	{
		$json_data = array("success"=>"0","detail"=>mysql_error());
		echo json_encode($json_data );
	}
?>