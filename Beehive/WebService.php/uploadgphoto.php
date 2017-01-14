<?php
	include('./config.php');

	$userid			= $_REQUEST["userid"];
	$photoid		= $_REQUEST["photoid"];
	$groupid		= $_REQUEST["groupid"];
	$date			= date( "Y-m-d-H-i-s" );
	
	$photo_url 	= "upload/avatar_".$userid."_".$date.".jpg" ;

	if(move_uploaded_file( $_FILES['photo']['tmp_name'], $photo_url ))
	{
		if($photoid == "-1")
			$query = "insert into tbl_groupphoto (groupid,photo) values (\"$groupid\",\"$photo_url\")";			
		else
			$query = "update tbl_groupphoto set photo = '".$photo_url."' where `id` = ".$photoid."";

		if(mysql_query($query))
		{
			$query = "select * from  tbl_groupphoto where `groupid` = '".$groupid."'";
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