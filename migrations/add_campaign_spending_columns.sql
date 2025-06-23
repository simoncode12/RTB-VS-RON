-- Migration: Add missing columns to campaigns table for budget tracking
-- Date: 2025-01-07
-- Purpose: Add daily_spent and total_spent columns to campaigns table for RTB budget management

-- Add daily_spent column
ALTER TABLE campaigns 
ADD COLUMN daily_spent DECIMAL(10,2) DEFAULT 0.00 COMMENT 'Amount spent today for this campaign';

-- Add total_spent column  
ALTER TABLE campaigns
ADD COLUMN total_spent DECIMAL(10,2) DEFAULT 0.00 COMMENT 'Total amount spent for this campaign';

-- Add index for spending queries
ALTER TABLE campaigns 
ADD INDEX idx_daily_spent (daily_spent),
ADD INDEX idx_total_spent (total_spent);

-- Update existing campaigns to have 0.00 spending
UPDATE campaigns SET daily_spent = 0.00, total_spent = 0.00 WHERE daily_spent IS NULL OR total_spent IS NULL;