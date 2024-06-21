<?php
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, GET, OPTIONS');
header('Access-Control-Allow-Headers: X-Requested-With, Content-Type, Accept');

include("dbconnection.php");
$con = dbconnection();  // Assuming dbconnection() establishes database connection

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (isset($_POST["action"])) {
        $action = $_POST["action"];
        
        if ($action === "login") {
            if (isset($_POST["login_ID"]) && isset($_POST["password"])) {
                $login_ID = $_POST["login_ID"];
                $password = $_POST["password"];
                
                $query = "SELECT * FROM `user` WHERE `login_ID` = '$login_ID' AND `password` = '$password' AND `status` = 'Active'";
                $exe = mysqli_query($con, $query);
                
                if ($exe && mysqli_num_rows($exe) > 0) {
                    $response["success"] = true;
                } else {
                    $response["success"] = false;
                }
                echo json_encode($response);
            } else {
                // Handle missing login_ID or password
                $response["success"] = false;
                $response["message"] = "Missing login_ID or password";
                echo json_encode($response);
            }
        } elseif ($action === "add_user") {
            // Assuming fields are passed via POST for adding a user
            if (isset($_POST["name"]) && isset($_POST["email"]) && isset($_POST["login_ID"])&& isset($_POST["address"])&& isset($_POST["status"])&& isset($_POST["ph_num"]) && isset($_POST["password"])) {
                $name = $_POST["name"];
                $email = $_POST["email"];
                $login_ID = $_POST["login_ID"];
                $password = $_POST["password"];
                $address = $_POST["address"];
                $ph_num=$_POST["ph_num"];
                $status=$_POST["status"];
                
                // You should hash passwords before storing them for security
                // $hashed_password = password_hash($password, PASSWORD_DEFAULT);
                
                $query = "INSERT INTO `user` (`login_ID`, `Name`, `Email`, `Address`, `ph_num`, `Status`, `password`)
                          VALUES ('$login_ID','$name','$email','$address','$ph_num', '$status', '$password')";
                
                $exe = mysqli_query($con, $query);
                
                if ($exe) {
                    $response["success"] = true;
                    $response["message"] = "User added successfully";
                } else {
                    $response["success"] = false;
                    $response["message"] = "Failed to add user";
                }
                echo json_encode($response);
            } 
        } else {
            // Invalid action
            $response["success"] = false;
            $response["message"] = "Invalid action specified";
            echo json_encode($response);
        }
    } else {
        // No action specified
        $response["success"] = false;
        $response["message"] = "No action specified";
        echo json_encode($response);
    }
} else {
    // Invalid request method
    $response["success"] = false;
    $response["message"] = "Invalid request method";
    echo json_encode($response);
}
?>
