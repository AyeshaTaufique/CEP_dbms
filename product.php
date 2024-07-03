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

        // Handle "add_product" action
        if ($action == "add_product") {
            // Ensure all required fields are provided
            if (isset($_POST["prod_name"], $_POST["price"], $_POST["stock"], $_POST["catagory_ID"])) {
                $productName = $_POST["prod_name"];
                $price = $_POST["price"];
                $stock = $_POST["stock"];
                $categoryId = $_POST["catagory_ID"];

                // Prepare SQL statement
                $sql = "INSERT INTO `product` (`prod_name`, `price`, `stock`, `catagory_ID`) VALUES (?, ?, ?, ?)";
                $stmt = $con->prepare($sql);

                if ($stmt) {
                    // Bind parameters
                    $stmt->bind_param("sdsi", $productName, $price, $stock, $categoryId);

                    // Execute SQL statement
                    if ($stmt->execute()) {
                        $response["success"] = true;
                        $response["message"] = "Product added successfully";
                    } else {
                        $response["success"] = false;
                        $response["message"] = "Failed to add product: " . $stmt->error;
                    }
                    $stmt->close();
                } else {
                    // Error preparing statement
                    $response["success"] = false;
                    $response["message"] = "Failed to prepare statement: " . $con->error;
                }
            } else {
                // Required fields missing
                $response["success"] = false;
                $response["message"] = "One or more required fields are missing";
            }
        }


        // Handle "fetch_product" action
        elseif ($action == "fetch_product") {
            $sql = "SELECT `prod_ID`, `prod_name`, `price`, `stock`,`catagory_ID`, `catagory_name` FROM `product_category_view`";
            $result = $con->query($sql);

            if ($result) {
                $products = [];
                while ($row = $result->fetch_assoc()) {
                    $products[] = $row;
                }
                $response["success"] = true;
                $response["data"] = $products;
            } else {
                $response["success"] = false;
                $response["message"] = "Failed to fetch products: " . $con->error;
            }
        }

        // Handle "update_product" action
        elseif ($action == "update_product") {
            if (isset($_POST["prod_ID"], $_POST["prod_name"], $_POST["price"], $_POST["stock"], $_POST["catagory_ID"])) {
                $product_id = $_POST["prod_ID"];
                $product_name = $_POST["prod_name"];
                $price = $_POST["price"];
                $stock = $_POST["stock"];
                $category_id = $_POST["catagory_ID"];
        
                $sql = "UPDATE `product` SET `prod_name` = ?, `price` = ?, `stock` = ?, `catagory_ID` = ? WHERE `prod_ID` = ?";
                $stmt = $con->prepare($sql);
                if (!$stmt) {
                    $response["success"] = false;
                    $response["message"] = "Prepare failed: (" . $con->errno . ") " . $con->error;
                } else {
                    // The types should be: s = string, d = double, i = integer
                    $stmt->bind_param("sdiii", $product_name, $price, $stock, $category_id, $product_id);
                    if ($stmt->execute()) {
                        $response["success"] = true;
                        $response["message"] = "Product updated successfully";
                    } else {
                        $response["success"] = false;
                        $response["message"] = "Failed to update product: " . $stmt->error;
                    }
                    $stmt->close();
                }
            } else {
                $response["success"] = false;
                $response["message"] = "One or more required fields (product_id, product_name, price, stock, category_id) not provided";
            }
        }
        

        // Handle "delete_product" action
        elseif ($action == "delete_product") {
            if (isset($_POST["prod_ID"])) {
                $product_id = $_POST["prod_ID"];

                $sql = "DELETE FROM `product` WHERE `prod_ID` = ?";
                $stmt = $con->prepare($sql);
                $stmt->bind_param("i", $product_id);

                if ($stmt->execute()) {
                    $response["success"] = true;
                    $response["message"] = "Product deleted successfully";
                } else {
                    $response["success"] = false;
                    $response["message"] = "Failed to delete product: " . $stmt->error;
                }
                $stmt->close();
            } else {
                $response["success"] = false;
                $response["message"] = "Product ID not provided";
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
        $response["message"] = "Action parameter not provided";
    }
} else {
    // Invalid request method
    $response["success"] = false;
    $response["message"] = "Invalid request method";
}

echo json_encode($response);
?>
