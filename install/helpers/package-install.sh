#!/bin/bash

# Function to try installing a package with pacman, yay, then paru as fallbacks
try_install_package() {
    local pkg="$1"
    
    # First try pacman
    if pacman -Si "$pkg" &>/dev/null; then
        if sudo pacman -S --noconfirm --needed "$pkg"; then
            echo "[OK] $pkg (pacman)"
            return 0
        else
            echo "[FAILED] $pkg (pacman failed)"
        fi
    fi
    
    # If pacman failed or package not found, try yay
    if command -v yay &>/dev/null; then
        echo "[TRYING] $pkg (yay)"
        if yay -Si "$pkg" &>/dev/null; then
            if yay -S --noconfirm --needed "$pkg"; then
                echo "[OK] $pkg (yay)"
                return 0
            else
                echo "[FAILED] $pkg (yay failed)"
            fi
        else
            echo "[NOT FOUND] $pkg (yay)"
        fi
    fi
    
    # If yay failed or not available, try paru
    if command -v paru &>/dev/null; then
        echo "[TRYING] $pkg (paru)"
        if paru -Si "$pkg" &>/dev/null; then
            if paru -S --noconfirm --needed "$pkg"; then
                echo "[OK] $pkg (paru)"
                return 0
            else
                echo "[FAILED] $pkg (paru failed)"
            fi
        else
            echo "[NOT FOUND] $pkg (paru)"
        fi
    fi
    
    # All methods failed
    echo "[FAILED] $pkg (all methods failed)"
    return 1
}

# Function to check if a package is available in any repository
check_package_availability() {
    local pkg="$1"
    
    # Check pacman first
    if pacman -Si "$pkg" &>/dev/null; then
        return 0
    fi
    
    # Check yay
    if command -v yay &>/dev/null && yay -Si "$pkg" &>/dev/null; then
        return 0
    fi
    
    # Check paru
    if command -v paru &>/dev/null && paru -Si "$pkg" &>/dev/null; then
        return 0
    fi
    
    return 1
}