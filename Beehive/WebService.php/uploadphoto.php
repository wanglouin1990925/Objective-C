<?php
	include('./config.php');

	$photoid		= $_REQUEST["photoid"];
	$userid			= $_REQUEST["userid"];
	$date			= date( "Y-m-d-H-i-s" );
	
	$photo_url 	= "upload/avatar_".$userid."_".$date.".jpg" ;

	if(move_uploaded_file( $_FILES['photo']['tmp_name'], $photo_url ))
	{
		if($photoid == "-1")
			$query = "insert into tbl_userphoto (userid,photo) values (\"$userid\",\"$photo_url\")";			
		else
			$query = "update tbl_userphoto set photo = '".$photo_url."' where `id` = ".$photoid."";

		if(mysql_query($query))
		{
			$query = "select * from  tbl_userphoto where `userid` = '".$userid."'";
			$photoarray = array();
			if ( mysql_query($query) )
			{
				$result = mysql_query($query);
				while($row_photo = @mysql_fetch_object($result))
				{
					array_push($photoarray,$row_photo);
				}
			}
			
			$json_data = array("success"=>"1","photoarray"=>$photoarray);
		}
		else
		{
			$json_data = array("success"=>"0","detail"=>"An unknown error occured");
		}	
	}
	
	echo json_encode($json_data);
?>