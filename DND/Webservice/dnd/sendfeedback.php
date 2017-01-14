<?php
	$feedback= $_REQUEST["feedback"];

	$to 		= "xiaomin90925@gmail.com";
	$subject 	= "Feedback";
	$body 		= $feedback;

	mail($to, $subject, $body);
?>