<?php
	include('./config.php');

	$date			= date( "Y-m-d H:i:s" );
	$userid			= $_REQUEST["userid"];
	$offset			= $_REQUEST["offset"];
	$latitude		= $_REQUEST["latitude"];
	$longitude		= $_REQUEST["longitude"];
	
	$query = "SELECT *,111.045* DEGREES(ACOS(COS(RADIANS(latpoint))*COS(RADIANS(user_latitude))*COS(RADIANS(longpoint)-RADIANS(user_longitude))+SIN(RADIANS(latpoint))*SIN(RADIANS(user_latitude)))) AS distance_in_km FROM tbl_user JOIN (SELECT  ".$latitude."  AS latpoint,  ".$longitude." AS longpoint) AS p ON 1=1 ORDER BY distance_in_km LIMIT ".$offset.",50";
				 
// 	$sf = 3.141592/180;
// 	$query = "select * from tbl_user where `user_id` <> '".$userid."' order by ACOS(SIN(user_latitude*".$sf.")*SIN(".$latitude."*".$sf.") + COS(user_latitude*".$sf.")*COS(".$latitude."*".$sf.")*COS((user_longitude-".$longitude.")*".$sf.")) limit ".$offset.",50";
// 	$query = "select * from tbl_user order by ACOS(SIN(user_latitude*".$sf.")*SIN(".$latitude."*".$sf.") + COS(user_latitude*".$sf.")*COS(".$latitude."*".$sf.")*COS((user_longitude-".$longitude.")*".$sf.")) limit ".$offset.",50";
	
	if ( mysql_query($query) )
	{
		$result = mysql_query($query);
		$userarray = array();
		
		while($row = @mysql_fetch_object($result))
		{
			//Get Last Login
			$diff = abs(strtotime($date) - strtotime($row->user_lastonline));
			$row->lastlogin = $diff;
						
			array_push($userarray,$row);
		}
		
		$json_data = array("success"=>"1","detail"=>$userarray,"query"=>$query);
	}
	else
	{
		$json_data = array("success"=>"0","detail"=>"An unknown error occured","query"=>$query);
	}
	
	echo json_encode($json_data);
?>