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


$NIC = $_POST['NIC'] ?? '';
$password = $_POST['password'] ?? '';

$sql = "SELECT Password FROM DonorID WHERE NIC='$NIC'" ;
$result = sqlsrv_query($conn, $sql);
$row = sqlsrv_fetch_array($result, SQLSRV_FETCH_ASSOC);
$hashedPassword = $row['Password'];



if (password_verify($password, $hashedPassword)) {
    echo "success";
} else {
    echo "Failure";
}


sqlsrv_close($conn);

?>