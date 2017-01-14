<?php
	include('./config.php');

	$projectid	= $_REQUEST["projectid"];
	$daynumber	= $_REQUEST["daynumber"];
	$date		= $_REQUEST["date"];
	
	$videourl = "upload/video/video_".$projectid."_".$daynumber.".mp4" ;
	$photourl = "upload/thumb/thumb_".$projectid."_".$daynumber.".jpg" ;

	if(move_uploaded_file( $_FILES['photo']['tmp_name'], $photourl ))
	{
		if(move_uploaded_file( $_FILES['video']['tmp_name'], $videourl ))
		{
			$query = "insert into tbl_post (projectid,daynumber,date,videourl) values (\"$projectid\",\"$daynumber\",\"$date\",\"$videourl\")";
			if ( mysql_query($query) )
			{
				$json_data = array("success"=>"1","detail"=>"Success");
			}
			else
			{
				$json_data = array("success"=>"0","detail"=>"Connection Error");
			}
		}
		else
		{
			$json_data = array("success"=>"0","detail"=>"Connection Error");
		}
	}
	else
	{
		$json_data = array("success"=>"0","detail"=>"Connection Error");
	}
	
	echo json_encode($json_data);
?>