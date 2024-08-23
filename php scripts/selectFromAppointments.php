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

$sql = "SELECT * FROM BloodAppointment WHERE NIC='$NIC'";

if ($result = sqlsrv_query($conn, $sql))
{
	// If so, then create a results array and a temporary one
	// to hold the data
	$resultArray = array();
	$tempArray = array();
 
	// Loop through each row in the result set
	while($row = sqlsrv_fetch_array($result, SQLSRV_FETCH_ASSOC))
	{
		// Add each row into our results array
		$tempArray = $row;
	    array_push($resultArray, $tempArray);
	}
 
	// Finally, encode the array to JSON and output the results
	echo json_encode($resultArray);
}
else {
    // Handle query error if necessary
    echo "Query Error: " . print_r(sqlsrv_errors(), true);
}
 
// Close connections
sqlsrv_close($conn);
?>