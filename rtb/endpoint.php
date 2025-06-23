<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

require_once '../config/database.php';
require_once 'bidder.php';

// Handle preflight OPTIONS request
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

// Only accept POST requests
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['error' => 'Method not allowed']);
    exit;
}

try {
    // Get the raw POST data
    $input = file_get_contents('php://input');
    $request = json_decode($input, true);
    
    if (!$request) {
        throw new Exception('Invalid JSON request');
    }
    
    // Log the request for debugging
    error_log('RTB Request: ' . $input);
    
    // Validate OpenRTB request
    if (!isset($request['id']) || !isset($request['imp'])) {
        throw new Exception('Invalid OpenRTB request format');
    }
    
    // Initialize bidder
    $bidder = new RTBBidder($pdo);
    
    // Process the bid request
    $response = $bidder->processBidRequest($request);
    
    // Log the response
    error_log('RTB Response: ' . json_encode($response));
    
    // Return the response
    if ($response) {
        echo json_encode($response);
    } else {
        // No bid response (HTTP 204)
        http_response_code(204);
    }
    
} catch (Exception $e) {
    error_log('RTB Error: ' . $e->getMessage());
    http_response_code(400);
    echo json_encode(['error' => $e->getMessage()]);
}
?>