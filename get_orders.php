<?php
include 'db_connection.php';

$userId = $_POST['user_id'];

$query = "SELECT * FROM orders WHERE user_id = '$userId' ORDER BY id DESC";
$result = $conn->query($query);

$orders = [];

while ($row = $result->fetch_assoc()) {
    $orders[] = $row;
}

echo json_encode(['orders' => $orders]);

$conn->close();
?>
