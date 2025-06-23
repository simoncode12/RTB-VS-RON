-- Test Data: Create RTB campaign with 300x250 creative for testing
-- Date: 2025-01-07  
-- Purpose: Add test RTB campaign and creative to fix HTTP 204 issue

-- Create RTB Test Campaign
INSERT INTO campaigns (
    advertiser_id, 
    name, 
    type, 
    category_id, 
    bid_type,
    daily_budget, 
    total_budget, 
    start_date, 
    end_date, 
    status,
    endpoint_url, 
    target_countries, 
    target_browsers, 
    target_devices,
    target_os, 
    banner_sizes,
    daily_spent,
    total_spent
) VALUES (
    1, 
    'RTB Test Campaign 300x250', 
    'rtb', 
    1, 
    'cpm',
    100.00, 
    1000.00, 
    '2025-01-07', 
    '2025-12-31', 
    'active',
    NULL, 
    NULL, 
    NULL, 
    NULL,
    NULL, 
    '["300x250"]',
    0.00,
    0.00
);

-- Get the campaign ID for the creative (assuming it will be the next auto-increment ID)
SET @campaign_id = LAST_INSERT_ID();

-- Create 300x250 Image Creative for RTB Campaign
INSERT INTO creatives (
    campaign_id,
    name,
    width,
    height, 
    bid_amount,
    creative_type,
    image_url,
    video_url,
    html_content,
    click_url,
    status
) VALUES (
    @campaign_id,
    'RTB Test Creative 300x250',
    300,
    250,
    0.05,
    'image',
    'https://via.placeholder.com/300x250/0099ff/ffffff?text=RTB+Test+Ad',
    NULL,
    NULL,
    'https://example.com/rtb-test-click',
    'active'
);

-- Verify the insertion
SELECT 
    c.id as campaign_id,
    c.name as campaign_name,
    c.type,
    cr.id as creative_id, 
    cr.name as creative_name,
    cr.width,
    cr.height,
    cr.bid_amount,
    cr.creative_type
FROM campaigns c
JOIN creatives cr ON c.id = cr.campaign_id  
WHERE c.type = 'rtb' AND c.name = 'RTB Test Campaign 300x250';