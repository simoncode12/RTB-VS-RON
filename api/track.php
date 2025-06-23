<?php
// Set headers for pixel tracking
header('Content-Type: image/gif');
header('Cache-Control: no-cache, no-store, must-revalidate');
header('Pragma: no-cache');
header('Expires: 0');
header('Access-Control-Allow-Origin: *');

// Output a 1x1 transparent GIF
echo base64_decode('R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7');

// If we're on a server with output buffering, flush now
if (ob_get_length()) {
    ob_flush();
    flush();
}

// Current timestamp information
$current_timestamp = '2025-06-23 18:53:23'; 
$current_user = 'simoncode12';

// Now handle the tracking - client is no longer waiting
// Include database configuration
@require_once '../config/database.php';

// Get tracking parameters
$track_type = $_GET['type'] ?? '';
$bid_log_id = isset($_GET['bid_log_id']) ? intval($_GET['bid_log_id']) : 0;
$zone_id = isset($_GET['zone_id']) ? intval($_GET['zone_id']) : 0;

// Implement tracking logic here...
// ...

// No need to return anything - connection to client is already closed
exit;
?>