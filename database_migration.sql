-- Database Migration Script: Add missing columns to campaigns table
-- Date: 2025-06-24
-- Purpose: Fix RTB endpoint by adding required daily_spent and total_spent columns

-- Add missing columns to campaigns table
ALTER TABLE campaigns 
ADD COLUMN daily_spent DECIMAL(10,2) DEFAULT 0.00 AFTER total_budget,
ADD COLUMN total_spent DECIMAL(10,2) DEFAULT 0.00 AFTER daily_spent;

-- Verify the columns were added
DESCRIBE campaigns;

-- Initialize existing campaigns with zero spent values
UPDATE campaigns SET daily_spent = 0.00, total_spent = 0.00 WHERE daily_spent IS NULL OR total_spent IS NULL;

-- Add an RTB creative for Campaign ID 5 (300x250 size) for testing
INSERT INTO creatives (
    campaign_id, 
    name, 
    width, 
    height, 
    bid_amount, 
    creative_type, 
    image_url, 
    html_content, 
    click_url, 
    status
) VALUES (
    5,
    'RTB 300x250',
    300,
    250,
    0.015,
    'html5',
    '',
    '<div style="width:300px;height:250px;background:#f0f0f0;border:1px solid #ccc;display:flex;align-items:center;justify-content:center;font-family:Arial,sans-serif;"><span style="color:#666;">RTB Test Ad 300x250</span></div>',
    'https://adstart.click/rtb-test',
    'active'
);

-- Show current campaigns and their creatives
SELECT 
    c.id as campaign_id,
    c.name as campaign_name,
    c.type as campaign_type,
    c.status as campaign_status,
    cr.id as creative_id,
    cr.name as creative_name,
    CONCAT(cr.width, 'x', cr.height) as size,
    cr.bid_amount,
    cr.status as creative_status
FROM campaigns c
LEFT JOIN creatives cr ON c.id = cr.campaign_id
WHERE c.id IN (5, 6)
ORDER BY c.id, cr.id;