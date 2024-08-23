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
$password = $_POST['password'] ?? '';
$locationName = $_POST['locationName'] ?? 'error';
$FW = $_POST['FW'] ?? 'e';
$UWL = $_POST['UWL'] ?? 'e';
$RD = $_POST['RD'] ?? 'e';
$SG = $_POST['SG'] ?? 'e';
$appointmentDateTime = $_POST['appointmentDateTime'] ?? '1900-01-01 00:00';

$sql1 = "SELECT Password FROM DonorID WHERE NIC='$NIC'" ;
$result1 = sqlsrv_query($conn, $sql1);
$row1 = sqlsrv_fetch_array($result1, SQLSRV_FETCH_ASSOC);
$hashedPassword = $row1['Password'];

if (password_verify($password, $hashedPassword)) {
    $sql2 = "INSERT INTO BloodAppointment (NIC, locationName, FW, UWL, RD, SG, appointmentDateTime) VALUES ('$NIC','$locationName','$FW','$UWL','$RD','$SG','$appointmentDateTime')";
    if ($result2 = sqlsrv_query($conn, $sql2))
    {
        echo("success");
    }
    else {
        echo "Query Error: " . print_r(sqlsrv_errors(), true);
    }
} else {
    echo "Failure";
}


 
// Close connections
sqlsrv_close($conn);
?>