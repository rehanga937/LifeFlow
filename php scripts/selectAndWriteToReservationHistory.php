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
$DonationPlace = $_POST['DonationPlace'] ?? 'error';
$DonationDate = $_POST['DonationDate'] ?? '1901-01-01';
$BloodProgress = $_POST['BloodProgress'] ?? 'error';


$sql = "INSERT INTO reservationHistory VALUES
('$NIC','$DonationPlace','$DonationDate' , '$BloodProgress')";


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