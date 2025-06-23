<?php
// Ad serving script for RTB & RON Platform
// Current Date: 2025-06-23 19:17:36
// Current User: simoncode12

header('Content-Type: application/javascript');

// Essential parameters
$zone_id = isset($_GET['zone_id']) ? intval($_GET['zone_id']) : 0;
$container_id = isset($_GET['container']) ? $_GET['container'] : '';
$width = isset($_GET['width']) ? intval($_GET['width']) : 0;
$height = isset($_GET['height']) ? intval($_GET['height']) : 0;
$zone_type = isset($_GET['type']) ? $_GET['type'] : 'banner';

// Request data
$url = isset($_GET['url']) ? $_GET['url'] : '';
$domain = isset($_GET['domain']) ? $_GET['domain'] : '';
$referrer = isset($_GET['referrer']) ? $_GET['referrer'] : '';
$browser = isset($_GET['browser']) ? $_GET['browser'] : '';
$device = isset($_GET['device']) ? $_GET['device'] : '';
$os = isset($_GET['os']) ? $_GET['os'] : '';
$ip_address = $_SERVER['REMOTE_ADDR'];
$user_agent = isset($_GET['ua']) ? $_GET['ua'] : $_SERVER['HTTP_USER_AGENT'];

// Include database configuration
require_once '../config/database.php';

// Generate a unique request ID
$request_id = uniqid('req_');
$impression_id = uniqid('imp_');

// Default country (should use GeoIP in production)
$country = 'US';

try {
    // Check if zone exists
    $stmt = $pdo->prepare("
        SELECT z.*, w.domain, w.publisher_id 
        FROM zones z
        JOIN websites w ON z.website_id = w.id
        WHERE z.id = ? AND z.status = 'active'
    ");
    $stmt->execute([$zone_id]);
    $zone = $stmt->fetch(PDO::FETCH_ASSOC);
    
    if (!$zone) {
        outputNoAd("Zone not found or inactive");
        exit;
    }
    
    // Parse zone size
    list($zone_width, $zone_height) = explode('x', $zone['size']);
    
    // If client provided dimensions don't match zone, use zone dimensions
    if ($width == 0 || $height == 0) {
        $width = $zone_width;
        $height = $zone_height;
    }
    
    // Find eligible campaigns and creatives
    $stmt = $pdo->prepare("
        SELECT c.*, cr.id as creative_id, cr.name as creative_name,
               cr.width, cr.height, cr.image_url, cr.video_url, cr.html_content, cr.click_url,
               cr.bid_amount, a.name as advertiser_name
        FROM campaigns c
        JOIN creatives cr ON c.id = cr.campaign_id
        JOIN advertisers a ON c.advertiser_id = a.id
        WHERE c.status = 'active' 
        AND a.status = 'active'
        AND cr.status = 'active'
        AND cr.width = ?
        AND cr.height = ?
        AND (c.start_date IS NULL OR c.start_date <= CURDATE())
        AND (c.end_date IS NULL OR c.end_date >= CURDATE())
        AND (
            c.target_countries IS NULL 
            OR JSON_CONTAINS(c.target_countries, ?)
            OR JSON_LENGTH(c.target_countries) = 0
        )
        AND (
            c.target_browsers IS NULL 
            OR JSON_CONTAINS(c.target_browsers, ?)
            OR JSON_LENGTH(c.target_browsers) = 0
        )
        AND (
            c.target_devices IS NULL 
            OR JSON_CONTAINS(c.target_devices, ?)
            OR JSON_LENGTH(c.target_devices) = 0
        )
        AND (
            c.target_os IS NULL 
            OR JSON_CONTAINS(c.target_os, ?)
            OR JSON_LENGTH(c.target_os) = 0
        )
        ORDER BY cr.bid_amount DESC
        LIMIT 10
    ");
    
    // Format JSON parameters for MySQL JSON_CONTAINS
    $country_json = json_encode($country);
    $browser_json = json_encode($browser);
    $device_json = json_encode($device);
    $os_json = json_encode($os);
    
    $stmt->execute([$width, $height, $country_json, $browser_json, $device_json, $os_json]);
    $creatives = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    if (empty($creatives)) {
        outputNoAd("No matching ads found");
        exit;
    }
    
    // Select the winning creative (highest bid)
    $winner = $creatives[0];
    
    // Log the bid win
    $stmt = $pdo->prepare("
        INSERT INTO bid_logs (
            request_id, campaign_id, creative_id, zone_id,
            bid_amount, win_price, impression_id,
            user_agent, ip_address, country, device_type,
            browser, os, status, created_at
        ) VALUES (
            ?, ?, ?, ?,
            ?, ?, ?,
            ?, ?, ?, ?,
            ?, ?, 'win', NOW()
        )
    ");
    
    $stmt->execute([
        $request_id,
        $winner['id'],
        $winner['creative_id'],
        $zone_id,
        $winner['bid_amount'],
        $winner['bid_amount'],
        $impression_id,
        $user_agent,
        $ip_address,
        $country,
        $device,
        $browser,
        $os
    ]);
    
    $bid_log_id = $pdo->lastInsertId();
    
    // Generate ad HTML based on creative type
    $ad_html = '';
    
    if (!empty($winner['html_content'])) {
        // HTML creative
        $ad_html = $winner['html_content'];
    } else if (!empty($winner['image_url'])) {
        // Image creative
        $ad_html = '<a href="' . htmlspecialchars($winner['click_url']) . '" target="_blank" rel="nofollow noopener">' .
                  '<img src="' . htmlspecialchars($winner['image_url']) . '" ' .
                  'width="' . $width . '" height="' . $height . '" ' .
                  'style="border:0; display:block;" alt="' . htmlspecialchars($winner['creative_name']) . '">' .
                  '</a>';
    } else if (!empty($winner['video_url'])) {
        // Video creative
        $ad_html = '<video width="' . $width . '" height="' . $height . '" ' .
                  'autoplay muted controls>' .
                  '<source src="' . htmlspecialchars($winner['video_url']) . '" type="video/mp4">' .
                  'Your browser does not support the video tag.' .
                  '</video>' .
                  '<div style="position:absolute; top:0; left:0; width:100%; height:100%;">' .
                  '<a href="' . htmlspecialchars($winner['click_url']) . '" target="_blank" rel="nofollow noopener" ' .
                  'style="display:block; width:100%; height:100%;"></a>' .
                  '</div>';
    } else {
        // Default fallback
        $ad_html = '<div style="width:100%; height:100%; background:#f0f0f0; display:flex; align-items:center; justify-content:center;">' .
                  '<span style="color:#666;">Ad</span>' .
                  '</div>';
    }
    
    // Generate tracking URLs
    $impression_url = "https://up.adstart.click/api/click-track.php?type=impression&bid_id={$bid_log_id}&zone_id={$zone_id}&request_id={$request_id}";
    $click_url = "https://up.adstart.click/api/click-track.php?type=click&bid_id={$bid_log_id}&zone_id={$zone_id}&request_id={$request_id}";
    
    // Output the JavaScript with the ad
    echo "window['adstart_display_" . $container_id . "'](";
    echo json_encode($ad_html) . ", ";
    echo json_encode($impression_url) . ", ";
    echo json_encode($click_url);
    echo ");";
    
} catch (Exception $e) {
    // Log the error but don't expose details to the client
    error_log("Ad serving error: " . $e->getMessage());
    outputNoAd("System error");
}

// Function to output a "no ad" response
function outputNoAd($reason) {
    global $container_id;
    $no_ad_html = '<div style="width:100%; height:100%; display:flex; flex-direction:column; justify-content:center; align-items:center; text-align:center; background:#f8f9fa; border:1px solid #ddd; font-family:Arial, sans-serif;">' .
                  '<span style="font-size:12px; color:#666;">Advertise Here</span>' .
                  '<span style="font-size:10px; margin-top:5px; color:#999;">RTB & RON Platform</span>' .
                  '</div>';
    
    echo "window['adstart_display_" . $container_id . "'](" . 
         json_encode($no_ad_html) . ", null, null);";
    
    // Log the reason
    error_log("No ad served: " . $reason);
}
?>