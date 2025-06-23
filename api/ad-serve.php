<?php
// Ad serving script for RTB & RON Platform with RTB support
// Current Date: 2025-06-23 20:18:50
// Current User: simoncode12

// Set CORS headers
header('Access-Control-Allow-Origin: *');
header('Content-Type: application/javascript; charset=UTF-8');
header('Cache-Control: no-cache, no-store, must-revalidate');
header('Pragma: no-cache');
header('Expires: 0');

// Essential parameters
$zone_id = isset($_GET['zone_id']) ? intval($_GET['zone_id']) : 0;
$container_id = isset($_GET['container']) ? $_GET['container'] : '';
$width = isset($_GET['width']) ? intval($_GET['width']) : 0;
$height = isset($_GET['height']) ? intval($_GET['height']) : 0;
$zone_type = isset($_GET['type']) ? $_GET['type'] : 'banner';

// Log incoming request
error_log("AdStart Request - Zone: $zone_id, Container: $container_id, Size: {$width}x{$height}");

// Request data
$url = isset($_GET['url']) ? $_GET['url'] : '';
$domain = isset($_GET['domain']) ? $_GET['domain'] : '';
$referrer = isset($_GET['referrer']) ? $_GET['referrer'] : '';
$user_agent = isset($_GET['ua']) ? $_GET['ua'] : $_SERVER['HTTP_USER_AGENT'];
$ip_address = $_SERVER['REMOTE_ADDR'];

// Include database configuration
require_once dirname(__DIR__) . '/config/database.php';

// Generate a unique request ID
$request_id = uniqid('req_');
$impression_id = uniqid('imp_');

// Default values
$country = 'US';
$browser = 'Chrome';
$device = 'Desktop';
$os = 'Windows';

// Detect browser, device, OS from user agent
if (strpos($user_agent, 'Chrome') !== false) $browser = 'Chrome';
elseif (strpos($user_agent, 'Firefox') !== false) $browser = 'Firefox';
elseif (strpos($user_agent, 'Safari') !== false) $browser = 'Safari';
elseif (strpos($user_agent, 'Edge') !== false) $browser = 'Edge';

if (strpos($user_agent, 'Mobile') !== false) $device = 'Mobile';
elseif (strpos($user_agent, 'Tablet') !== false) $device = 'Tablet';

if (strpos($user_agent, 'Windows') !== false) $os = 'Windows';
elseif (strpos($user_agent, 'Mac') !== false) $os = 'MacOS';
elseif (strpos($user_agent, 'Linux') !== false) $os = 'Linux';
elseif (strpos($user_agent, 'Android') !== false) $os = 'Android';
elseif (strpos($user_agent, 'iOS') !== false) $os = 'iOS';

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
        error_log("Zone $zone_id not found or inactive");
        outputNoAd("Zone not found or inactive", $container_id, $width, $height);
        exit;
    }
    
    // Parse zone size
    list($zone_width, $zone_height) = explode('x', $zone['size']);
    
    // Use zone dimensions if not provided
    if ($width == 0 || $height == 0) {
        $width = $zone_width;
        $height = $zone_height;
    }
    
    // Create OpenRTB bid request
    $rtb_request = [
        'id' => $request_id,
        'imp' => [[
            'id' => '1',
            'banner' => [
                'w' => $width,
                'h' => $height,
                'pos' => 0
            ],
            'bidfloor' => 0.001,
            'bidfloorcur' => 'USD'
        ]],
        'site' => [
            'id' => $zone_id,
            'domain' => $domain,
            'page' => $url,
            'ref' => $referrer,
            'publisher' => [
                'id' => $zone['publisher_id']
            ]
        ],
        'device' => [
            'ua' => $user_agent,
            'ip' => $ip_address,
            'devicetype' => $device == 'Mobile' ? 1 : ($device == 'Tablet' ? 5 : 2),
            'os' => $os
        ],
        'user' => [
            'id' => md5($ip_address . $user_agent)
        ],
        'at' => 2, // Second price auction
        'tmax' => 150, // 150ms timeout
        'cur' => ['USD']
    ];
    
    // First, try RTB campaigns
    $rtb_bids = [];
    
    // Call internal RTB handler
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, 'https://up.adstart.click/api/rtb-handler.php');
    curl_setopt($ch, CURLOPT_POST, 1);
    curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($rtb_request));
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_TIMEOUT_MS, 100);
    curl_setopt($ch, CURLOPT_HTTPHEADER, [
        'Content-Type: application/json',
        'x-openrtb-version: 2.5'
    ]);
    
    $rtb_response = curl_exec($ch);
    $http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);
    
    if ($http_code == 200 && $rtb_response) {
        $rtb_data = json_decode($rtb_response, true);
        if (isset($rtb_data['seatbid'])) {
            foreach ($rtb_data['seatbid'] as $seatbid) {
                foreach ($seatbid['bid'] as $bid) {
                    $rtb_bids[] = [
                        'price' => $bid['price'],
                        'adm' => $bid['adm'] ?? '',
                        'creative_id' => $bid['crid'] ?? 0,
                        'campaign_id' => $bid['ext']['campaign_id'] ?? 0,
                        'type' => 'rtb'
                    ];
                }
            }
        }
    }
    
    // Then find RON campaigns
    $stmt = $pdo->prepare("
        SELECT DISTINCT c.*, cr.id as creative_id, cr.name as creative_name,
               cr.width, cr.height, cr.image_url, cr.video_url, cr.html_content, cr.click_url,
               cr.bid_amount, cr.creative_type, a.name as advertiser_name
        FROM campaigns c
        JOIN creatives cr ON c.id = cr.campaign_id
        JOIN advertisers a ON c.advertiser_id = a.id
        WHERE c.status = 'active' 
        AND a.status = 'active'
        AND cr.status = 'active'
        AND c.type = 'ron'
        AND cr.width = ?
        AND cr.height = ?
        AND (c.start_date IS NULL OR c.start_date <= CURDATE())
        AND (c.end_date IS NULL OR c.end_date >= CURDATE())
        ORDER BY cr.bid_amount DESC
        LIMIT 10
    ");
    
    $stmt->execute([$width, $height]);
    $ron_campaigns = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    // Combine RTB and RON bids
    $all_bids = [];
    
    // Add RTB bids
    foreach ($rtb_bids as $rtb_bid) {
        $all_bids[] = [
            'price' => $rtb_bid['price'],
            'type' => 'rtb',
            'data' => $rtb_bid
        ];
    }
    
    // Add RON bids
    foreach ($ron_campaigns as $ron) {
        $all_bids[] = [
            'price' => $ron['bid_amount'],
            'type' => 'ron',
            'data' => $ron
        ];
    }
    
    // Sort by price (highest first)
    usort($all_bids, function($a, $b) {
        return $b['price'] <=> $a['price'];
    });
    
    error_log("Total bids: " . count($all_bids) . " (RTB: " . count($rtb_bids) . ", RON: " . count($ron_campaigns) . ")");
    
    if (empty($all_bids)) {
        outputNoAd("No matching ads found for size {$width}x{$height}", $container_id, $width, $height);
        exit;
    }
    
    // Select the winning bid
    $winner = $all_bids[0];
    $ad_html = '';
    $creative_id = 0;
    $campaign_id = 0;
    
    if ($winner['type'] == 'rtb') {
        // RTB winner
        $ad_html = $winner['data']['adm'];
        $creative_id = $winner['data']['creative_id'];
        $campaign_id = $winner['data']['campaign_id'];
        error_log("RTB bid won at price: " . $winner['price']);
    } else {
        // RON winner
        $ron_data = $winner['data'];
        $creative_id = $ron_data['creative_id'];
        $campaign_id = $ron_data['id'];
        
        if ($ron_data['creative_type'] == 'html5' || !empty($ron_data['html_content'])) {
            $ad_html = $ron_data['html_content'];
        } else if (!empty($ron_data['image_url'])) {
            $ad_html = '<a href="' . htmlspecialchars($ron_data['click_url']) . '" target="_blank" rel="nofollow noopener">' .
                      '<img src="' . htmlspecialchars($ron_data['image_url']) . '" ' .
                      'width="' . $width . '" height="' . $height . '" ' .
                      'style="border:0; display:block;" alt="Advertisement">' .
                      '</a>';
        }
        error_log("RON bid won at price: " . $winner['price']);
    }
    
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
        $campaign_id,
        $creative_id,
        $zone_id,
        $winner['price'],
        $winner['price'],
        $impression_id,
        $user_agent,
        $ip_address,
        $country,
        $device,
        $browser,
        $os
    ]);
    
    $bid_log_id = $pdo->lastInsertId();
    
    // Generate tracking URLs
    $impression_url = "https://up.adstart.click/api/click-track.php?type=impression&bid_id={$bid_log_id}&zone_id={$zone_id}&request_id={$request_id}";
    $click_url = "https://up.adstart.click/api/click-track.php?type=click&bid_id={$bid_log_id}&zone_id={$zone_id}&request_id={$request_id}";
    
    // Prepare dimensions object
    $dimensions = json_encode(['width' => $width, 'height' => $height]);
    
    // Output the JavaScript with the ad
    echo "(function(){";
    echo "  console.log('AdStart: Serving " . $winner['type'] . " ad for container: " . $container_id . "');";
    echo "  if(typeof window['adstart_display_" . $container_id . "'] === 'function') {";
    echo "    window['adstart_display_" . $container_id . "'](";
    echo      json_encode($ad_html) . ", ";
    echo      json_encode($impression_url) . ", ";
    echo      json_encode($click_url) . ", ";
    echo      $dimensions;
    echo "    );";
    echo "  } else {";
    echo "    console.error('AdStart: Callback function adstart_display_" . $container_id . " not found');";
    echo "  }";
    echo "})();";
    
} catch (Exception $e) {
    error_log("Ad serving error: " . $e->getMessage());
    outputNoAd("System error: " . $e->getMessage(), $container_id, $width, $height);
}

// Function to output a "no ad" response
function outputNoAd($reason, $container_id, $width = 0, $height = 0) {
    $dimensions = ($width && $height) ? ['width' => $width, 'height' => $height] : null;
    
    $no_ad_html = '<div style="width:100%; height:100%; display:flex; flex-direction:column; justify-content:center; align-items:center; text-align:center; background:#f8f9fa; border:1px solid #ddd; font-family:Arial,sans-serif; padding:20px; box-sizing:border-box; min-height:50px;">' .
                  '<span style="font-size:12px; color:#666;">Advertise Here</span>' .
                  '<span style="font-size:10px; margin-top:5px; color:#999;">RTB & RON Platform</span>' .
                  '</div>';
    
    echo "(function(){";
    echo "  console.log('AdStart: No ad - " . addslashes($reason) . "');";
    echo "  if(typeof window['adstart_display_" . $container_id . "'] === 'function') {";
    echo "    window['adstart_display_" . $container_id . "'](" . 
         json_encode($no_ad_html) . ", null, null, " . json_encode($dimensions) . ");";
    echo "  } else {";
    echo "    console.error('AdStart: Callback function adstart_display_" . $container_id . " not found for no-ad');";
    echo "  }";
    echo "})();";
    
    error_log("No ad served: " . $reason);
}
?>
