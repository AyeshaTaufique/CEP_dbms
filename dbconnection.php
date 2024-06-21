<?php


function dbconnection(){
    $con=mysqli_connect("localhost","root","","user_table");
    return $con;
}
?>