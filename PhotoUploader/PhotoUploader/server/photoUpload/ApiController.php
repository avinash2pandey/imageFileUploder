<?php



/*---- change the directory path for upload photo 
 "/Applications/MAMP/htdocs/photoUpload/photo/" 
 according to the your server directory path 
 -----*/
 $uploaddir = '/Applications/MAMP/htdocs/photoUpload/photo/';


$file = basename($_FILES['userfile']['name']);
$uploadfile = $uploaddir . $file;


/*---- change the directory path for log file
 "/Applications/MAMP/htdocs/photoUpload/photo/" 
 according to the your server directory path 
 -----*/
$logFile ='/Applications/MAMP/htdocs/photoUpload/log/log.txt';

$fp = fopen($logFile, 'a');
fwrite($fp, ' start '.$file. ' on '.date('r'));
fclose($fp);


$arr;


//***** start write photo *******//
if (move_uploaded_file($_FILES['userfile']['tmp_name'], $uploadfile)) {

	//echo "OK";
//***** end time write on log file *******//
 	$fp = fopen($logFile, 'a');
 	fwrite($fp, ' end '.$file. ' on '.date('r'));
    fwrite($fp, ' Data receive '.$_FILES["userfile"]["size"]. ' bytes'. ' '.date('r'));
    fclose($fp);
    
    echo json_encode($arr['result'] = "TRUE");
     
} else {
    //echo "ERROR";
    //***** Error time write on log file *******//
 	$fp = fopen($logFile, 'a');
    fwrite($fp, ' error '.$file. 'with '.date('r'));
    fwrite($fp, ' Data receive '.$_FILES["userfile"]["size"] . ' bytes'. ' '.date('r'));
       
    fclose($fp);
    
    echo json_encode($arr['result'] = "FALSE");
}

?>
