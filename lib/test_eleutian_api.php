<?php







$host = "beta-api.eleutian.com";
$user = "13";
$pass = "7ac35bd8ddbd402aae1b55f9389c61cd";
$path = "/v1/students/kingsoft/test_dong_3";
$data_to_send = "FirstName=dogntao&LastName=dogntao&PublicName=dogntao&Email=dogntao@163.com&Locale=zh-Hans&TimeZone=China Standard Time";

$auth = $user.":".$pass; 
$string = base64_encode($auth);
echo $string . "\r\n";


$fp = fsockopen($host,80); 
$t_post = "Post ". $path . " HTTP/1.1";
echo $t_post;
fputs($fp,"Post $path HTTP/1.1"); 
fputs($fp,"Host: $host"); 
fputs($fp,"Authorization: Basic $string"); 
fputs($fp,$data_to_send);
fpassthru($fp);




		// $fp = fsockopen($host,80);
		// if (!$fp) {
		// 	echo "there are error!<br>\n";
		// } else {
		// 	
		// 	echo "POST $path HTTP/1.1\r\n";
		// 	fputs($fp, "POST $path HTTP/1.1\r\n");
		// 	fputs($fp, "Authorization: Basic ".$string."\r\n");
		// 	// fputs($fp, "User-Agent: ".$agent."\n");
		// 	fputs($fp, "Host: $host\n");
		// 	fputs($fp, "Content-type: application/x-www-form-urlencoded\n");
		// 	fputs($fp, "Content-length: ".strlen($data_to_send)."\n");
		// 	// fputs($fp, "Connection: close\n\n");
		// 	fputs($fp, $data_to_send);
		// 	for ($i = 1; $i < 10; $i++){$reply = fgets($fp, 256);}
		// 	echo $reply;
		// 	fclose($fp);
		// }
