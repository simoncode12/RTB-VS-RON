<?php
/**
 * Database Validation Script
 * Checks current database state before applying migrations
 */

require_once __DIR__ . '/../config/database.php';

echo "Database Validation Script\n";
echo "==========================\n\n";

// Check if we can connect to database
try {
    $pdo->query("SELECT 1");
    echo "✅ Database connection successful\n\n";
} catch (Exception $e) {
    echo "❌ Database connection failed: " . $e->getMessage() . "\n";
    exit(1);
}

// Check campaigns table structure
echo "Current campaigns table structure:\n";
echo "----------------------------------\n";
$stmt = $pdo->query("DESCRIBE campaigns");
$columns = $stmt->fetchAll();

$has_daily_spent = false;
$has_total_spent = false;

foreach ($columns as $column) {
    echo "- {$column['Field']} ({$column['Type']}) {$column['Null']} {$column['Default']}\n";
    if ($column['Field'] === 'daily_spent') $has_daily_spent = true;
    if ($column['Field'] === 'total_spent') $has_total_spent = true;
}

echo "\n";

// Check for missing columns
if (!$has_daily_spent) {
    echo "❌ Missing column: daily_spent\n";
} else {
    echo "✅ Column exists: daily_spent\n";
}

if (!$has_total_spent) {
    echo "❌ Missing column: total_spent\n";
} else {
    echo "✅ Column exists: total_spent\n";
}

echo "\n";

// Check current campaigns data
echo "Current campaigns:\n";
echo "-----------------\n";
$stmt = $pdo->query("
    SELECT id, name, type, status, 
           COALESCE(daily_spent, 'NULL') as daily_spent,
           COALESCE(total_spent, 'NULL') as total_spent
    FROM campaigns 
    ORDER BY id
");

$campaigns = $stmt->fetchAll();
foreach ($campaigns as $campaign) {
    echo "- Campaign {$campaign['id']}: {$campaign['name']} ({$campaign['type']}, {$campaign['status']})\n";
    echo "  Daily spent: {$campaign['daily_spent']}, Total spent: {$campaign['total_spent']}\n";
}

echo "\n";

// Check RTB campaigns with creatives
echo "RTB campaigns with creatives:\n";
echo "-----------------------------\n";
$stmt = $pdo->query("
    SELECT c.id, c.name, c.type, COUNT(cr.id) as creative_count,
           GROUP_CONCAT(CONCAT(cr.width, 'x', cr.height) SEPARATOR ', ') as sizes
    FROM campaigns c
    LEFT JOIN creatives cr ON c.id = cr.campaign_id AND cr.status = 'active'
    WHERE c.type = 'rtb' AND c.status = 'active'
    GROUP BY c.id
    ORDER BY c.id
");

$rtb_campaigns = $stmt->fetchAll();
if (empty($rtb_campaigns)) {
    echo "❌ No active RTB campaigns found!\n";
} else {
    foreach ($rtb_campaigns as $campaign) {
        echo "- Campaign {$campaign['id']}: {$campaign['name']} ({$campaign['creative_count']} creatives)\n";
        if ($campaign['creative_count'] > 0) {
            echo "  Sizes: {$campaign['sizes']}\n";
        } else {
            echo "  ❌ No active creatives!\n";
        }
    }
}

echo "\n";

// Check RON campaigns with creatives
echo "RON campaigns with creatives:\n";
echo "----------------------------\n";
$stmt = $pdo->query("
    SELECT c.id, c.name, c.type, COUNT(cr.id) as creative_count,
           GROUP_CONCAT(CONCAT(cr.width, 'x', cr.height) SEPARATOR ', ') as sizes
    FROM campaigns c
    LEFT JOIN creatives cr ON c.id = cr.campaign_id AND cr.status = 'active'
    WHERE c.type = 'ron' AND c.status = 'active'
    GROUP BY c.id
    ORDER BY c.id
");

$ron_campaigns = $stmt->fetchAll();
if (empty($ron_campaigns)) {
    echo "❌ No active RON campaigns found!\n";
} else {
    foreach ($ron_campaigns as $campaign) {
        echo "- Campaign {$campaign['id']}: {$campaign['name']} ({$campaign['creative_count']} creatives)\n";
        if ($campaign['creative_count'] > 0) {
            echo "  Sizes: {$campaign['sizes']}\n";
        }
    }
}

echo "\nValidation complete!\n";
?>