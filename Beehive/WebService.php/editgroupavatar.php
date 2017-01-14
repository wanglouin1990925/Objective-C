<?php
	include('./config.php');

	$userid		= $_REQUEST["userid"];
	$groupid	= $_REQUEST["groupid"];	
	$date		= date( "Y-m-d-H-i-s" );
	
	$photo_url 	= "upload/avatar_".$userid."_".$date.".jpg" ;

	if(move_uploaded_file( $_FILES['photo']['tmp_name'], $photo_url ))
	{
		$query = "update tbl_group set avatar = '".$photo_url."' where `id` = ".$groupid."";
		if(mysql_query($query))
		{
			$query = "select * from  tbl_group where `id`= '".$groupid."'";
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