<?php
	include('./config.php');

	$userid		= $_REQUEST["userid"];
	$username	= $_REQUEST["username"];
	$name		= $_REQUEST["name"];
	$birthday	= $_REQUEST["birthday"];
	$gender		= $_REQUEST["gender"];
	$about		= mysql_real_escape_string($_REQUEST["about"]);
	$company	= mysql_real_escape_string($_REQUEST["company"]);
	$university	= mysql_real_escape_string($_REQUEST["university"]);
	$hometown	= mysql_real_escape_string($_REQUEST["hometown"]);
	$hobbies	= mysql_real_escape_string($_REQUEST["hobbies"]);
	$music		= mysql_real_escape_string($_REQUEST["music"]);
	$books		= mysql_real_escape_string($_REQUEST["books"]);
	$movies		= mysql_real_escape_string($_REQUEST["movies"]);
	$looking	= mysql_real_escape_string($_REQUEST["looking"]);
	$date		= date( "Y-m-d H:i:s" );	

	$query = "update tbl_user set user_company = '".$company."',user_university = '".$university."',user_hometown = '".$hometown."',user_hobbies = '".$hobbies."',user_music = '".$music."',user_books = '".$books."',user_movies = '".$movies."',user_username = '".$username."',user_looking = '".$looking."',user_name = '".$name."',user_birthday = '".$birthday."',user_gender = '".$gender."',user_aboutme = '".$about."' where `user_id` = ".$userid."";
	if(mysql_query($query))
	{
		$query = "select * from  tbl_user where `user_id`= '".$userid."'";
		$row = @mysql_fetch_object( mysql_query($query));		
		
		$json_data = array("success"=>"1","detail"=>$row);
	}
	else
	{
		$json_data = array("success"=>"0","detail"=>$query);
	}	

	echo json_encode($json_data);
?>