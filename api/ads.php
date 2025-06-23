<?php
/**
 * AdStart RTB & RON Platform - Ad Serving API
 * Version: 1.0.0
 * Current Date and Time (UTC): 2025-06-23 18:28:24
 * Current User: simoncode12
 * 
 * This API handles ad serving requests from the ads.js client script.
 * It supports both RTB and RON campaign types, targeting, and fallback content.
 */

// Start output buffering to ensure clean JSON output
ob_start();

// Set headers for JSON response and CORS
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

// Handle preflight requests
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    // Return 200 for preflight requests
    http_response_code(200);
    exit;
}

// Include database connection
require_once __DIR__ . '/../config/database.php';

// Log file for debugging
$log_file = __DIR__ . '/../logs/adrequest_' . date('Y-m-d') . '.log';

// Initialize response array
$response = [
    'success' => false,
    'error' => null,
    'request_time' => date('Y-m-d H:i:s'),
    'request_id' => null,
    'ad' => null,
    'fallback_content' => null,
    'debug' => []
];

// Helper function to log messages
function log_message($message, $data = null) {
    global $log_file;
    $log_entry = date('Y-m-d H:i:s') . " - {$message}";
    if ($data !== null) {
        $log_entry .= " - " . json_encode($data);
    }
    error_log($log_entry . PHP_EOL, 3, $log_file);
}

// Helper function to get client IP address
function get_client_ip() {
    if (!empty($_SERVER['HTTP_CLIENT_IP'])) {
        $ip = $_SERVER['HTTP_CLIENT_IP'];
    } elseif (!empty($_SERVER['HTTP_X_FORWARDED_FOR'])) {
        $ip = $_SERVER['HTTP_X_FORWARDED_FOR'];
    } else {
        $ip = $_SERVER['REMOTE_ADDR'] ?? '0.0.0.0';
    }
    return $ip;
}

// Helper function to get browser information
function get_browser_info($user_agent) {
    $browser = 'Unknown';
    $os = 'Unknown';
    $device = 'desktop';
    
    // Detect OS
    if (preg_match('/windows/i', $user_agent)) {
        $os = 'Windows';
    } elseif (preg_match('/mac os x/i', $user_agent)) {
        $os = 'MacOS';
    } elseif (preg_match('/linux/i', $user_agent)) {
        $os = 'Linux';
    } elseif (preg_match('/android/i', $user_agent)) {
        $os = 'Android';
        $device = preg_match('/mobile/i', $user_agent) ? 'mobile' : 'tablet';
    } elseif (preg_match('/iphone/i', $user_agent)) {
        $os = 'iOS';
        $device = 'mobile';
    } elseif (preg_match('/ipad/i', $user_agent)) {
        $os = 'iOS';
        $device = 'tablet';
    }
    
    // Detect browser
    if (preg_match('/chrome/i', $user_agent) && !preg_match('/edg/i', $user_agent)) {
        $browser = 'Chrome';
    } elseif (preg_match('/firefox/i', $user_agent)) {
        $browser = 'Firefox';
    } elseif (preg_match('/safari/i', $user_agent) && !preg_match('/chrome/i', $user_agent)) {
        $browser = 'Safari';
    } elseif (preg_match('/edg/i', $user_agent)) {
        $browser = 'Edge';
    } elseif (preg_match('/msie|trident/i', $user_agent)) {
        $browser = 'IE';
    } elseif (preg_match('/opera|opr/i', $user_agent)) {
        $browser = 'Opera';
    }
    
    return ['browser' => $browser, 'os' => $os, 'device' => $device];
}

// Process the request
try {
    // Check if this is a serving request or a fallback content request
    $is_fallback_request = isset($_GET['zone_id']) && isset($_GET['fallback']);
    
    if ($is_fallback_request) {
        // Handle fallback content request
        $zone_id = intval($_GET['zone_id']);
        
        $stmt = $pdo->prepare("
            SELECT z.fallback_content, w.domain, z.size
            FROM zones z
            JOIN websites w ON z.website_id = w.id
            WHERE z.id = ?
        ");
        $stmt->execute([$zone_id]);
        $zone = $stmt->fetch(PDO::FETCH_ASSOC);
        
        if ($zone) {
            $response['success'] = true;
            $response['fallback_content'] = $zone['fallback_content'] ?? '<div style="background-color:#f0f0f0;width:100%;height:100%;display:flex;justify-content:center;align-items:center;color:#888;font-family:Arial,sans-serif;font-size:12px;">Ad space</div>';
        } else {
            $response['error'] = "Zone not found";
        }
        
        echo json_encode($response);
        exit;
    }
    
    // For ad serving requests, expect POST data
    if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
        throw new Exception("Invalid request method");
    }
    
    // Get JSON request body
    $request_body = file_get_contents('php://input');
    $request_data = json_decode($request_body, true);
    
    if (!$request_data || !isset($request_data['zone_id'])) {
        throw new Exception("Invalid request data");
    }
    
    // Extract request data
    $zone_id = intval($request_data['zone_id']);
    $request_id = $request_data['request_id'] ?? uniqid('req_');
    $domain = $request_data['domain'] ?? '';
    $page_url = $request_data['page_url'] ?? '';
    $referrer = $request_data['referrer'] ?? '';
    $user_agent = $request_data['user_agent'] ?? $_SERVER['HTTP_USER_AGENT'] ?? '';
    $ip_address = get_client_ip();
    
    // Extract or detect browser info
    $browser = $request_data['browser'] ?? '';
    $os = $request_data['os'] ?? '';
    $device_type = $request_data['device_type'] ?? '';
    
    // If client didn't provide browser info, detect it
    if (empty($browser) || empty($os) || empty($device_type)) {
        $browser_info = get_browser_info($user_agent);
        $browser = $browser ?: $browser_info['browser'];
        $os = $os ?: $browser_info['os'];
        $device_type = $device_type ?: $browser_info['device'];
    }
    
    // Get country from IP (simplified - in production use a proper GeoIP service)
    $country = $request_data['country'] ?? '';
    if (empty($country) && function_exists('geoip_country_code_by_name')) {
        $country = geoip_country_code_by_name($ip_address);
    }
    
    // Store request ID and basics in response
    $response['request_id'] = $request_id;
    $response['debug']['zone_id'] = $zone_id;
    $response['debug']['domain'] = $domain;
    $response['debug']['browser'] = $browser;
    $response['debug']['os'] = $os;
    $response['debug']['device'] = $device_type;
    $response['debug']['country'] = $country;
    
    log_message("Received ad request", [
        'request_id' => $request_id,
        'zone_id' => $zone_id,
        'domain' => $domain,
        'user_agent' => $user_agent,
        'ip' => $ip_address
    ]);
    
    // Step 1: Get zone information
    $stmt = $pdo->prepare("
        SELECT z.*, w.id as website_id, w.publisher_id, w.domain, w.category_id as website_category
        FROM zones z
        JOIN websites w ON z.website_id = w.id
        WHERE z.id = ? AND z.status = 'active' AND w.status = 'active'
    ");
    $stmt->execute([$zone_id]);
    $zone = $stmt->fetch(PDO::FETCH_ASSOC);
    
    if (!$zone) {
        throw new Exception("Zone not found or inactive");
    }
    
    // Verify domain matches the zone's website (anti-fraud)
    if ($domain && $zone['domain'] && $domain !== $zone['domain']) {
        log_message("Domain mismatch", ['expected' => $zone['domain'], 'received' => $domain]);
        throw new Exception("Domain mismatch");
    }
    
    // Get zone dimensions
    list($width, $height) = explode('x', $zone['size']);
    
    // Step 2: Find matching campaigns
    $now = date('Y-m-d');
    $params = [
        'size' => $zone['size'],
        'now' => $now,
        'website_category' => $zone['website_category']
    ];
    
    // Build targeting conditions
    $targeting_conditions = [];
    
    // Add targeting conditions for RON campaigns
    $targeting_conditions[] = "
        (
            -- Match campaigns with no country targeting or with matching country
            (c.target_countries IS NULL OR (JSON_CONTAINS(c.target_countries, ?) OR JSON_CONTAINS(c.target_countries, ?)))
            
            -- Match campaigns with no browser targeting or with matching browser
            AND (c.target_browsers IS NULL OR JSON_CONTAINS(c.target_browsers, ?))
            
            -- Match campaigns with no device targeting or with matching device
            AND (c.target_devices IS NULL OR JSON_CONTAINS(c.target_devices, ?))
            
            -- Match campaigns with no OS targeting or with matching OS
            AND (c.target_os IS NULL OR JSON_CONTAINS(c.target_os, ?))
            
            -- Match campaigns with correct size
            AND (c.banner_sizes IS NULL OR JSON_CONTAINS(c.banner_sizes, ?))
        )
    ";
    
    // Add parameters for targeting conditions
    $params[] = json_encode($country);
    $params[] = json_encode(strtolower($country)); // For case-insensitive matching
    $params[] = json_encode($browser);
    $params[] = json_encode($device_type);
    $params[] = json_encode($os);
    $params[] = json_encode($zone['size']);
    
    // Query for matching campaigns
    $campaign_query = "
        SELECT c.*, cr.id as creative_id, cr.name as creative_name, cr.width, cr.height, 
               cr.bid_amount, cr.creative_type, cr.image_url, cr.video_url, 
               cr.html_content, cr.click_url
        FROM campaigns c
        JOIN creatives cr ON c.id = cr.campaign_id
        WHERE 
            -- Basic campaign requirements
            c.status = 'active'
            AND cr.status = 'active'
            AND cr.width = ?
            AND cr.height = ?
            AND (c.start_date IS NULL OR c.start_date <= ?)
            AND (c.end_date IS NULL OR c.end_date >= ?)
            
            -- Match by category (if specified)
            AND (c.category_id IS NULL OR c.category_id = ?)
            
            -- Check targeting conditions
            AND " . implode(' AND ', $targeting_conditions) . "
        
        -- Order by bid amount descending
        ORDER BY cr.bid_amount DESC
        LIMIT 10
    ";
    
    // Add parameters for basic requirements
    array_unshift($params, $zone['website_category']);
    array_unshift($params, $now);
    array_unshift($params, $now);
    array_unshift($params, $height);
    array_unshift($params, $width);
    
    $stmt = $pdo->prepare($campaign_query);
    $stmt->execute($params);
    $campaigns = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    log_message("Found " . count($campaigns) . " matching campaigns/creatives");
    
    // If no campaigns match, return no ad
    if (empty($campaigns)) {
        $response['debug']['reason'] = 'No matching campaigns';
        echo json_encode($response);
        exit;
    }
    
    // Step 3: For RTB campaigns, send bid requests to endpoints
    $rtb_campaigns = array_filter($campaigns, function($campaign) {
        return $campaign['type'] === 'rtb' && !empty($campaign['endpoint_url']);
    });
    
    $highest_bid = 0;
    $winning_campaign = null;
    
    // Check RTB campaigns first
    if (!empty($rtb_campaigns)) {
        foreach ($rtb_campaigns as $campaign) {
            try {
                // Prepare RTB request
                $rtb_request = [
                    'request_id' => $request_id,
                    'zone_id' => $zone_id,
                    'zone_size' => $zone['size'],
                    'domain' => $domain,
                    'page_url' => $page_url,
                    'referrer' => $referrer,
                    'user_agent' => $user_agent,
                    'ip' => $ip_address,
                    'country' => $country,
                    'browser' => $browser,
                    'os' => $os,
                    'device' => $device_type,
                    'bid_floor' => $campaign['bid_amount'],
                    'campaign_id' => $campaign['id'],
                    'creative_id' => $campaign['creative_id']
                ];
                
                // Set timeout for RTB request
                $options = [
                    'http' => [
                        'method' => 'POST',
                        'header' => 'Content-Type: application/json',
                        'content' => json_encode($rtb_request),
                        'timeout' => 0.5 // 500ms timeout
                    ]
                ];
                
                $context = stream_context_create($options);
                $rtb_response = @file_get_contents($campaign['endpoint_url'], false, $context);
                
                if ($rtb_response === false) {
                    continue; // Skip if request failed
                }
                
                $rtb_data = json_decode($rtb_response, true);
                if (!$rtb_data || !isset($rtb_data['bid'])) {
                    continue;
                }
                
                $bid = floatval($rtb_data['bid']);
                if ($bid > $highest_bid) {
                    $highest_bid = $bid;
                    $winning_campaign = $campaign;
                    $winning_campaign['rtb_bid'] = $bid;
                    $winning_campaign['rtb_response'] = $rtb_data;
                }
            } catch (Exception $e) {
                log_message("RTB error for campaign " . $campaign['id'], $e->getMessage());
                continue;
            }
        }
    }
    
    // If no winning RTB campaign, pick the highest RON campaign
    if (!$winning_campaign) {
        $ron_campaigns = array_filter($campaigns, function($campaign) {
            return $campaign['type'] === 'ron';
        });
        
        if (!empty($ron_campaigns)) {
            $winning_campaign = $ron_campaigns[0]; // Already ordered by bid_amount DESC
            $highest_bid = $winning_campaign['bid_amount'];
        } else {
            $winning_campaign = $campaigns[0]; // Fallback to any campaign
            $highest_bid = $winning_campaign['bid_amount'];
        }
    }
    
    // Step 4: Check budget caps
    $campaign_id = $winning_campaign['id'];
    
    // Daily budget check
    if ($winning_campaign['daily_budget']) {
        $stmt = $pdo->prepare("
            SELECT SUM(win_price) as spent_today
            FROM bid_logs
            WHERE campaign_id = ? AND DATE(created_at) = ? AND status IN ('win', 'click')
        ");
        $stmt->execute([$campaign_id, $now]);
        $daily_spend = $stmt->fetch(PDO::FETCH_ASSOC)['spent_today'] ?? 0;
        
        if ($daily_spend >= $winning_campaign['daily_budget']) {
            log_message("Campaign {$campaign_id} daily budget exceeded");
            $response['debug']['reason'] = 'Daily budget exceeded';
            echo json_encode($response);
            exit;
        }
    }
    
    // Total budget check
    if ($winning_campaign['total_budget']) {
        $stmt = $pdo->prepare("
            SELECT SUM(win_price) as total_spent
            FROM bid_logs
            WHERE campaign_id = ? AND status IN ('win', 'click')
        ");
        $stmt->execute([$campaign_id]);
        $total_spend = $stmt->fetch(PDO::FETCH_ASSOC)['total_spent'] ?? 0;
        
        if ($total_spend >= $winning_campaign['total_budget']) {
            log_message("Campaign {$campaign_id} total budget exceeded");
            $response['debug']['reason'] = 'Total budget exceeded';
            echo json_encode($response);
            exit;
        }
    }
    
    // Step 5: Log the bid and win
    $impression_id = uniqid('imp_');
    $win_price = $highest_bid;
    
    // Log the bid
    $stmt = $pdo->prepare("
        INSERT INTO bid_logs (request_id, campaign_id, creative_id, zone_id, 
                              bid_amount, win_price, impression_id,
                              user_agent, ip_address, country, device_type, browser, os,
                              status, created_at)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'win', NOW())
    ");
    $stmt->execute([
        $request_id,
        $winning_campaign['id'],
        $winning_campaign['creative_id'],
        $zone_id,
        $winning_campaign['bid_amount'],
        $win_price,
        $impression_id,
        $user_agent,
        $ip_address,
        $country,
        $device_type,
        $browser,
        $os
    ]);
    
    // Step 6: Prepare response
    $ad = [
        'campaign_id' => $winning_campaign['id'],
        'creative_id' => $winning_campaign['creative_id'],
        'name' => $winning_campaign['creative_name'],
        'width' => $winning_campaign['width'],
        'height' => $winning_campaign['height'],
        'creative_type' => $winning_campaign['creative_type'],
        'image_url' => $winning_campaign['image_url'],
        'video_url' => $winning_campaign['video_url'],
        'html_content' => $winning_campaign['html_content'],
        'click_url' => $winning_campaign['click_url']
    ];
    
    // Add autoplay, muted settings for video ads
    if ($winning_campaign['creative_type'] === 'video') {
        $ad['autoplay'] = true;
        $ad['muted'] = true;
        $ad['controls'] = true;
        $ad['loop'] = false;
    }
    
    $response['success'] = true;
    $response['ad'] = $ad;
    $response['impression_id'] = $impression_id;
    $response['bid_amount'] = $winning_campaign['bid_amount'];
    $response['win_price'] = $win_price;
    $response['refresh_rate'] = $zone['refresh_rate'] ?? 0;
    
    log_message("Serving ad", [
        'campaign_id' => $winning_campaign['id'],
        'creative_id' => $winning_campaign['creative_id'],
        'impression_id' => $impression_id,
        'bid' => $winning_campaign['bid_amount'],
        'win' => $win_price
    ]);
    
} catch (Exception $e) {
    $response['error'] = $e->getMessage();
    log_message("Error: " . $e->getMessage());
}

// Clean output buffer and send response
ob_end_clean();
echo json_encode($response);