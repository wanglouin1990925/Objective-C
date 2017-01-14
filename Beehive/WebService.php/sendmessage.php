<?php
	include('./config.php');

	$useridfrom	= $_REQUEST["useridfrom"];
	$useridto	= $_REQUEST["useridto"];
	$message	= $_REQUEST["message"];
	$date		= date( "Y-m-d H:i:s" );
	
// 	$secret_key 	= "8660281B6051D071D94B5B230549F9DC851566DC";
// 	$iv 			= mcrypt_create_iv(mcrypt_get_iv_size(MCRYPT_RIJNDAEL_256, MCRYPT_MODE_ECB), MCRYPT_RAND);		
// 	$message 		= mcrypt_encrypt(MCRYPT_RIJNDAEL_256, $secret_key, $message, MCRYPT_MODE_CBC, $iv);
	
	$query = "SELECT * FROM tbl_block WHERE userid = '".$useridto."' and useridto = '".$useridfrom."'";
	$row_block = @mysql_fetch_object(mysql_query($query));		
	if($row_block)
	{
		$json_data = array("success"=>"2");
		echo json_encode($json_data);
		return;
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
		
		//Send Push
		// $query = "SELECT * FROM tbl_block where blk_from='".$userto."' and blk_to='".$userfrom."'";			
// 		if(mysql_num_rows(mysql_query($query)) == 0)
// 		{
// 			$APPLICATION_ID = "AS6tX9n4nTKYfHvgZPHBfUF2OJIS6Dm7d3xvgvio";
// 			$REST_API_KEY 	= "13OEuCobmCIQRnzxpYd28TOZ7bUVgZDoCj8v11hX";
// 			$MESSAGE 		= $message;
// 			
// 			$url = 'https://api.parse.com/1/push';
// 			$data = array(
// 			  'type' => 'ios',
// 			  'expiry' => 1451606400,
// 			  'where' => array(
//                   'owner' => $userto,
//                 ),
// 			  'data' => array(
// 				 'alert' => $MESSAGE,
// 				 'sound' => 'push.caf',
// 			  ),
// 			);
// 			$_data = json_encode($data);
// 			$headers = array(
// 			  'X-Parse-Application-Id: ' . $APPLICATION_ID,
// 			  'X-Parse-REST-API-Key: ' . $REST_API_KEY,
// 			  'Content-Type: application/json',
// 			  'Content-Length: ' . strlen($_data),
// 			);
// 
// 			$curl = curl_init($url);
// 			curl_setopt($curl, CURLOPT_POST, 1);
// 			curl_setopt($curl, CURLOPT_POSTFIELDS, $_data);
// 			curl_setopt($curl, CURLOPT_HTTPHEADER, $headers);
// 			curl_setopt($curl, CURLOPT_RETURNTRANSFER,1);
// 			curl_exec($curl);
// 		}
		//

	}
	else
	{
		$json_data = array("success"=>"0","detail"=>"Connection Error");
		echo json_encode($json_data);
	}
?>