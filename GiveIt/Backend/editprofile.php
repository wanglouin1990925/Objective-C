<?php
	include('./config.php');

	$query		= $_REQUEST["query"];
	$photo  	= $_REQUEST["photo"];
	$userid  	= $_REQUEST["userid"];
	$date		= date( "Y-m-d-H-i-s" );
	
	if($photo)
	{
		$photo_url = "upload/avatar_".$userid."_".$date.".jpg" ;
		if(move_uploaded_file( $_FILES['photo']['tmp_name'], $photo_url ))
		{
			$query = "UPDATE tbl_user SET ".$query.",user_avatar='".$photo_url."' WHERE `index` = ".$userid."";
			if(mysql_query($query))
			{
				$query = "select * from  tbl_user where `index` = '".$userid."'";
				$result = mysql_query($query);
				$row = @mysql_fetch_object($result);
	
				$profile = array();
				$profile = $row;
	
				$json_data = array("success"=>"1","detail"=>$profile,"query"=>$query);
			}
			else
			{
				$json_data = array("success"=>"0","detail"=>"Connection Error","query"=>$query);
			}
		}else
		{
			$json_data = array("success"=>"0","detail"=>"Connection Error","query"=>$query);
		}
	}
	else
	{
		$query = "UPDATE tbl_user SET ".$query." WHERE `index` = ".$userid."";
		if(mysql_query($query))
		{
			$query = "select * from  tbl_user where `index` = ".$userid."";
			$result = mysql_query($query);
			$row = @mysql_fetch_object($result);
	
			$profile = array();
			$profile = $row;
	
			$json_data = array("success"=>"1","detail"=>$profile,"query"=>$query);
		}
		else
		{
			$json_data = array("success"=>"0","detail"=>"Connection Error","query"=>$query);
		}
	}
	
	echo json_encode($json_data);
?>