<?php
	include('./config.php');

	$phone		= $_REQUEST["phone"];
	$password	= $_REQUEST["password"];
	$username	= $_REQUEST["username"];
	$name		= $_REQUEST["name"];
	$birthday	= $_REQUEST["birthday"];
	$gender		= $_REQUEST["gender"];
	$latitude	= $_REQUEST["latitude"];
	$longitude	= $_REQUEST["longitude"];
	$date		= date( "Y-m-d H:i:s" );
	
	$query 	= "select * from  tbl_user where user_phone= '".$phone."'";
	$nums 	= mysql_num_rows(mysql_query($query));
	if( $nums > 0 )
	{
        $json_data = array("success"=>"0","detail"=>"Phone number already exist");
  	    echo json_encode($json_data);
  	    return;
	}
	
	$query = "select * from  tbl_user where user_username= '".$username."'";
	$nums = mysql_num_rows(mysql_query($query));
	if( $nums > 0 )
	{
        $json_data = array("success"=>"0","detail"=>"Username already exist");
  	    echo json_encode($json_data);
  	    return;
	}
	
	$query = "insert into tbl_user (user_phone,user_username,user_name,user_password,user_birthday,user_gender,user_latitude,user_longitude,user_lastonline,user_created,user_avatar,user_coverphoto,user_company,user_university,user_hometown,user_hobbies,user_music,user_books,user_movies,user_looking,user_aboutme) values ('$phone','$username','$name','$password','$birthday','$gender','$latitude','$longitude','$date','$date','','','','','','','','','','','')";

	if ( mysql_query($query) )
	{
		//Upload Avatar
		$date		= date( "Y-m-d-H-i-s" );
		
		$query 		= "SELECT * FROM tbl_user ORDER BY `user_id` DESC LIMIT 1";
		$result 	= mysql_query($query);
		$row 		= @mysql_fetch_row($result); 
		$user_id 	= $row[0];
		
		$photo_url 	= "upload/avatar_".$user_id."_".$date.".jpg" ;

		if(move_uploaded_file( $_FILES['photo']['tmp_name'], $photo_url ))
		{
			$query = "UPDATE tbl_user SET user_avatar='".$photo_url."' WHERE `user_id` = ".$user_id."";
			mysql_query($query);
		}
	
		//Return User Profile
		$query 	= "select * from  tbl_user where `user_id` = '".$user_id."'";
		$result = mysql_query($query);
		$row 	= @mysql_fetch_object($result);
		
		$json_data = array("success"=>"1","detail"=>$row);
		echo json_encode($json_data);
	}
	else
	{
		$json_data = array("success"=>"0","detail"=>"An unknown error occured","query"=>$query);
		echo json_encode($json_data);
	}
?>