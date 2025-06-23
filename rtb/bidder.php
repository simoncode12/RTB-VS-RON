<?php
class RTBBidder {
    private $pdo;
    
    public function __construct($pdo) {
        $this->pdo = $pdo;
    }
    
    public function processBidRequest($request) {
        try {
            $request_id = $request['id'];
            $impressions = $request['imp'];
            
            if (empty($impressions)) {
                return null;
            }
            
            $seatbids = [];
            
            foreach ($impressions as $imp) {
                $bids = $this->findMatchingCampaigns($imp, $request);
                
                if (!empty($bids)) {
                    $seatbids[] = [
                        'bid' => $bids
                    ];
                }
            }
            
            if (empty($seatbids)) {
                return null; // No bid
            }
            
            return [
                'id' => $request_id,
                'seatbid' => $seatbids,
                'cur' => 'USD'
            ];
            
        } catch (Exception $e) {
            error_log('Bidder Error: ' . $e->getMessage());
            return null;
        }
    }
    
    private function findMatchingCampaigns($imp, $request) {
        $bids = [];
        
        // Extract impression details
        $imp_id = $imp['id'];
        $banner = $imp['banner'] ?? null;
        
        if (!$banner) {
            return $bids;
        }
        
        $width = $banner['w'] ?? 0;
        $height = $banner['h'] ?? 0;
        $size = $width . 'x' . $height;
        
        // Extract targeting data from request
        $country = $this->extractCountry($request);
        $device_type = $this->extractDeviceType($request);
        $browser = $this->extractBrowser($request);
        $os = $this->extractOS($request);
        
        // Find matching RTB campaigns
        $rtb_campaigns = $this->getMatchingRTBCampaigns($size, $country, $device_type, $browser, $os);
        
        // Find matching RON campaigns
        $ron_campaigns = $this->getMatchingRONCampaigns($size, $country, $device_type, $browser, $os);
        
        // Combine and sort by bid amount
        $all_campaigns = array_merge($rtb_campaigns, $ron_campaigns);
        
        // Sort by bid amount (highest first)
        usort($all_campaigns, function($a, $b) {
            return $b['bid_amount'] <=> $a['bid_amount'];
        });
        
        // Take the highest bidder
        if (!empty($all_campaigns)) {
            $winning_campaign = $all_campaigns[0];
            
            // Create bid response
            $bid = $this->createBidResponse($imp_id, $winning_campaign, $request);
            
            if ($bid) {
                $bids[] = $bid;
                
                // Log the bid
                $this->logBid($request['id'], $winning_campaign, $imp, $request);
            }
        }
        
        return $bids;
    }
    
    private function getMatchingRTBCampaigns($size, $country, $device_type, $browser, $os) {
        $sql = "
            SELECT c.*, cr.*, c.id as campaign_id, cr.id as creative_id, cr.bid_amount, 'rtb' as campaign_type
            FROM campaigns c
            JOIN creatives cr ON c.id = cr.campaign_id
            WHERE c.type = 'rtb' 
            AND c.status = 'active' 
            AND cr.status = 'active'
            AND (cr.width = ? AND cr.height = ?)
        ";
        
        $params = [];
        list($width, $height) = explode('x', $size);
        $params[] = (int)$width;
        $params[] = (int)$height;
        
        // Add targeting filters
        if ($country) {
            $sql .= " AND (c.target_countries IS NULL OR JSON_CONTAINS(c.target_countries, ?))";
            $params[] = json_encode($country);
        }
        
        if ($device_type) {
            $sql .= " AND (c.target_devices IS NULL OR JSON_CONTAINS(c.target_devices, ?))";
            $params[] = json_encode($device_type);
        }
        
        $sql .= " ORDER BY cr.bid_amount DESC";
        
        $stmt = $this->pdo->prepare($sql);
        $stmt->execute($params);
        
        return $stmt->fetchAll();
    }
    
    private function getMatchingRONCampaigns($size, $country, $device_type, $browser, $os) {
        $sql = "
            SELECT c.*, cr.*, c.id as campaign_id, cr.id as creative_id, cr.bid_amount, 'ron' as campaign_type
            FROM campaigns c
            JOIN creatives cr ON c.id = cr.campaign_id
            WHERE c.type = 'ron' 
            AND c.status = 'active' 
            AND cr.status = 'active'
            AND (cr.width = ? AND cr.height = ?)
        ";
        
        $params = [];
        list($width, $height) = explode('x', $size);
        $params[] = (int)$width;
        $params[] = (int)$height;
        
        // Add targeting filters (same as RTB)
        if ($country) {
            $sql .= " AND (c.target_countries IS NULL OR JSON_CONTAINS(c.target_countries, ?))";
            $params[] = json_encode($country);
        }
        
        if ($device_type) {
            $sql .= " AND (c.target_devices IS NULL OR JSON_CONTAINS(c.target_devices, ?))";
            $params[] = json_encode($device_type);
        }
        
        $sql .= " ORDER BY cr.bid_amount DESC";
        
        $stmt = $this->pdo->prepare($sql);
        $stmt->execute($params);
        
        return $stmt->fetchAll();
    }
    
    private function createBidResponse($imp_id, $campaign, $request) {
        try {
            // Generate bid ID
            $bid_id = uniqid('bid_');
            
            // Create ad markup based on creative type
            $adm = $this->createAdMarkup($campaign);
            
            if (!$adm) {
                return null;
            }
            
            // Create win notification URL
            $nurl = 'https://up.adstart.click/api/win-notify.php?bid_id=' . $bid_id . 
                   '&campaign_id=' . $campaign['campaign_id'] . 
                   '&creative_id=' . $campaign['creative_id'] . 
                   '&price=${AUCTION_PRICE}';
            
            return [
                'id' => $bid_id,
                'impid' => $imp_id,
                'price' => (float)$campaign['bid_amount'],
                'adm' => $adm,
                'nurl' => $nurl,
                'cid' => (string)$campaign['campaign_id'],
                'crid' => (string)$campaign['creative_id'],
                'w' => (int)$campaign['width'],
                'h' => (int)$campaign['height'],
                'ext' => [
                    'campaign_type' => $campaign['campaign_type']
                ]
            ];
            
        } catch (Exception $e) {
            error_log('Create bid response error: ' . $e->getMessage());
            return null;
        }
    }
    
    private function createAdMarkup($campaign) {
        switch ($campaign['creative_type']) {
            case 'image':
                return $this->createImageAdMarkup($campaign);
            case 'video':
                return $this->createVideoAdMarkup($campaign);
            case 'html5':
                return $this->createHtmlAdMarkup($campaign);
            default:
                return null;
        }
    }
    
    private function createImageAdMarkup($campaign) {
        if ($campaign['image_url'] && $campaign['click_url']) {
            // XML format for image ads
            return '<?xml version="1.0" encoding="ISO-8859-1"?>' . "\n" .
                   '<ad>' . "\n" .
                   '    <imageAd>' . "\n" .
                   '        <clickUrl><![CDATA[' . htmlspecialchars($campaign['click_url']) . ']]></clickUrl>' . "\n" .
                   '        <imgUrl><![CDATA[' . htmlspecialchars($campaign['image_url']) . ']]></imgUrl>' . "\n" .
                   '    </imageAd>' . "\n" .
                   '</ad>';
        }
        return null;
    }
    
    private function createVideoAdMarkup($campaign) {
        if ($campaign['video_url'] && $campaign['click_url']) {
            // XML format for video ads
            return '<?xml version="1.0" encoding="ISO-8859-1"?>' . "\n" .
                   '<ad>' . "\n" .
                   '    <videoAd>' . "\n" .
                   '        <clickUrl><![CDATA[' . htmlspecialchars($campaign['click_url']) . ']]></clickUrl>' . "\n" .
                   '        <videoUrl><![CDATA[' . htmlspecialchars($campaign['video_url']) . ']]></videoUrl>' . "\n" .
                   '    </videoAd>' . "\n" .
                   '</ad>';
        }
        return null;
    }
    
    private function createHtmlAdMarkup($campaign) {
        if ($campaign['html_content']) {
            return $campaign['html_content'];
        } elseif ($campaign['image_url'] && $campaign['click_url']) {
            // HTML format for image ads
            $click_tracking = 'https://up.adstart.click/api/click-track.php?campaign_id=' . $campaign['campaign_id'] . '&creative_id=' . $campaign['creative_id'];
            $impression_tracking = 'https://up.adstart.click/api/impression-track.php?campaign_id=' . $campaign['campaign_id'] . '&creative_id=' . $campaign['creative_id'];
            
            return '<a href="' . htmlspecialchars($click_tracking) . '" target="_blank" onclick="var href=\'' . htmlspecialchars($campaign['click_url']) . '\'; this.href = href + \'&clickX=\' + event.clientX + \'&clickY=\' + event.clientY;">' .
                   '<img width="' . $campaign['width'] . '" height="' . $campaign['height'] . '" src="' . htmlspecialchars($campaign['image_url']) . '" border="0" style="display:block;"></a>' .
                   '<img src="' . htmlspecialchars($impression_tracking) . '" width="1" height="1" border="0" />';
        }
        return null;
    }
    
    private function extractCountry($request) {
        $device = $request['device'] ?? [];
        $geo = $device['geo'] ?? [];
        return $geo['country'] ?? null;
    }
    
    private function extractDeviceType($request) {
        $device = $request['device'] ?? [];
        
        // Simple device detection based on user agent
        $ua = strtolower($device['ua'] ?? '');
        
        if (strpos($ua, 'mobile') !== false || strpos($ua, 'android') !== false || strpos($ua, 'iphone') !== false) {
            return 'mobile';
        } elseif (strpos($ua, 'tablet') !== false || strpos($ua, 'ipad') !== false) {
            return 'tablet';
        } else {
            return 'desktop';
        }
    }
    
    private function extractBrowser($request) {
        $device = $request['device'] ?? [];
        $ua = strtolower($device['ua'] ?? '');
        
        if (strpos($ua, 'chrome') !== false) return 'chrome';
        if (strpos($ua, 'firefox') !== false) return 'firefox';
        if (strpos($ua, 'safari') !== false) return 'safari';
        if (strpos($ua, 'edge') !== false) return 'edge';
        if (strpos($ua, 'opera') !== false) return 'opera';
        
        return 'unknown';
    }
    
    private function extractOS($request) {
        $device = $request['device'] ?? [];
        $ua = strtolower($device['ua'] ?? '');
        
        if (strpos($ua, 'windows') !== false) return 'windows';
        if (strpos($ua, 'macintosh') !== false || strpos($ua, 'mac os') !== false) return 'macos';
        if (strpos($ua, 'linux') !== false) return 'linux';
        if (strpos($ua, 'android') !== false) return 'android';
        if (strpos($ua, 'ios') !== false || strpos($ua, 'iphone') !== false || strpos($ua, 'ipad') !== false) return 'ios';
        
        return 'unknown';
    }
    
    private function logBid($request_id, $campaign, $imp, $request) {
        try {
            $device = $request['device'] ?? [];
            $geo = $device['geo'] ?? [];
            
            $stmt = $this->pdo->prepare("
                INSERT INTO bid_logs (
                    request_id, campaign_id, creative_id, bid_amount,
                    user_agent, ip_address, country, device_type, browser, os
                ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            ");
            
            $stmt->execute([
                $request_id,
                $campaign['campaign_id'],
                $campaign['creative_id'],
                $campaign['bid_amount'],
                $device['ua'] ?? '',
                $device['ip'] ?? '',
                $geo['country'] ?? '',
                $this->extractDeviceType($request),
                $this->extractBrowser($request),
                $this->extractOS($request)
            ]);
            
        } catch (Exception $e) {
            error_log('Log bid error: ' . $e->getMessage());
        }
    }
}
?>