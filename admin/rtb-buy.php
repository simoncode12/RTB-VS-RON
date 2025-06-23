<?php
include 'includes/header.php';

$message = '';
$message_type = 'success';

// Get websites and zones for endpoint generation
$websites = $pdo->query("
    SELECT w.*, p.name as publisher_name,
           COUNT(z.id) as zone_count
    FROM websites w 
    LEFT JOIN publishers p ON w.publisher_id = p.id 
    LEFT JOIN zones z ON w.id = z.website_id AND z.status = 'active'
    WHERE w.status = 'active' 
    GROUP BY w.id
    ORDER BY w.name
")->fetchAll();

$zones = $pdo->query("
    SELECT z.*, w.name as website_name, w.domain, p.name as publisher_name
    FROM zones z 
    LEFT JOIN websites w ON z.website_id = w.id 
    LEFT JOIN publishers p ON w.publisher_id = p.id 
    WHERE z.status = 'active' AND w.status = 'active'
    ORDER BY w.name, z.name
")->fetchAll();

// Handle endpoint generation
$generated_endpoints = [];
if ($_POST) {
    $selected_formats = $_POST['formats'] ?? [];
    $selected_websites = $_POST['websites'] ?? [];
    $selected_zones = $_POST['zones'] ?? [];
    
    if (!empty($selected_formats)) {
        foreach ($selected_formats as $format) {
            $base_url = "https://up.adstart.click/rtb/endpoint.php";
            
            if (!empty($selected_websites)) {
                foreach ($selected_websites as $website_id) {
                    $website = array_filter($websites, fn($w) => $w['id'] == $website_id)[0] ?? null;
                    if ($website) {
                        $params = [
                            'format' => $format,
                            'website_id' => $website_id,
                            'domain' => $website['domain']
                        ];
                        
                        $generated_endpoints[] = [
                            'url' => $base_url . '?' . http_build_query($params),
                            'type' => 'Website',
                            'target' => $website['name'] . ' (' . $website['domain'] . ')',
                            'format' => $format
                        ];
                    }
                }
            }
            
            if (!empty($selected_zones)) {
                foreach ($selected_zones as $zone_id) {
                    $zone = array_filter($zones, fn($z) => $z['id'] == $zone_id)[0] ?? null;
                    if ($zone) {
                        $params = [
                            'format' => $format,
                            'zone_id' => $zone_id,
                            'size' => $zone['size']
                        ];
                        
                        $generated_endpoints[] = [
                            'url' => $base_url . '?' . http_build_query($params),
                            'type' => 'Zone',
                            'target' => $zone['website_name'] . ' - ' . $zone['name'] . ' (' . $zone['size'] . ')',
                            'format' => $format
                        ];
                    }
                }
            }
            
            // If no specific targets selected, generate generic endpoint
            if (empty($selected_websites) && empty($selected_zones)) {
                $params = ['format' => $format];
                $generated_endpoints[] = [
                    'url' => $base_url . '?' . http_build_query($params),
                    'type' => 'Generic',
                    'target' => 'All available inventory',
                    'format' => $format
                ];
            }
        }
        
        $message = count($generated_endpoints) . ' endpoint(s) generated successfully!';
        $message_type = 'success';
    }
}
?>

<div class="row">
    <div class="col-12">
        <h1 class="h3 mb-4">
            <i class="fas fa-link"></i> RTB Endpoint Generator
            <small class="text-muted">Generate RTB endpoints for buyers</small>
        </h1>
    </div>
</div>

<?php if ($message): ?>
    <div class="alert alert-<?php echo $message_type; ?> alert-dismissible fade show">
        <?php echo htmlspecialchars($message); ?>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
<?php endif; ?>

<div class="row">
    <!-- Endpoint Generator Form -->
    <div class="col-lg-6 mb-4">
        <div class="card">
            <div class="card-header">
                <h5 class="mb-0"><i class="fas fa-cog"></i> Generate RTB Endpoints</h5>
            </div>
            <div class="card-body">
                <form method="POST">
                    <div class="mb-4">
                        <label class="form-label"><strong>Select Ad Formats *</strong></label>
                        <div class="row">
                            <div class="col-6 mb-2">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="format_banner" name="formats[]" value="banner">
                                    <label class="form-check-label" for="format_banner">
                                        <i class="fas fa-image"></i> Banner Ads
                                    </label>
                                </div>
                            </div>
                            <div class="col-6 mb-2">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="format_video" name="formats[]" value="video">
                                    <label class="form-check-label" for="format_video">
                                        <i class="fas fa-video"></i> Video Ads
                                    </label>
                                </div>
                            </div>
                            <div class="col-6 mb-2">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="format_native" name="formats[]" value="native">
                                    <label class="form-check-label" for="format_native">
                                        <i class="fas fa-newspaper"></i> Native Ads
                                    </label>
                                </div>
                            </div>
                            <div class="col-6 mb-2">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="format_mobile" name="formats[]" value="mobile">
                                    <label class="form-check-label" for="format_mobile">
                                        <i class="fas fa-mobile-alt"></i> Mobile Ads
                                    </label>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="mb-4">
                        <label class="form-label"><strong>Target Websites (Optional)</strong></label>
                        <div class="form-text mb-2">Select specific websites to target, or leave empty for all websites</div>
                        <?php if (empty($websites)): ?>
                            <div class="alert alert-warning">
                                <i class="fas fa-exclamation-triangle"></i> No active websites found. 
                                <a href="website.php">Add websites first</a>.
                            </div>
                        <?php else: ?>
                            <div style="max-height: 200px; overflow-y: auto; border: 1px solid #dee2e6; border-radius: 0.375rem; padding: 10px;">
                                <?php foreach ($websites as $website): ?>
                                    <div class="form-check mb-1">
                                        <input class="form-check-input" type="checkbox" 
                                               id="website_<?php echo $website['id']; ?>" 
                                               name="websites[]" value="<?php echo $website['id']; ?>">
                                        <label class="form-check-label" for="website_<?php echo $website['id']; ?>">
                                            <strong><?php echo htmlspecialchars($website['name']); ?></strong>
                                            <br>
                                            <small class="text-muted">
                                                <?php echo htmlspecialchars($website['domain']); ?> 
                                                (<?php echo $website['zone_count']; ?> zones) - 
                                                <?php echo htmlspecialchars($website['publisher_name']); ?>
                                            </small>
                                        </label>
                                    </div>
                                <?php endforeach; ?>
                            </div>
                        <?php endif; ?>
                    </div>
                    
                    <div class="mb-4">
                        <label class="form-label"><strong>Target Zones (Optional)</strong></label>
                        <div class="form-text mb-2">Select specific ad zones to target</div>
                        <?php if (empty($zones)): ?>
                            <div class="alert alert-warning">
                                <i class="fas fa-exclamation-triangle"></i> No active zones found. 
                                <a href="zone.php">Add zones first</a>.
                            </div>
                        <?php else: ?>
                            <div style="max-height: 200px; overflow-y: auto; border: 1px solid #dee2e6; border-radius: 0.375rem; padding: 10px;">
                                <?php foreach ($zones as $zone): ?>
                                    <div class="form-check mb-1">
                                        <input class="form-check-input" type="checkbox" 
                                               id="zone_<?php echo $zone['id']; ?>" 
                                               name="zones[]" value="<?php echo $zone['id']; ?>">
                                        <label class="form-check-label" for="zone_<?php echo $zone['id']; ?>">
                                            <strong><?php echo htmlspecialchars($zone['name']); ?></strong>
                                            <span class="badge bg-info"><?php echo $zone['size']; ?></span>
                                            <br>
                                            <small class="text-muted">
                                                <?php echo htmlspecialchars($zone['website_name']); ?> - 
                                                <?php echo htmlspecialchars($zone['publisher_name']); ?>
                                            </small>
                                        </label>
                                    </div>
                                <?php endforeach; ?>
                            </div>
                        <?php endif; ?>
                    </div>
                    
                    <button type="submit" class="btn btn-primary w-100">
                        <i class="fas fa-magic"></i> Generate Endpoints
                    </button>
                </form>
            </div>
        </div>
        
        <!-- RTB Integration Guide -->
        <div class="card mt-4">
            <div class="card-header">
                <h6 class="mb-0"><i class="fas fa-info-circle"></i> RTB Integration Guide</h6>
            </div>
            <div class="card-body">
                <div class="small">
                    <h6>How to use RTB endpoints:</h6>
                    <ol>
                        <li>Select the ad formats you want to support</li>
                        <li>Choose specific websites/zones or leave empty for all inventory</li>
                        <li>Generate the endpoints</li>
                        <li>Provide the endpoints to your RTB buyers</li>
                        <li>Buyers will send OpenRTB 2.5 formatted requests</li>
                    </ol>
                    
                    <h6 class="mt-3">Supported Features:</h6>
                    <ul>
                        <li>OpenRTB 2.5 compliance</li>
                        <li>Banner sizes: <?php echo implode(', ', array_keys(getBannerSizes())); ?></li>
                        <li>Geo targeting</li>
                        <li>Device targeting</li>
                        <li>Real-time bidding</li>
                        <li>Win notifications</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Generated Endpoints -->
    <div class="col-lg-6 mb-4">
        <?php if (!empty($generated_endpoints)): ?>
            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h5 class="mb-0"><i class="fas fa-link"></i> Generated Endpoints</h5>
                    <span class="badge bg-success"><?php echo count($generated_endpoints); ?> Generated</span>
                </div>
                <div class="card-body">
                    <?php foreach ($generated_endpoints as $endpoint): ?>
                        <div class="card mb-3">
                            <div class="card-header">
                                <div class="d-flex justify-content-between align-items-center">
                                    <span>
                                        <strong><?php echo htmlspecialchars($endpoint['target']); ?></strong>
                                        <span class="badge bg-primary"><?php echo strtoupper($endpoint['format']); ?></span>
                                    </span>
                                    <button class="btn btn-sm btn-outline-primary" onclick="copyToClipboard('<?php echo htmlspecialchars($endpoint['url']); ?>')">
                                        <i class="fas fa-copy"></i> Copy
                                    </button>
                                </div>
                            </div>
                            <div class="card-body">
                                <div class="input-group">
                                    <input type="text" class="form-control font-monospace small" 
                                           value="<?php echo htmlspecialchars($endpoint['url']); ?>" readonly>
                                    <button class="btn btn-outline-secondary" onclick="testEndpoint('<?php echo htmlspecialchars($endpoint['url']); ?>')">
                                        <i class="fas fa-play"></i> Test
                                    </button>
                                </div>
                                <div class="mt-2">
                                    <small class="text-muted">
                                        <strong>Type:</strong> <?php echo $endpoint['type']; ?> | 
                                        <strong>Format:</strong> <?php echo strtoupper($endpoint['format']); ?>
                                    </small>
                                </div>
                            </div>
                        </div>
                    <?php endforeach; ?>
                    
                    <div class="alert alert-info mt-3">
                        <i class="fas fa-lightbulb"></i> 
                        <strong>Pro Tip:</strong> Test your endpoints with the test button to ensure they're working correctly before sharing with buyers.
                    </div>
                </div>
            </div>
        <?php else: ?>
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0"><i class="fas fa-link"></i> Generated Endpoints</h5>
                </div>
                <div class="card-body text-center py-5">
                    <i class="fas fa-link fa-3x text-muted mb-3"></i>
                    <p class="text-muted">No endpoints generated yet.</p>
                    <p class="text-muted">Use the form on the left to generate RTB endpoints for your buyers.</p>
                </div>
            </div>
        <?php endif; ?>
        
        <!-- Example RTB Request -->
        <div class="card mt-4">
            <div class="card-header">
                <h6 class="mb-0"><i class="fas fa-code"></i> Example RTB Request</h6>
            </div>
            <div class="card-body">
                <pre class="small text-muted" style="font-size: 11px; max-height: 300px; overflow-y: auto;"><code>{
    "id": "d4b5c697-41f3-4c1c-a3d5-5fd01b5ef2aa",
    "at": 1,
    "imp": [
        {
            "id": "974090632",
            "banner": {
                "w": 300,
                "h": 250,
                "mimes": ["image/jpg", "image/png", "video/mp4"]
            }
        }
    ],
    "site": {
        "id": "12345",
        "domain": "example.com",
        "name": "Example Site",
        "cat": ["IAB25-3"]
    },
    "device": {
        "ua": "Mozilla/5.0...",
        "ip": "131.34.123.159",
        "geo": {
            "country": "US"
        }
    },
    "user": {
        "id": "57592f333f8983.043587162282415065"
    }
}</code></pre>
            </div>
        </div>
    </div>
</div>

<script>
function copyToClipboard(text) {
    navigator.clipboard.writeText(text).then(function() {
        // Show success message
        const toast = document.createElement('div');
        toast.className = 'toast align-items-center text-white bg-success border-0 position-fixed top-0 end-0 m-3';
        toast.style.zIndex = '9999';
        toast.innerHTML = `
            <div class="d-flex">
                <div class="toast-body">
                    <i class="fas fa-check"></i> Endpoint copied to clipboard!
                </div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" onclick="this.parentElement.parentElement.remove()"></button>
            </div>
        `;
        document.body.appendChild(toast);
        setTimeout(() => toast.remove(), 3000);
    });
}

function testEndpoint(url) {
    // Create a test RTB request
    const testRequest = {
        "id": "test-" + Date.now(),
        "at": 1,
        "imp": [
            {
                "id": "test-imp-1",
                "banner": {
                    "w": 300,
                    "h": 250,
                    "mimes": ["image/jpg", "image/png"]
                }
            }
        ],
        "site": {
            "id": "test-site",
            "domain": "test.com",
            "name": "Test Site"
        },
        "device": {
            "ua": navigator.userAgent,
            "ip": "127.0.0.1",
            "geo": {
                "country": "US"
            }
        },
        "user": {
            "id": "test-user-123"
        }
    };
    
    fetch(url, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(testRequest)
    })
    .then(response => {
        if (response.ok) {
            return response.json();
        } else if (response.status === 204) {
            throw new Error('No bid (HTTP 204) - This is normal if no matching campaigns');
        } else {
            throw new Error(`HTTP ${response.status}: ${response.statusText}`);
        }
    })
    .then(data => {
        alert('✅ Endpoint test successful!\n\nResponse: ' + JSON.stringify(data, null, 2));
    })
    .catch(error => {
        alert('⚠️ Endpoint test result:\n\n' + error.message);
    });
}

// Select all formats by default
document.addEventListener('DOMContentLoaded', function() {
    document.querySelectorAll('input[name="formats[]"]').forEach(function(checkbox) {
        checkbox.checked = true;
    });
});
</script>

<?php include 'includes/footer.php'; ?>