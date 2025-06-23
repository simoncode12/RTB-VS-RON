# RTB Endpoint Fix Documentation

## Problem Summary
The RTB endpoint was returning HTTP 204 (No Bid) for 300x250 banner requests because:
1. No RTB campaigns had 300x250 creatives
2. Only RON campaigns contained 300x250 creatives
3. Missing database columns for budget tracking (`daily_spent`, `total_spent`)

## Solution Implementation

### 1. Database Migration

#### Step 1: Add Missing Columns
Run the migration to add spending tracking columns:

```sql
-- File: migrations/add_campaign_spending_columns.sql
ALTER TABLE campaigns 
ADD COLUMN daily_spent DECIMAL(10,2) DEFAULT 0.00 COMMENT 'Amount spent today for this campaign';

ALTER TABLE campaigns
ADD COLUMN total_spent DECIMAL(10,2) DEFAULT 0.00 COMMENT 'Total amount spent for this campaign';

ALTER TABLE campaigns 
ADD INDEX idx_daily_spent (daily_spent),
ADD INDEX idx_total_spent (total_spent);

UPDATE campaigns SET daily_spent = 0.00, total_spent = 0.00 WHERE daily_spent IS NULL OR total_spent IS NULL;
```

#### Step 2: Add RTB Test Campaign
Run the test data insertion:

```sql
-- File: migrations/insert_rtb_test_data.sql
INSERT INTO campaigns (
    advertiser_id, name, type, category_id, bid_type,
    daily_budget, total_budget, start_date, end_date, status,
    endpoint_url, target_countries, target_browsers, target_devices,
    target_os, banner_sizes, daily_spent, total_spent
) VALUES (
    1, 'RTB Test Campaign 300x250', 'rtb', 1, 'cpm',
    100.00, 1000.00, '2025-01-07', '2025-12-31', 'active',
    NULL, NULL, NULL, NULL, NULL, '["300x250"]', 0.00, 0.00
);

INSERT INTO creatives (
    campaign_id, name, width, height, bid_amount, creative_type,
    image_url, click_url, status
) VALUES (
    LAST_INSERT_ID(), 'RTB Test Creative 300x250', 300, 250, 0.05, 'image',
    'https://via.placeholder.com/300x250/0099ff/ffffff?text=RTB+Test+Ad',
    'https://example.com/rtb-test-click', 'active'
);
```

### 2. Apply Migrations

#### Option A: Manual Database Update
1. Connect to your database
2. Run each migration file in order:
   - `migrations/add_campaign_spending_columns.sql`
   - `migrations/insert_rtb_test_data.sql`

#### Option B: Use Migration Runner
```bash
php test/run_migrations.php
```

### 3. Verification

#### Database Validation
```bash
php test/database_validation.php
```
Expected output:
- ✅ daily_spent column exists
- ✅ total_spent column exists 
- ✅ RTB test campaign created with 300x250 creative

#### Logic Testing
```bash
php test/rtb_logic_test.php
```
Expected output:
- Before fix: Only RON campaigns win
- After fix: RTB campaigns win with higher bid ($0.05 > $0.0094)

#### Mock Endpoint Testing
```bash
php test/mock_rtb_test.php
```
Expected output:
- 300x250 requests return HTTP 200 with RTB campaign bid
- RTB campaign wins auction with $0.05 bid

### 4. Real Environment Testing

#### Start Local Server
```bash
php -S localhost:8000
```

#### Test RTB Endpoint
```bash
curl -X POST http://localhost:8000/rtb/endpoint.php \
  -H "Content-Type: application/json" \
  -d '{
    "id": "test_300x250",
    "imp": [{
      "id": "1",
      "banner": {"w": 300, "h": 250}
    }],
    "device": {
      "ua": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36",
      "geo": {"country": "US"}
    }
  }'
```

Expected response:
```json
{
  "id": "test_300x250",
  "seatbid": [{
    "bid": [{
      "id": "bid_...",
      "impid": "1",
      "price": 0.05,
      "adm": "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>...",
      "nurl": "https://up.adstart.click/api/win-notify.php?...",
      "cid": "7",
      "crid": "8",
      "w": 300,
      "h": 250,
      "ext": {"campaign_type": "rtb"}
    }]
  }],
  "cur": "USD"
}
```

## How the Fix Works

### Before Fix
1. RTB request for 300x250 comes in
2. RTB bidder looks for RTB campaigns with 300x250 creatives
3. Finds none (Campaign 5 exists but has no creatives)
4. Looks for RON campaigns with 300x250 creatives  
5. Finds Campaign 6 with Creative 1 (300x250)
6. Returns bid from RON campaign

### After Fix
1. RTB request for 300x250 comes in
2. RTB bidder looks for RTB campaigns with 300x250 creatives
3. Finds new RTB Test Campaign (ID 7) with Creative 8 (300x250, $0.05 bid)
4. Also finds RON Campaign 6 with Creative 1 (300x250, $0.0094 bid)
5. Auction logic compares bids: $0.05 (RTB) > $0.0094 (RON)
6. Returns winning RTB campaign bid

### Auction Logic
The system now properly supports both RTB and RON campaigns:
- Both campaign types are evaluated for each request
- Campaigns are sorted by bid amount (highest first)
- Winning campaign (highest bidder) gets the impression
- RTB campaigns can compete against RON campaigns
- Higher bids win regardless of campaign type

## Budget Tracking Support
The new `daily_spent` and `total_spent` columns enable:
- Real-time budget monitoring
- Campaign pause when daily/total limits reached
- Spending analytics and reporting
- Bid pacing algorithms

## Files Changed
- `migrations/add_campaign_spending_columns.sql` - Database schema update
- `migrations/insert_rtb_test_data.sql` - Test campaign data
- `test/database_validation.php` - Database validation script
- `test/rtb_logic_test.php` - Standalone logic testing
- `test/mock_rtb_test.php` - Mock endpoint testing
- `test/run_migrations.php` - Migration runner
- `test/rtb_endpoint_test.php` - Real endpoint testing

## Production Deployment
1. Backup database
2. Apply migrations during maintenance window
3. Verify RTB endpoint returns 200 for 300x250 requests
4. Monitor campaign performance and bid logs
5. Replace test campaign with real advertiser campaigns as needed

The test campaign can be disabled or replaced with real advertiser RTB campaigns once the fix is verified to work correctly.