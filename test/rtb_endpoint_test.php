<?php
/**
 * RTB Endpoint Test Script
 * Tests the RTB endpoint with various bid requests to ensure it returns valid responses
 */

require_once __DIR__ . '/../config/database.php';

echo "RTB Endpoint Test Script\n";
echo "========================\n\n";

// Test 1: Basic 300x250 RTB Request
echo "Test 1: Testing 300x250 RTB Request\n";
echo "------------------------------------\n";

$test_request = [
    'id' => 'test_' . uniqid(),
    'imp' => [
        [
            'id' => '1',
            'banner' => [
                'w' => 300,
                'h' => 250
            ]
        ]
    ],
    'device' => [
        'ua' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
        'ip' => '192.168.1.1',
        'geo' => [
            'country' => 'US'
        ]
    ]
];

$response = sendRTBRequest($test_request);
echo "Response Status: " . $response['status'] . "\n";
echo "Response Body: " . $response['body'] . "\n\n";

// Test 2: Check database for RTB campaigns with 300x250 creatives
echo "Test 2: Database Check - RTB Campaigns with 300x250 Creatives\n";
echo "--------------------------------------------------------------\n";

$stmt = $pdo->query("
    SELECT c.id as campaign_id, c.name, c.type, c.status as campaign_status,
           cr.id as creative_id, cr.width, cr.height, cr.bid_amount, cr.status as creative_status
    FROM campaigns c
    JOIN creatives cr ON c.id = cr.campaign_id
    WHERE c.type = 'rtb' AND cr.width = 300 AND cr.height = 250
    ORDER BY c.id DESC
");

$rtb_campaigns = $stmt->fetchAll();

if (empty($rtb_campaigns)) {
    echo "❌ No RTB campaigns found with 300x250 creatives!\n";
    echo "This explains why RTB endpoint returns HTTP 204.\n\n";
} else {
    echo "✅ Found " . count($rtb_campaigns) . " RTB campaign(s) with 300x250 creatives:\n";
    foreach ($rtb_campaigns as $campaign) {
        echo "  - Campaign {$campaign['campaign_id']}: {$campaign['name']} (Status: {$campaign['campaign_status']})\n";
        echo "    Creative {$campaign['creative_id']}: {$campaign['width']}x{$campaign['height']} @ \${$campaign['bid_amount']} (Status: {$campaign['creative_status']})\n";
    }
    echo "\n";
}

// Test 3: Check database for RON campaigns with 300x250 creatives  
echo "Test 3: Database Check - RON Campaigns with 300x250 Creatives\n";
echo "-------------------------------------------------------------\n";

$stmt = $pdo->query("
    SELECT c.id as campaign_id, c.name, c.type, c.status as campaign_status,
           cr.id as creative_id, cr.width, cr.height, cr.bid_amount, cr.status as creative_status
    FROM campaigns c
    JOIN creatives cr ON c.id = cr.campaign_id
    WHERE c.type = 'ron' AND cr.width = 300 AND cr.height = 250
    ORDER BY c.id DESC
");

$ron_campaigns = $stmt->fetchAll();

if (empty($ron_campaigns)) {
    echo "❌ No RON campaigns found with 300x250 creatives!\n";
} else {
    echo "✅ Found " . count($ron_campaigns) . " RON campaign(s) with 300x250 creatives:\n";
    foreach ($ron_campaigns as $campaign) {
        echo "  - Campaign {$campaign['campaign_id']}: {$campaign['name']} (Status: {$campaign['campaign_status']})\n";
        echo "    Creative {$campaign['creative_id']}: {$campaign['width']}x{$campaign['height']} @ \${$campaign['bid_amount']} (Status: {$campaign['creative_status']})\n";
    }
}
echo "\n";

// Test 4: Test different banner sizes
echo "Test 4: Testing Different Banner Sizes\n";
echo "--------------------------------------\n";

$banner_sizes = [
    ['w' => 728, 'h' => 90, 'name' => 'Leaderboard'],
    ['w' => 160, 'h' => 600, 'name' => 'Wide Skyscraper'],
    ['w' => 320, 'h' => 50, 'name' => 'Mobile Banner']
];

foreach ($banner_sizes as $size) {
    $test_request['imp'][0]['banner'] = $size;
    $test_request['id'] = 'test_' . $size['w'] . 'x' . $size['h'] . '_' . uniqid();
    
    $response = sendRTBRequest($test_request);
    echo "{$size['name']} ({$size['w']}x{$size['h']}): Status {$response['status']}\n";
}

echo "\nTest Complete!\n";

/**
 * Send RTB request to the endpoint
 */
function sendRTBRequest($request) {
    $url = 'http://localhost:8000/rtb/endpoint.php'; // Adjust URL as needed
    
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($request));
    curl_setopt($ch, CURLOPT_HTTPHEADER, [
        'Content-Type: application/json',
        'Content-Length: ' . strlen(json_encode($request))
    ]);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_TIMEOUT, 10);
    
    $response_body = curl_exec($ch);
    $status_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);
    
    return [
        'status' => $status_code,
        'body' => $response_body
    ];
}
?>