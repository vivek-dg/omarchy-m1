#!/bin/bash
# Configure keyboard backlight brightness
# Sets keyboard backlight to 50% if available

# Ensure brightnessctl is installed
if ! command -v brightnessctl &> /dev/null; then
  echo "Installing brightnessctl..."
  sudo pacman -S brightnessctl --noconfirm
fi

# Check if keyboard backlight device exists
if brightnessctl --list | grep -q "kbd_backlight"; then
  echo "Setting keyboard backlight to 50%"
  brightnessctl --device=kbd_backlight set 50%
else
  echo "No keyboard backlight device found, skipping configuration"
fi

