<?php
$db = mysqli_connect('localhost', 'root', '', 'userdata');
if (!$db) {
    echo json_encode("Database connection failed.");
    exit();
}

$firstName = $_POST['first_name'] ?? '';
$email = $_POST['email'] ?? '';
$password = $_POST['password'] ?? '';
$confirmPassword = $_POST['cpassword'] ?? '';

// Sanitize user input to prevent SQL injection
$firstName = mysqli_real_escape_string($db, $firstName);
$email = mysqli_real_escape_string($db, $email);
$password = mysqli_real_escape_string($db, $password);
$confirmPassword = mysqli_real_escape_string($db, $confirmPassword);

$sql = "SELECT * FROM login WHERE email = '$email' AND password = '$password'";
$result = mysqli_query($db, $sql);
$count = mysqli_num_rows($result);

if ($count == 1) {
    echo json_encode("Error");
} else {
    $insert = "INSERT INTO login (firstName, email, password, confirmPassword) VALUES ('$firstName', '$email','$password', '$confirmPassword')";
    $query = mysqli_query($db, $insert);

    if ($query) {
        echo json_encode("success");
    } else {
        echo json_encode("Error inserting data into the database." . mysqli_error($db));
    }
}

mysqli_close($db);
?>