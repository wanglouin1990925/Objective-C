<?php
	include('./config.php');

	$userid		= $_REQUEST["userid"];
	$type		= $_REQUEST["type"];
	$date		= date( "Y-m-d-H-i-s" );
	
	$photo_url 	= "upload/avatar_".$userid."_".$date.".jpg" ;

	if(move_uploaded_file( $_FILES['photo']['tmp_name'], $photo_url ))
	{
		if($type == "avatar")
			$query = "update tbl_user set user_avatar = '".$photo_url."' where `user_id` = ".$userid."";
		else
			$query = "update tbl_user set user_coverphoto = '".$photo_url."' where `user_id` = ".$userid."";

		if(mysql_query($query))
		{
			$query = "select * from  tbl_user where `user_id`= '".$userid."'";
			$row = @mysql_fetch_object( mysql_query($query));		
		
			$json_data = array("success"=>"1","detail"=>$row);		
		}
		else
		{
			$json_data = array("success"=>"0","detail"=>"An unknown error occured");
		}	
	}
	
	echo json_encode($json_data);
?>