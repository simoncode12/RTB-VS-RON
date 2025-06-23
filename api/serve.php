<?php
// Start output buffering to prevent any unwanted output
ob_start();

// Set headers for JSON response
header('Content-Type: application/json');

// Enable CORS for cross-domain requests - this is crucial
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET');
header('Access-Control-Allow-Headers: Content-Type');

// Handle preflight OPTIONS request
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

// Include database configuration
require_once '../config/database.php';

// Get zone information
$zone_id = isset($_GET['zone_id']) ? intval($_GET['zone_id']) : 0;
$width = isset($_GET['width']) ? intval($_GET['width']) : 0;
$height = isset($_GET['height']) ? intval($_GET['height']) : 0;
$zone_type = isset($_GET['type']) ? $_GET['type'] : 'banner';

// Current timestamp information
$current_timestamp = '2025-06-23 18:53:23'; 
$current_user = 'simoncode12';

// For error testing or missing database, create a simple response
$response = [
    'success' => true,
    'html' => '<a href="https://up.adstart.click/click?id=1" target="_blank" style="display:block;">' .
             '<img src="https://via.placeholder.com/' . $width . 'x' . $height . '/0078D7/FFFFFF/?text=AdStart+Ad" ' .
             'width="' . $width . '" height="' . $height . '" style="border:0;" alt="Advertisement">' .
             '</a>',
    'impression_url' => 'https://up.adstart.click/api/track.php?type=impression&zone_id=' . $zone_id . '&t=' . time(),
    'click_tracking_url' => 'https://up.adstart.click/api/track.php?type=click&zone_id=' . $zone_id . '&t=' . time(),
    'click_url' => 'https://up.adstart.click/click?id=1',
    'campaign_id' => 1,
    'creative_id' => 1
];

// Return the JSON response
echo json_encode($response);

// End output buffering and send
ob_end_flush();
?>