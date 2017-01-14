<?php
	include('./config.php');

	$user_username	= $_REQUEST["username"];
	$user_password	= $_REQUEST["password"];
	$user_email	= $_REQUEST["email"];
	
	$query = "select * from  tbl_user where user_username= '".$user_username."'";
	$nums = mysql_num_rows(mysql_query($query));
	if( $nums > 0 )
	{
            $json_data = array("success"=>"0","detail"=>"Username already exist");
  	    echo json_encode($json_data);
  	    return;
	}
	
	$query = "select * from  tbl_user where user_email= '".$user_email."'";
	$nums = mysql_num_rows(mysql_query($query));
	if( $nums > 0 )
	{
            $json_data = array("success"=>"0","detail"=>"Email Address already exist");
  	    echo json_encode($json_data);
  	    return;
	}
	
	$query = "insert into tbl_user (user_username,user_password,user_email) values (\"$user_username\",\"$user_password\",\"$user_email\")";

	if ( mysql_query($query) )
	{
		//Upload Avatar
		$date= date( "Y-m-d-H-i-s" );
		
		$query = "SELECT * FROM tbl_user ORDER BY `index` DESC LIMIT 1";
		$result = mysql_query($query);
		$row = @mysql_fetch_row($result); 
		$user_id = $row[0];
		
		$photo_url = "upload/avatar_".$user_id."_".$date.".jpg" ;

		if(move_uploaded_file( $_FILES['photo']['tmp_name'], $photo_url ))
		{
			$query = "UPDATE tbl_user SET user_avatar='".$photo_url."' WHERE `index` = ".$user_id."";
			mysql_query($query);
			
			$profile["user_avatar"] = $photo_url;
		}
	
		//Get Profile Avatars
		$query = "select * from  tbl_user where `index` = '".$user_id."'";
		$result = mysql_query($query);
		$row = @mysql_fetch_object($result);
		
		$profile = array();
		$profile = $row;
		
		$json_data = array("success"=>"1","detail"=>$profile);
		echo json_encode($json_data);
	}
	else
	{
		$json_data = array("success"=>"0","detail"=>"Connection Error");
		echo json_encode($json_data);
	}
?>