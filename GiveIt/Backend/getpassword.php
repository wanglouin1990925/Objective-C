<?php
	include('./config.php');
	
	$user_email= $_REQUEST["email"];

	$query = "select * from tbl_user where user_email = '".$user_email."'";
	
	$nums = mysql_num_rows(mysql_query($query));
	if( $nums > 0 )
	{
	    	$row = @mysql_fetch_object(mysql_query($query));
   		$password = $row->user_password;

		$to = $email;
		$subject = "From SNTE Support.";
		$body = "Your Password is '".$password."'";
	
	
		if (mail($to, $subject, $body)) {
			$json_data = array("success"=>"2");
		}else {
			$json_data = array("success"=>"1","detail"=>"Wrong Email Address");
		}
	    echo json_encode($json_data);
	}
	else
	{
	    $json_data = array("success"=>"0","detail"=>"Email does not exist");
  	    echo json_encode($json_data);
	}
?>