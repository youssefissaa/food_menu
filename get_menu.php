<?php
include 'db_connection.php';

$itemsQuery = "SELECT * FROM menu";
$saucesQuery = "SELECT * FROM sauces";

$itemsResult = $conn->query($itemsQuery);
$saucesResult = $conn->query($saucesQuery);

$items = [];
$sauces = [];

while ($row = $itemsResult->fetch_assoc()) {
    $items[] = $row;
}

while ($row = $saucesResult->fetch_assoc()) {
    $sauces[] = $row;
}

echo json_encode(['items' => $items, 'sauces' => $sauces]);

$conn->close();
?>
