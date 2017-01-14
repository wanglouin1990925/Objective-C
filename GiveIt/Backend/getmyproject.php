<?php
	include('./config.php');

	$userid		= $_REQUEST["userid"];

	$query = "select * from  tbl_project where userid = '".$userid."'";
	$result = mysql_query($query);

	if($result)
	{
		$projectarray = array();
		
		while($row = @mysql_fetch_object($result))
		{
			$project = array();
			$project = $row;
					
			array_push($projectarray,$project);
		}
		$json_data = array("success"=>"1","detail"=>$projectarray);
	}
	else
	{
		$json_data = array("success"=>"0","detail"=>"Connection Error");
	}
		
	echo json_encode($json_data);
?>