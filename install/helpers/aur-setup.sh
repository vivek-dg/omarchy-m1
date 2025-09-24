#!/bin/bash

# Function to install yay AUR helper
install_yay() {
    echo "\e[34m[Omarchy] Setting up yay AUR helper...\e[0m"
    
    if command -v yay &>/dev/null; then
        echo "\e[32m[OK] yay is already installed\e[0m"
        return 0
    fi
    
    # Create temp directory
    local temp_dir="/tmp/yay-install"
    rm -rf "$temp_dir"
    mkdir -p "$temp_dir"
    
    # Clone and build yay
    if git clone https://aur.archlinux.org/yay.git "$temp_dir" 2>/dev/null; then
        cd "$temp_dir"
        if makepkg -si --noconfirm; then
            echo "\e[32m[OK] yay installed successfully\e[0m"
            cd - >/dev/null
            rm -rf "$temp_dir"
            return 0
        else
            echo "\e[31m[FAILED] yay installation failed\e[0m"
            cd - >/dev/null
            rm -rf "$temp_dir"
            return 1
        fi
    else
        echo "\e[31m[FAILED] Failed to clone yay repository\e[0m"
        rm -rf "$temp_dir"
        return 1
    fi
}

# Function to install paru AUR helper
install_paru() {
    echo "\e[34m[Omarchy] Setting up paru AUR helper...\e[0m"
    
    if command -v paru &>/dev/null; then
        echo "\e[32m[OK] paru is already installed\e[0m"
        return 0
    fi
    
    # Create temp directory
    local temp_dir="/tmp/paru-install"
    rm -rf "$temp_dir"
    mkdir -p "$temp_dir"
    
    # Clone and build paru
    if git clone https://aur.archlinux.org/paru.git "$temp_dir" 2>/dev/null; then
        cd "$temp_dir"
        if makepkg -si --noconfirm; then
            echo "\e[32m[OK] paru installed successfully\e[0m"
            cd - >/dev/null
            rm -rf "$temp_dir"
            return 0
        else
            echo "\e[31m[FAILED] paru installation failed\e[0m"
            cd - >/dev/null
            rm -rf "$temp_dir"
            return 1
        fi
    else
        echo "\e[31m[FAILED] Failed to clone paru repository\e[0m"
        rm -rf "$temp_dir"
        return 1
    fi
}

# Function to check if AUR is accessible
check_aur_access() {
    if curl -sf --connect-timeout 10 --retry 2 --retry-delay 2 -A "omarchy-install" \
       "https://aur.archlinux.org/rpc/?v=5&type=info&arg=base" >/dev/null 2>&1; then
        return 0
    else
        echo "\e[33m[Warning] AUR is not accessible, skipping AUR helper setup\e[0m"
        return 1
    fi
}

# Main function to set up AUR helpers
setup_aur_helpers() {
    # Check if we're online and AUR is accessible
    if ! check_aur_access; then
        return 1
    fi
    
    # Try to install yay first
    if install_yay; then
        echo "\e[32m[Omarchy] yay AUR helper is ready\e[0m"
    else
        echo "\e[33m[Warning] Failed to install yay\e[0m"
    fi
    
    # Try to install paru as backup
    if install_paru; then
        echo "\e[32m[Omarchy] paru AUR helper is ready\e[0m"
    else
        echo "\e[33m[Warning] Failed to install paru\e[0m"
    fi
    
    # Check if at least one AUR helper is available
    if command -v yay &>/dev/null || command -v paru &>/dev/null; then
        echo "\e[32m[Omarchy] AUR helpers are set up successfully\e[0m"
        return 0
    else
        echo "\e[33m[Warning] No AUR helpers could be installed\e[0m"
        return 1
    fi
}