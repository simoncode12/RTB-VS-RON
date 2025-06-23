<?php
// Start output buffering to prevent any unwanted output
ob_start();

// Set headers for JSONP response
header('Content-Type: application/javascript');

// Enable CORS for cross-domain requests - this is crucial
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET');
header('Access-Control-Allow-Headers: Content-Type');

// Get the callback function name from the request
$callback = isset($_GET['callback']) ? $_GET['callback'] : null;

// Validate callback parameter to prevent XSS
if (!preg_match('/^[a-zA-Z0-9_]+$/', $callback)) {
    $callback = 'adstartCallback'; // Default safe callback name
}

// Include database configuration
require_once '../config/database.php';

// Get zone information
$zone_id = isset($_GET['zone_id']) ? intval($_GET['zone_id']) : 0;
$width = isset($_GET['width']) ? intval($_GET['width']) : 0;
$height = isset($_GET['height']) ? intval($_GET['height']) : 0;
$zone_type = isset($_GET['type']) ? $_GET['type'] : 'banner';

// Get page information
$url = isset($_GET['url']) ? $_GET['url'] : '';
$referrer = isset($_GET['referrer']) ? $_GET['referrer'] : '';
$user_agent = isset($_GET['ua']) ? $_GET['ua'] : $_SERVER['HTTP_USER_AGENT'] ?? '';
$ip_address = $_SERVER['REMOTE_ADDR'] ?? '';
$timestamp = isset($_GET['t']) ? intval($_GET['t']) : time();

// Check if we need to provide a simple fallback for errors or missing data
$use_fallback = false;
$response = [];

try {
    // Attempt to query the database for a real ad
    // (This would be your actual logic from serve.php)
    // ...
    
    // For now, just create a sample ad
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
} catch (Exception $e) {
    // Log error but don't expose details to client
    error_log('Error serving ad through JSONP: ' . $e->getMessage());
    $use_fallback = true;
}

// If we had an error or no ad available, provide a fallback
if ($use_fallback) {
    $response = [
        'success' => false,
        'html' => '<div style="width:100%; height:100%; display:flex; flex-direction:column; align-items:center; justify-content:center; text-align:center; background:#f8f9fa; border:1px solid #ddd; box-sizing:border-box;">' .
                  '<span style="font-size:12px; color:#666;">Advertise Here</span>' .
                  '<span style="font-size:10px; margin-top:5px; color:#999;">RTB & RON Platform</span>' .
                  '</div>',
        'impression_url' => 'https://up.adstart.click/api/track.php?type=no_ad&zone_id=' . $zone_id
    ];
}

// Return the JSONP response
echo $callback . '(' . json_encode($response) . ');';

// End output buffering and send
ob_end_flush();
?>