<?php
header('Content-Type: application/json');

function parseSpecialChars($input) {
    return htmlspecialchars($input, ENT_QUOTES, 'UTF-8');
}

function decodeKeyFromUrl($key) {
    return urldecode($key);
}

// Array de chaves válidas
$validKeys = [
    "test",
    "TEST-KEY-001",
    "MRTUSAR-VIP-2024",
    "FREE-KEY-123",
    "PREMIUM-2025"
];

$validIntegrityKey = "MrTusarRX"; // integrityKey fixa

$key = isset($_GET['key']) ? decodeKeyFromUrl(parseSpecialChars($_GET['key'])) : '';
$integrityKey = isset($_GET['integrityKey']) ? parseSpecialChars($_GET['integrityKey']) : '';

$response = array(
    "Status" => "Failure", 
    "Message" => "Invalid key or integrity key", 
    "Username" => ""
);

// Verifica se a integrityKey está correta E se a key está no array
if ($integrityKey === $validIntegrityKey && in_array($key, $validKeys)) {
    $response["Status"] = "Success";
    $response["Message"] = "Login successful!";
    $response["Username"] = $key; // Retorna a própria key como username
}

echo json_encode($response);
?>
