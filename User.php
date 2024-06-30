<?php
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, GET, OPTIONS');
header('Access-Control-Allow-Headers: X-Requested-With, Content-Type, Accept');
header('Content-Type: application/json'); // Ensure the response is JSON

include("dbconnection.php");
$con = dbconnection();  // Assuming dbconnection() establishes database connection

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $response = array();

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
                    $response["message"] = "Login failed. Invalid credentials or user is inactive.";
                }
            } else {
                $response["success"] = false;
                $response["message"] = "Missing login_ID or password";
            }
        } elseif ($action === "add_user") {
            if (isset($_POST["name"]) && isset($_POST["email"]) && isset($_POST["login_ID"]) && isset($_POST["address"]) && isset($_POST["status"]) && isset($_POST["ph_num"]) && isset($_POST["password"])) {
                $name = $_POST["name"];
                $email = $_POST["email"];
                $login_ID = $_POST["login_ID"];
                $password = $_POST["password"];
                $address = $_POST["address"];
                $ph_num = $_POST["ph_num"];
                $status = $_POST["status"];

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
            } else {
                $response["success"] = false;
                $response["message"] = "Missing required fields";
            }
        } elseif ($action === "fetch_data") {
            $query = "SELECT * FROM `user`";
            $exe = mysqli_query($con, $query);
            $users = array();

            while ($row = mysqli_fetch_assoc($exe)) {
                $users[] = $row;
            }

            $response["success"] = true;
            $response["data"] = $users;
        } elseif ($action === "update_user") {
            if (isset($_POST["login_ID"]) && isset($_POST["password"])) {
                $login_ID = $_POST["login_ID"];
                $password = $_POST["password"];

                // Check if user exists with provided login_ID and password
                $query_check = "SELECT * FROM `user` WHERE `login_ID` = '$login_ID' AND `password` = '$password'";
                $exe_check = mysqli_query($con, $query_check);

                if ($exe_check && mysqli_num_rows($exe_check) > 0) {
                    // Update user details
                    $name = isset($_POST["name"]) ? $_POST["name"] : '';
                    $email = isset($_POST["email"]) ? $_POST["email"] : '';
                    $address = isset($_POST["address"]) ? $_POST["address"] : '';
                    $ph_num = isset($_POST["ph_num"]) ? $_POST["ph_num"] : '';
                    $status = isset($_POST["status"]) ? $_POST["status"] : '';
                    $password = isset($_POST["password"]) ? $_POST["password"] : '';

                    $query_update = "UPDATE `user` SET 
                                    `Name`='$name', 
                                    `Email`='$email', 
                                    `Address`='$address', 
                                    `ph_num`='$ph_num', 
                                    `Status`='$status', 
                                    `password`='$password' 
                                    WHERE `login_ID`='$login_ID'";

                    $exe_update = mysqli_query($con, $query_update);

                    if ($exe_update) {
                        $response["success"] = true;
                        $response["message"] = "User updated successfully";
                    } else {
                        $response["success"] = false;
                        $response["message"] = "Failed to update user";
                    }
                } else {
                    $response["success"] = false;
                    $response["message"] = "User not found or invalid credentials";
                }
            } else {
                $response["success"] = false;
                $response["message"] = "Missing login_ID or password";
            }
        } elseif ($action === "delete") {
            if (isset($_POST["login_ID"]) && isset($_POST["password"])) {
                $login_ID = $_POST["login_ID"];
                $password = $_POST["password"];

                // Check if user exists with provided login_ID and password
                $query_check = "SELECT * FROM `user` WHERE `login_ID` = '$login_ID' AND `password` = '$password'";
                $exe_check = mysqli_query($con, $query_check);

                if ($exe_check && mysqli_num_rows($exe_check) > 0) {
                    $query_del = "DELETE FROM `user` WHERE `login_ID` = '$login_ID' AND `password` = '$password'";
                    $exe_del = mysqli_query($con, $query_del);

                    if ($exe_del) {
                        $response["success"] = true;
                        $response["message"] = "User deleted successfully";
                    } else {
                        $response["success"] = false;
                        $response["message"] = "Failed to delete user";
                    }
                } else {
                    $response["success"] = false;
                    $response["message"] = "User not found";
                }
            } else {
                $response["success"] = false;
                $response["message"] = "Missing login_ID or password";
            }
        } else {
            $response["success"] = false;
            $response["message"] = "Invalid action specified";
        }
    } else {
        $response["success"] = false;
        $response["message"] = "No action specified";
    }
} else {
    $response["success"] = false;
    $response["message"] = "Invalid request method";
}

echo json_encode($response);
?>
