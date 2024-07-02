<?php
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, GET, OPTIONS');
header('Access-Control-Allow-Headers: X-Requested-With, Content-Type, Accept');
header('Content-Type: application/json'); // Ensure the response is JSON

include("dbconnection.php");
$con = dbconnection();  // Assuming dbconnection() establishes database connection

$response = array();

// Check if the request method is POST
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (isset($_POST["action"])) {
        $action = $_POST["action"];

        // Handle "add_catagory" action
        if ($action == "add_catagory") {
            if (isset($_POST["catagory_name"])) {
                $name = $_POST["catagory_name"];

                $sql = "INSERT INTO `catagory` (`catagory_name`) VALUES (?)";
                $stmt = $con->prepare($sql);
                $stmt->bind_param("s", $name);

                if ($stmt->execute()) {
                    $response["success"] = true;
                    $response["message"] = "Category added successfully";
                } else {
                    $response["success"] = false;
                    $response["message"] = "Failed to add category: " . $stmt->error;
                }
                $stmt->close();
            } else {
                $response["success"] = false;
                $response["message"] = "Category name not provided";
            }
        }
        // Handle "fetch_catagory" action
        elseif ($action == "fetch_catagory") {
            $sql = "SELECT `catagory_ID`, `catagory_name` FROM `catagory`";
            $result = $con->query($sql);

            if ($result) {
                $catagories = $result->fetch_all(MYSQLI_ASSOC);
                $response["success"] = true;
                $response["data"] = $catagories;
            } else {
                $response["success"] = false;
                $response["message"] = "Failed to fetch categories: " . $con->error;
            }
        }
        // Handle "update_catagory" action
        elseif ($action == "update_catagory") {
            if (isset($_POST["catagory_ID"], $_POST["catagory_name"])) {
                $catagory_ID = $_POST["catagory_ID"];
                $catagory_name = $_POST["catagory_name"];

                $sql = "UPDATE `catagory` SET `catagory_name` = ? WHERE `catagory_ID` = ?";
                $stmt = $con->prepare($sql);
                $stmt->bind_param("si", $catagory_name, $catagory_ID);

                if ($stmt->execute()) {
                    $response["success"] = true;
                    $response["message"] = "Category updated successfully";
                } else {
                    $response["success"] = false;
                    $response["message"] = "Failed to update category: " . $stmt->error;
                }
                $stmt->close();
            } else {
                $response["success"] = false;
                $response["message"] = "Category ID or name not provided";
            }
        }
        // Handle "delete_catagory" action
        elseif ($action == "delete_catagory") {
            if (isset($_POST["catagory_ID"])) {
                $catagory_ID = $_POST["catagory_ID"];

                $sql = "DELETE FROM `catagory` WHERE `catagory_ID` = ?";
                $stmt = $con->prepare($sql);
                $stmt->bind_param("i", $catagory_ID);

                if ($stmt->execute()) {
                    $response["success"] = true;
                    $response["message"] = "Category deleted successfully";
                } else {
                    $response["success"] = false;
                    $response["message"] = "Failed to delete category: " . $stmt->error;
                }
                $stmt->close();
            } else {
                $response["success"] = false;
                $response["message"] = "Category ID not provided";
            }
        }
        // Invalid action specified
        else {
            $response["success"] = false;
            $response["message"] = "Invalid action specified";
        }
    } else {
        // No action specified
        $response["success"] = false;
        $response["message"] = "No action specified";
    }
} else {
    // Invalid request method
    $response["success"] = false;
    $response["message"] = "Invalid request method";
}

echo json_encode($response);
?>
