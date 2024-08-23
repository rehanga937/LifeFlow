<?php
$serverName = "HAMMERHEAD-PC";
$connectionOptions = [
    "Database"=>"LifeFlow",
    "Uid"=>"",
    "PWD"=>""
];
$conn = sqlsrv_connect($serverName,$connectionOptions);
if($conn == false)
    die(print_r(sqlsrv_errors(),true));


$NIC = $_POST['NIC'] ?? 'error';
$FullName = $_POST['FullName'] ?? 'error';
$Email = $_POST['Email'] ?? 'error';
$DOB = $_POST['DOB'] ?? '1001-01-01';
$Sex = $_POST['Sex'] ?? 'e';
$Password = $_POST['Password'] ?? 'error';
$secure_pass = password_hash($Password, PASSWORD_BCRYPT);
$ABO = $_POST['ABO'] ?? 'E';
$RHD = $_POST['RHD'] ?? 'e';
$ADL1 = $_POST['ADL1'] ?? 'error';
$ADL2 = $_POST['ADL2'] ?? 'error';
$ADL3 = $_POST['ADL3'] ?? 'error';
$MobileNo = $_POST['MobileNo'] ?? '111111111';
$DonateFreq = $_POST['DonateFreq'] ?? '0';
$WishToBeContacted = $_POST['WishToBeContacted'] ?? 'e';

$sql = "INSERT INTO DonorID (NIC, FullName, Email, DOB, Sex, Password, ABO,RHD,AddressLine1,AddressLine2,AddressLine3,MobileNo, DonateFreq,WishToBeContacted) VALUES ('$NIC','$FullName','$Email','$DOB','$Sex','$secure_pass','$ABO','$RHD','$ADL1','$ADL2','$ADL3',$MobileNo,$DonateFreq,'$WishToBeContacted')";


if ($result = sqlsrv_query($conn, $sql))
{
	echo("success");
}
else {
    echo "Query Error: " . print_r(sqlsrv_errors(), true);
}
 
// Close connections
sqlsrv_close($conn);
?>