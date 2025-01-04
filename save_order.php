<?php
include 'db_connection.php';

$userId = $_POST['user_id'];
$orderDetails = $_POST['order_details'];
$totalPrice = $_POST['total_price'];

$query = "INSERT INTO orders (user_id, order_details, total_price) VALUES ('$userId', '$orderDetails', '$totalPrice')";

if ($conn->query($query) === TRUE) {
    echo json_encode(['status' => 'success']);
} else {
    echo json_encode(['status' => 'error', 'message' => 'Failed to save order.']);
}

$conn->close();
?>
