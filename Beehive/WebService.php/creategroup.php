<?php
	include('./config.php');

	$userid		= $_REQUEST["userid"];
	$title		= mysql_real_escape_string($_REQUEST["name"]);
	$place		= mysql_real_escape_string($_REQUEST["place"]);
	$about		= mysql_real_escape_string($_REQUEST["about"]);
	$latitude	= $_REQUEST["latitude"];
	$longitude	= $_REQUEST["longitude"];
	$date		= date( "Y-m-d H:i:s" );
	$date1		= date( "Y-m-d-H-i-s" );
	
	$query 	= "select * from  tbl_group where title= '".$title."'";
	$nums 	= mysql_num_rows(mysql_query($query));
	if( $nums > 0 )
	{
        $json_data = array("success"=>"0","detail"=>"Group name already exist");
  	    echo json_encode($json_data);
  	    return;
	}
	
	$photo_url 	= "upload/avatar_".$userid."_".$date1.".jpg" ;
	if(move_uploaded_file( $_FILES['photo']['tmp_name'], $photo_url ))
	{
		$query = "insert into tbl_group (title,about,location,latitude,longitude,createrid,date,avatar) values (\"$title\",\"$about\",\"$place\",\"$latitude\",\"$longitude\",\"$userid\",\"$date\",\"$photo_url\")";
		if ( mysql_query($query))
		{
			//Add to User Groups
			$query 		= "SELECT * FROM tbl_group ORDER BY `id` DESC LIMIT 1";
			$row 		= @mysql_fetch_row(mysql_query($query)); 
			$groupid 	= $row[0];
		
			$query = "insert into tbl_groupuser (userid,groupid,date,status) values (\"$userid\",\"$groupid\",\"$date\",'1')";
			mysql_query($query);
			
			//Fetch User Groups
			$query = "select * from  tbl_groupuser where `userid` = '".$userid."' and `status` = '1'";
			$grouparray = array();

			$result = mysql_query($query);
			while($row_groupuser = @mysql_fetch_object($result))
			{
				$query = "select * from  tbl_group where `id` = '".$row_groupuser->groupid."'";
				$row_group = @mysql_fetch_object(mysql_query($query));
					
				if($row_group)
					array_push($grouparray,$row_group);
			}
			
			$json_data = array("success"=>"1","detail"=>$grouparray);
			echo json_encode($json_data);
		}
		else
		{
			$json_data = array("success"=>"0","detail"=>"An unknown error occured");
			echo json_encode($json_data);
		}
	}
	else
	{
		$json_data = array("success"=>"0","detail"=>"An unknown error occured");
		echo json_encode($json_data);
	}
?>