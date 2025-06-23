<?php
/**
 * RTB Bidder Logic Test (Standalone)
 * Tests the RTB bidder logic with mock data to ensure it works correctly
 */

echo "RTB Bidder Logic Test (Standalone)\n";
echo "==================================\n\n";

// Mock campaign data - before fix (only RON campaigns have 300x250)
$mock_campaigns_before = [
    [
        'campaign_id' => 5,
        'name' => 'Banner 1',
        'type' => 'rtb',
        'status' => 'active',
        'creatives' => [] // No creatives!
    ],
    [
        'campaign_id' => 6,
        'name' => 'Banner ron',
        'type' => 'ron',
        'status' => 'active',
        'creatives' => [
            [
                'creative_id' => 1,
                'width' => 300,
                'height' => 250,
                'bid_amount' => 0.0094,
                'status' => 'active',
                'creative_type' => 'html5'
            ]
        ]
    ]
];

// Mock campaign data - after fix (RTB campaign has 300x250)
$mock_campaigns_after = [
    [
        'campaign_id' => 5,
        'name' => 'Banner 1',
        'type' => 'rtb',
        'status' => 'active',
        'creatives' => []
    ],
    [
        'campaign_id' => 6,
        'name' => 'Banner ron',
        'type' => 'ron',
        'status' => 'active',
        'creatives' => [
            [
                'creative_id' => 1,
                'width' => 300,
                'height' => 250,
                'bid_amount' => 0.0094,
                'status' => 'active',
                'creative_type' => 'html5'
            ]
        ]
    ],
    [
        'campaign_id' => 7,
        'name' => 'RTB Test Campaign 300x250',
        'type' => 'rtb',
        'status' => 'active',
        'creatives' => [
            [
                'creative_id' => 8,
                'width' => 300,
                'height' => 250,
                'bid_amount' => 0.05,
                'status' => 'active',
                'creative_type' => 'image'
            ]
        ]
    ]
];

// Test RTB request
$test_request = [
    'id' => 'test_300x250',
    'imp' => [
        [
            'id' => '1',
            'banner' => [
                'w' => 300,
                'h' => 250
            ]
        ]
    ]
];

echo "Test 1: RTB Request Processing (Before Fix)\n";
echo "-------------------------------------------\n";
$result_before = simulateRTBBidding($test_request, $mock_campaigns_before);
echo "RTB campaigns found: " . count($result_before['rtb_campaigns']) . "\n";
echo "RON campaigns found: " . count($result_before['ron_campaigns']) . "\n";
echo "Winning campaign: " . ($result_before['winner'] ? "Campaign {$result_before['winner']['campaign_id']} ({$result_before['winner']['type']})" : "None") . "\n";
echo "HTTP Response: " . ($result_before['winner'] ? "200 (Bid)" : "204 (No Bid)") . "\n\n";

echo "Test 2: RTB Request Processing (After Fix)\n";
echo "------------------------------------------\n";
$result_after = simulateRTBBidding($test_request, $mock_campaigns_after);
echo "RTB campaigns found: " . count($result_after['rtb_campaigns']) . "\n";
echo "RON campaigns found: " . count($result_after['ron_campaigns']) . "\n";
echo "Winning campaign: " . ($result_after['winner'] ? "Campaign {$result_after['winner']['campaign_id']} ({$result_after['winner']['type']}) @ \${$result_after['winner']['bid_amount']}" : "None") . "\n";
echo "HTTP Response: " . ($result_after['winner'] ? "200 (Bid)" : "204 (No Bid)") . "\n\n";

echo "Test 3: Auction Logic Test\n";
echo "--------------------------\n";
// Test auction logic with multiple bidders
$auction_campaigns = [
    [
        'campaign_id' => 6,
        'type' => 'ron',
        'status' => 'active',
        'creatives' => [
            ['width' => 300, 'height' => 250, 'bid_amount' => 0.0094, 'status' => 'active']
        ]
    ],
    [
        'campaign_id' => 7,
        'type' => 'rtb',
        'status' => 'active',
        'creatives' => [
            ['width' => 300, 'height' => 250, 'bid_amount' => 0.05, 'status' => 'active']
        ]
    ],
    [
        'campaign_id' => 8,
        'type' => 'rtb',
        'status' => 'active',
        'creatives' => [
            ['width' => 300, 'height' => 250, 'bid_amount' => 0.03, 'status' => 'active']
        ]
    ]
];

$auction_result = simulateRTBBidding($test_request, $auction_campaigns);
echo "Auction participants:\n";
foreach ($auction_result['all_candidates'] as $candidate) {
    echo "  - Campaign {$candidate['campaign_id']} ({$candidate['type']}): \${$candidate['bid_amount']}\n";
}
echo "Winner: Campaign {$auction_result['winner']['campaign_id']} ({$auction_result['winner']['type']}) with highest bid \${$auction_result['winner']['bid_amount']}\n";

echo "\nTest Complete!\n";

/**
 * Simulate RTB bidding logic
 */
function simulateRTBBidding($request, $campaigns) {
    $imp = $request['imp'][0];
    $width = $imp['banner']['w'];
    $height = $imp['banner']['h'];
    
    $rtb_campaigns = [];
    $ron_campaigns = [];
    $all_candidates = [];
    
    foreach ($campaigns as $campaign) {
        if ($campaign['status'] !== 'active') continue;
        
        foreach ($campaign['creatives'] as $creative) {
            if ($creative['status'] !== 'active') continue;
            if ($creative['width'] != $width || $creative['height'] != $height) continue;
            
            $candidate = array_merge($campaign, $creative);
            $all_candidates[] = $candidate;
            
            if ($campaign['type'] === 'rtb') {
                $rtb_campaigns[] = $candidate;
            } else {
                $ron_campaigns[] = $candidate;
            }
        }
    }
    
    // Sort by bid amount (highest first)
    usort($all_candidates, function($a, $b) {
        return $b['bid_amount'] <=> $a['bid_amount'];
    });
    
    $winner = !empty($all_candidates) ? $all_candidates[0] : null;
    
    return [
        'rtb_campaigns' => $rtb_campaigns,
        'ron_campaigns' => $ron_campaigns,
        'all_candidates' => $all_candidates,
        'winner' => $winner
    ];
}
?>