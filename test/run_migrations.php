<?php
/**
 * Migration Runner Script
 * Applies database migrations safely with rollback support
 */

require_once __DIR__ . '/../config/database.php';

echo "RTB Database Migration Runner\n";
echo "=============================\n\n";

// List of migration files to apply
$migrations = [
    'add_campaign_spending_columns.sql',
    'insert_rtb_test_data.sql'
];

foreach ($migrations as $migration_file) {
    $file_path = __DIR__ . '/../migrations/' . $migration_file;
    
    if (!file_exists($file_path)) {
        echo "❌ Migration file not found: $migration_file\n";
        continue;
    }
    
    echo "Applying migration: $migration_file\n";
    echo str_repeat('-', 50) . "\n";
    
    $sql = file_get_contents($file_path);
    
    try {
        // Begin transaction for safety
        $pdo->beginTransaction();
        
        // Split SQL statements by semicolon and execute each
        $statements = array_filter(array_map('trim', explode(';', $sql)));
        
        foreach ($statements as $statement) {
            if (empty($statement) || strpos($statement, '--') === 0) {
                continue; // Skip empty lines and comments
            }
            
            echo "Executing: " . substr($statement, 0, 60) . "...\n";
            $pdo->exec($statement);
        }
        
        $pdo->commit();
        echo "✅ Migration applied successfully!\n\n";
        
    } catch (Exception $e) {
        $pdo->rollBack();
        echo "❌ Migration failed: " . $e->getMessage() . "\n";
        echo "All changes rolled back.\n\n";
        break;
    }
}

echo "Migration complete!\n";

// Verify the changes
echo "\nVerification:\n";
echo "=============\n";

try {
    // Check if new columns exist
    $stmt = $pdo->query("SHOW COLUMNS FROM campaigns LIKE 'daily_spent'");
    if ($stmt->rowCount() > 0) {
        echo "✅ daily_spent column added\n";
    }
    
    $stmt = $pdo->query("SHOW COLUMNS FROM campaigns LIKE 'total_spent'");
    if ($stmt->rowCount() > 0) {
        echo "✅ total_spent column added\n";
    }
    
    // Check for RTB test campaign
    $stmt = $pdo->query("
        SELECT c.id, c.name, COUNT(cr.id) as creative_count
        FROM campaigns c
        LEFT JOIN creatives cr ON c.id = cr.campaign_id
        WHERE c.type = 'rtb' AND c.name LIKE '%Test%'
        GROUP BY c.id
    ");
    
    $test_campaigns = $stmt->fetchAll();
    if (!empty($test_campaigns)) {
        foreach ($test_campaigns as $campaign) {
            echo "✅ RTB test campaign created: {$campaign['name']} (ID: {$campaign['id']}) with {$campaign['creative_count']} creative(s)\n";
        }
    }
    
} catch (Exception $e) {
    echo "❌ Verification failed: " . $e->getMessage() . "\n";
}
?>