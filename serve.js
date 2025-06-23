/**
 * AdStart RTB & RON Platform - Ad Serving Script
 * Version: 1.1.0
 * Last Updated: 2025-06-23 20:12:20
 * Current User: simoncode12
 */

(function() {
    // Get current script tag
    var currentScript = document.currentScript || (function() {
        var scripts = document.getElementsByTagName('script');
        return scripts[scripts.length - 1];
    })();
    
    // Check if required zone parameters exist
    if (typeof ad_zone_id === 'undefined') {
        console.error('AdStart: Missing required zone_id parameter');
        return;
    }
    
    // Get size from parameters
    var ad_zone_width = window.ad_zone_width || '';
    var ad_zone_height = window.ad_zone_height || '';
    var ad_zone_type = window.ad_zone_type || 'banner';
    
    // If width and height are provided, use them
    if (ad_zone_width && ad_zone_height) {
        ad_zone_width = parseInt(ad_zone_width);
        ad_zone_height = parseInt(ad_zone_height);
    }
    
    // Create a unique ID for this ad instance
    var adContainerId = 'adstart-ad-' + Math.random().toString(36).substr(2, 9);
    var adCallbackId = Math.random().toString(36).substr(2, 9);
    
    // Create ad container
    var adContainer = document.createElement('div');
    adContainer.id = adContainerId;
    adContainer.className = 'adstart-ad-container';
    
    // Set initial styles
    adContainer.style.overflow = 'hidden';
    adContainer.style.position = 'relative';
    adContainer.style.boxSizing = 'border-box';
    adContainer.style.display = 'inline-block';
    adContainer.style.lineHeight = 'normal';
    adContainer.style.verticalAlign = 'top';
    adContainer.style.backgroundColor = '#ffffff';
    
    // If dimensions are known, set them
    if (ad_zone_width && ad_zone_height) {
        adContainer.style.width = ad_zone_width + 'px';
        adContainer.style.height = ad_zone_height + 'px';
    }
    
    // Insert container into DOM
    currentScript.parentNode.insertBefore(adContainer, currentScript);
    
    // Helper function to create and execute scripts
    function createScript(src, content, attributes) {
        var script = document.createElement('script');
        
        if (attributes) {
            for (var key in attributes) {
                script.setAttribute(key, attributes[key]);
            }
        }
        
        if (src) {
            script.src = src;
            script.async = true;
        } else if (content) {
            script.textContent = content;
        }
        
        return script;
    }
    
    // Define the global function to receive ad content
    window['adstart_display_' + adCallbackId] = function(adHtml, impressionUrl, clickUrl, dimensions) {
        console.log('AdStart: Display callback called for container ' + adCallbackId);
        
        // If dimensions are provided by server, use them
        if (dimensions && dimensions.width && dimensions.height) {
            adContainer.style.width = dimensions.width + 'px';
            adContainer.style.height = dimensions.height + 'px';
            console.log('AdStart: Set dimensions: ' + dimensions.width + 'x' + dimensions.height);
        }
        
        // Clear container
        adContainer.innerHTML = '';
        
        // Create a wrapper div
        var adWrapper = document.createElement('div');
        adWrapper.style.width = '100%';
        adWrapper.style.height = '100%';
        adWrapper.style.position = 'relative';
        adWrapper.className = 'adstart-wrapper-' + adCallbackId;
        
        // Parse and inject the HTML
        var tempDiv = document.createElement('div');
        tempDiv.innerHTML = adHtml;
        
        // Extract scripts to execute them separately
        var scripts = [];
        var scriptElements = tempDiv.getElementsByTagName('script');
        
        // Collect scripts before modifying DOM
        for (var i = 0; i < scriptElements.length; i++) {
            scripts.push({
                src: scriptElements[i].src,
                content: scriptElements[i].innerHTML,
                async: scriptElements[i].async,
                type: scriptElements[i].type || 'text/javascript'
            });
        }
        
        // Remove scripts from temp div
        while (tempDiv.getElementsByTagName('script').length > 0) {
            tempDiv.getElementsByTagName('script')[0].remove();
        }
        
        // Add the HTML content without scripts
        adWrapper.innerHTML = tempDiv.innerHTML;
        adContainer.appendChild(adWrapper);
        
        // Execute scripts in order
        scripts.forEach(function(scriptInfo, index) {
            setTimeout(function() {
                var newScript = createScript(scriptInfo.src, scriptInfo.content, {
                    type: scriptInfo.type,
                    async: scriptInfo.async
                });
                adWrapper.appendChild(newScript);
                console.log('AdStart: Executed script ' + (index + 1) + ' of ' + scripts.length);
            }, index * 50);
        });
        
        // Track impression
        if (impressionUrl) {
            setTimeout(function() {
                var img = new Image();
                img.src = impressionUrl + '&t=' + new Date().getTime();
                console.log('AdStart: Impression tracked');
            }, 500);
        }
        
        // Add click tracking
        if (clickUrl) {
            setTimeout(function() {
                adWrapper.addEventListener('click', function(e) {
                    if (e.target.tagName === 'A' || e.target.closest('a')) {
                        var clickImg = new Image();
                        clickImg.src = clickUrl + '&t=' + new Date().getTime();
                        console.log('AdStart: Click tracked');
                    }
                }, true);
            }, 1000);
        }
        
        // Add GDPR compliance notice
        setTimeout(function() {
            var gdprNotice = document.createElement('div');
            gdprNotice.style.position = 'absolute';
            gdprNotice.style.bottom = '0';
            gdprNotice.style.right = '0';
            gdprNotice.style.backgroundColor = 'rgba(0, 0, 0, 0.7)';
            gdprNotice.style.color = 'white';
            gdprNotice.style.fontSize = '8px';
            gdprNotice.style.padding = '2px 4px';
            gdprNotice.style.borderTopLeftRadius = '3px';
            gdprNotice.style.zIndex = '999999';
            gdprNotice.style.pointerEvents = 'none';
            gdprNotice.innerHTML = 'Ad';
            adContainer.appendChild(gdprNotice);
        }, 1000);
    };
    
    // Display a fallback ad
    function displayFallbackAd(width, height) {
        var w = width || 300;
        var h = height || 250;
        
        adContainer.style.width = w + 'px';
        adContainer.style.height = h + 'px';
        
        adContainer.innerHTML = '<div style="width:100%; height:100%; display:flex; flex-direction:column; align-items:center; justify-content:center; text-align:center; color:#666; font-family:Arial,sans-serif; background:#f8f9fa; border:1px solid #e0e0e0;">' +
            '<div style="font-size:14px; font-weight:bold; margin-bottom:5px;">Ad Space Available</div>' +
            '<div style="font-size:12px;">Advertise Here</div>' +
            '<div style="font-size:10px; margin-top:5px; color:#999;">RTB & RON Platform</div>' +
            '<div style="font-size:9px; margin-top:10px; color:#bbb;">' + w + ' x ' + h + '</div>' +
            '</div>';
    }
    
    // Ad request function
    function requestAd() {
        console.log('AdStart: Requesting ad for zone ' + ad_zone_id);
        
        // Show loading indicator
        var loadingHtml = '<div style="width:100%; height:100%; min-height:50px; display:flex; align-items:center; justify-content:center; background:#ffffff;">' +
            '<style>@keyframes adstart-spin-' + adCallbackId + '{to{transform:rotate(360deg)}}</style>' +
            '<div style="width:30px; height:30px; border:3px solid #f3f3f3; border-top:3px solid #3498db; border-radius:50%; animation:adstart-spin-' + adCallbackId + ' 1s linear infinite;"></div>' +
            '</div>';
        
        adContainer.innerHTML = loadingHtml;
        
        // Create request URL
        var params = [
            'zone_id=' + ad_zone_id,
            'container=' + adCallbackId,
            'type=' + ad_zone_type,
            'url=' + encodeURIComponent(window.location.href),
            'domain=' + encodeURIComponent(window.location.hostname),
            'referrer=' + encodeURIComponent(document.referrer || ''),
            'ua=' + encodeURIComponent(navigator.userAgent),
            't=' + new Date().getTime()
        ];
        
        // Only add width/height if they are set
        if (ad_zone_width) params.push('width=' + ad_zone_width);
        if (ad_zone_height) params.push('height=' + ad_zone_height);
        
        var adServerUrl = 'https://up.adstart.click/api/ad-serve.php?' + params.join('&');
        
        console.log('AdStart: Loading ad from', adServerUrl);
        
        // Load the script
        var scriptTag = document.createElement('script');
        scriptTag.src = adServerUrl;
        scriptTag.async = true;
        
        scriptTag.onerror = function() {
            console.error('AdStart: Error loading ad script');
            displayFallbackAd(ad_zone_width, ad_zone_height);
        };
        
        scriptTag.onload = function() {
            console.log('AdStart: Ad script loaded successfully');
            // Give callback 2 seconds to execute, otherwise show fallback
            setTimeout(function() {
                if (adContainer.innerHTML.indexOf('adstart-spin') > -1) {
                    console.warn('AdStart: Callback not executed, showing fallback');
                    displayFallbackAd(ad_zone_width, ad_zone_height);
                }
            }, 2000);
        };
        
        document.head.appendChild(scriptTag);
        
        // Set a longer timeout for slow connections
        setTimeout(function() {
            if (adContainer.innerHTML.indexOf('adstart-spin') > -1) {
                console.warn('AdStart: Ad request timeout');
                displayFallbackAd(ad_zone_width, ad_zone_height);
            }
        }, 15000);
    }
    
    // Start loading immediately
    requestAd();
})();
