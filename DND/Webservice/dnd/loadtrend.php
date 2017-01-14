<?php
	include('./config.php');

	$date		= date( "Y-m-d H:i:s" );
	$userfbid	= $_REQUEST["userfbid"];

	//World Wide
// 	$query 	= "select * from  tbl_user as t1 join (select rat_userfbidto, count(*) as cnt from tbl_rate where rat_userfbidto != '".$userfbid."' group by rat_userfbidto order by cnt DESC limit 100) as t2 on t2.rat_userfbidto = t1.user_facebookid";
	
	$query 	= "select * from  tbl_user as t1 join (select rat_userfbidto, count(*) as cnt from tbl_rate where rat_userfbidto != '".$userfbid."' group by rat_userfbidto order by cnt DESC) as t2 on t2.rat_userfbidto = t1.user_facebookid";
	
// 	$query 	= "select * from  tbl_user where `user_facebookid`!='".$userfbid."'";
	
	if ( mysql_query($query) )
	{
		$result = mysql_query($query);
		$userarray = array();
		
		while($row = @mysql_fetch_object($result))
		{
			$query = "select * from tbl_rate where `rat_userfbidto` = '".$row->user_facebookid."' order by rat_date DESC";
			$result_rate = mysql_query($query);
		
			$totalscore = 0;
			$scorecount = 0;
			
			$ratearray = array();
			while($row_rate = @mysql_fetch_object($result_rate))
			{
				$totalscore = $totalscore + $row_rate->rat_score;
				$scorecount = $scorecount + 1;
				
				//Get Difference
				$diff = abs(strtotime($date) - strtotime($row_rate->rat_date));
				$row_rate->timediff = $diff;
						
				array_push($ratearray,$row_rate);
			}
			
			if($scorecount !=0 )
				$totalscore = $totalscore/$scorecount;
			
			$row->rate = $totalscore;
			$row->comments = $ratearray;
			
			array_push($userarray,$row);
		}
		
		$json_data = array("success"=>"1","detail"=>$userarray);
	}
	else
	{
		$json_data = array("success"=>"0","detail"=>"An unknown error occured");
	}
	
	echo json_encode($json_data);
?>