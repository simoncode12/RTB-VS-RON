<?php
/**
 * Mock RTB Endpoint Test (No Database Required)
 * Tests RTB endpoint functionality with simulated database responses
 */

// Mock the database.php to avoid database dependency
$GLOBALS['mock_campaigns'] = [];
$GLOBALS['mock_creatives'] = [];

// Create a mock PDO class to simulate database queries
class MockPDO {
    public function prepare($sql) {
        return new MockPDOStatement($sql);
    }
    
    public function query($sql) {
        return new MockPDOStatement($sql);
    }
    
    public function setAttribute($attr, $value) {}
    public function beginTransaction() { return true; }
    public function commit() { return true; }
    public function rollBack() { return true; }
    public function exec($sql) { return true; }
}

class MockPDOStatement {
    private $sql;
    
    public function __construct($sql) {
        $this->sql = $sql;
    }
    
    public function execute($params = []) {
        return true;
    }
    
    public function fetchAll() {
        global $mock_campaigns, $mock_creatives;
        
        // Simulate RTB campaign query
        if (strpos($this->sql, "c.type = 'rtb'") !== false && strpos($this->sql, 'creatives') !== false) {
            return [
                [
                    'campaign_id' => 7,
                    'creative_id' => 8,
                    'name' => 'RTB Test Campaign 300x250',
                    'type' => 'rtb',
                    'status' => 'active',
                    'width' => 300,
                    'height' => 250,
                    'bid_amount' => 0.05,
                    'creative_type' => 'image',
                    'image_url' => 'https://via.placeholder.com/300x250/0099ff/ffffff?text=RTB+Test+Ad',
                    'click_url' => 'https://example.com/rtb-test-click',
                    'campaign_type' => 'rtb'
                ]
            ];
        }
        
        // Simulate RON campaign query
        if (strpos($this->sql, "c.type = 'ron'") !== false && strpos($this->sql, 'creatives') !== false) {
            return [
                [
                    'campaign_id' => 6,
                    'creative_id' => 1,
                    'name' => 'Banner ron',
                    'type' => 'ron',
                    'status' => 'active',
                    'width' => 300,
                    'height' => 250,
                    'bid_amount' => 0.0094,
                    'creative_type' => 'html5',
                    'html_content' => '<div>Test RON Ad</div>',
                    'click_url' => 'https://adstart.click/',
                    'campaign_type' => 'ron'
                ]
            ];
        }
        
        return [];
    }
}

// Initialize mock PDO
$pdo = new MockPDO();

// Include the bidder class
require_once __DIR__ . '/../rtb/bidder.php';

echo "Mock RTB Endpoint Test\n";
echo "======================\n\n";

// Test different request scenarios
$test_cases = [
    [
        'name' => '300x250 Banner Request',
        'request' => [
            'id' => 'test_300x250',
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
                'ua' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
                'ip' => '192.168.1.1',
                'geo' => ['country' => 'US']
            ]
        ]
    ],
    [
        'name' => '728x90 Banner Request',
        'request' => [
            'id' => 'test_728x90',
            'imp' => [
                [
                    'id' => '1',
                    'banner' => [
                        'w' => 728,
                        'h' => 90
                    ]
                ]
            ],
            'device' => [
                'ua' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
                'ip' => '192.168.1.1',
                'geo' => ['country' => 'US']
            ]
        ]
    ],
    [
        'name' => 'Invalid Request (No Banner)',
        'request' => [
            'id' => 'test_invalid',
            'imp' => [
                [
                    'id' => '1'
                    // No banner specified
                ]
            ]
        ]
    ]
];

foreach ($test_cases as $test) {
    echo "Test: {$test['name']}\n";
    echo str_repeat('-', 40) . "\n";
    
    try {
        $bidder = new RTBBidder($pdo);
        $response = $bidder->processBidRequest($test['request']);
        
        if ($response) {
            echo "✅ Response: HTTP 200 (Bid)\n";
            echo "Response data:\n";
            echo json_encode($response, JSON_PRETTY_PRINT) . "\n";
            
            // Check if it's RTB vs RON
            if (isset($response['seatbid'][0]['bid'][0]['ext']['campaign_type'])) {
                $campaign_type = $response['seatbid'][0]['bid'][0]['ext']['campaign_type'];
                $price = $response['seatbid'][0]['bid'][0]['price'];
                echo "Winner: {$campaign_type} campaign with bid \${$price}\n";
            }
        } else {
            echo "❌ Response: HTTP 204 (No Bid)\n";
        }
        
    } catch (Exception $e) {
        echo "❌ Error: " . $e->getMessage() . "\n";
    }
    
    echo "\n";
}

echo "Mock Test Complete!\n";
echo "\nKey Findings:\n";
echo "- 300x250 requests should now return RTB campaign bid (\$0.05)\n";
echo "- RTB campaigns should win over RON campaigns due to higher bid\n";
echo "- Invalid requests should return no bid (HTTP 204)\n";
echo "- Larger banner sizes may still return no bid if no campaigns exist\n";
?>