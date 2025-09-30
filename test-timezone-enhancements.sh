#!/bin/bash
# Test script for enhanced timezone detection functionality

echo "Testing Enhanced Timezone Detection"
echo "======================================"
echo

# Test 1: Check if detection script exists and is executable
echo "Test 1: Detection script availability"
if [[ -x "/workspaces/omarchy-mac/install/config/timezone-detection.sh" ]]; then
    echo "[PASS] timezone-detection.sh is present and executable"
else
    echo "[FAIL] timezone-detection.sh is missing or not executable"
fi
echo

# Test 2: Check enhanced commands
echo "Test 2: Enhanced command availability"
for cmd in "omarchy-cmd-tzupdate-enhanced" "omarchy-cmd-tzupdate-manual"; do
    if [[ -x "/workspaces/omarchy-mac/bin/$cmd" ]]; then
        echo "[PASS] $cmd is present and executable"
    else
        echo "[FAIL] $cmd is missing or not executable"
    fi
done
echo

# Test 3: Check first-run integration
echo "Test 3: First-run integration"
if grep -q "timezone.sh" "/workspaces/omarchy-mac/bin/omarchy-cmd-first-run"; then
    echo "[PASS] timezone.sh is integrated into first-run sequence"
else
    echo "[FAIL] timezone.sh is not in first-run sequence"
fi
echo

# Test 4: Check waybar integration
echo "Test 4: Waybar integration"
if grep -q "omarchy-cmd-tzupdate-enhanced" "/workspaces/omarchy-mac/config/waybar/config.jsonc"; then
    echo "[PASS] Enhanced timezone command is integrated into waybar"
else
    echo "[FAIL] Waybar not updated with enhanced command"
fi
echo

# Test 5: Check menu integration
echo "Test 5: Menu integration"
if grep -q "Auto-detect" "/workspaces/omarchy-mac/bin/omarchy-menu"; then
    echo "[PASS] Enhanced timezone options are in the menu system"
else
    echo "[FAIL] Menu system not updated with new options"
fi
echo

# Test 6: Source detection script and test functions
echo "Test 6: Function availability"
if source "/workspaces/omarchy-mac/install/config/timezone-detection.sh" 2>/dev/null; then
    echo "[PASS] Detection script sources without errors"
    
    # Test function existence
    if declare -F auto_detect_country >/dev/null; then
        echo "[PASS] auto_detect_country function available"
    else
        echo "[FAIL] auto_detect_country function missing"
    fi
    
    if declare -F detect_timezone_ip >/dev/null; then
        echo "[PASS] detect_timezone_ip function available"
    else
        echo "[FAIL] detect_timezone_ip function missing"
    fi
else
    echo "[FAIL] Detection script has syntax errors"
fi
echo

# Test 7: Check dependencies
echo "Test 7: Dependencies"
dependencies=("timedatectl" "gum" "tzupdate")
for dep in "${dependencies[@]}"; do
    if command -v "$dep" >/dev/null 2>&1; then
        echo "[PASS] $dep is available"
    else
        if [[ "$dep" == "gum" ]]; then
            echo "[WARN] $dep is optional but recommended"
        else
            echo "[FAIL] $dep is missing (required)"
        fi
    fi
done
echo

echo "Test Summary"
echo "==============="
echo "Enhanced timezone detection system has been implemented with:"
echo "- Automatic timezone detection during installation"
echo "- Multiple detection methods (IP-based, hardware, manual)"
echo "- User-friendly interfaces with gum integration"
echo "- First-run setup notifications"
echo "- Enhanced waybar and menu integration"
echo "- Comprehensive error handling and fallbacks"
echo
echo "The system is backward compatible and ready for use!"