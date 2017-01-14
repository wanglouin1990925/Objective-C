<?php
	include('./config.php');
	
	$phoneinput= $_REQUEST["phone"];  
	$extracharacters=array('+','-');
	$phone=str_replace($extracharacters,"",$phoneinput);
        $query = "select * from tbl_user where user_phone = '".$phone."'";
	
	$nums = mysql_num_rows(mysql_query($query));
	if( $nums > 0 )
	{
	    	$row = @mysql_fetch_object(mysql_query($query));
   		$password = $row->user_password;
		
		$json_data = array("success"=>"1","detail"=>$password);
	    	echo json_encode($json_data);
	}
	else
	{
	    $json_data = array("success"=>"0","detail"=>"Phone does not exist");
  	    echo json_encode($json_data);
	}
?>