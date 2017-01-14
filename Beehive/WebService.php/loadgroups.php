<?php
	include('./config.php');

	$date			= date( "Y-m-d H:i:s" );
	$offset			= $_REQUEST["offset"];
	$latitude		= $_REQUEST["latitude"];
	$longitude		= $_REQUEST["longitude"];
	
	// $sf = 3.141592/180;
// 	$query = "select * from tbl_group order by ACOS(SIN(latitude*".$sf.")*SIN(".$latitude."*".$sf.") + COS(latitude*".$sf.")*COS(".$latitude."*".$sf.")*COS((longitude-".$longitude.")*".$sf.")) limit ".$offset.",50";

	$query = "SELECT *,111.045* DEGREES(ACOS(COS(RADIANS(latpoint))*COS(RADIANS(latitude))*COS(RADIANS(longpoint)-RADIANS(longitude))+SIN(RADIANS(latpoint))*SIN(RADIANS(latitude)))) AS distance_in_km FROM tbl_group JOIN (SELECT  ".$latitude."  AS latpoint,  ".$longitude." AS longpoint) AS p ON 1=1 ORDER BY distance_in_km LIMIT ".$offset.",50";
	
	
	if ( mysql_query($query) )
	{
		$result = mysql_query($query);
		$grouparray = array();
		
		while($row = @mysql_fetch_object($result))
		{
			$query = "select * from  tbl_groupuser where groupid = '".$row->id."'";
			$nums = mysql_num_rows(mysql_query($query));
	
			$row->members = $nums;
			array_push($grouparray,$row);
		}
		
		$json_data = array("success"=>"1","detail"=>$grouparray);
	}
	else
	{
		$json_data = array("success"=>"0","detail"=>"An unknown error occured","query"=>$query);
	}
	
	echo json_encode($json_data);
?>