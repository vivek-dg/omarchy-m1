#!/bin/bash
# Set Arch Linux ARM mirrors for best performance
# Usage: sudo ./set-arm-mirrors.sh [country_code]

MIRRORLIST_FILE="/etc/pacman.d/mirrorlist"
COUNTRY=${1:-us}

# List of some fast Arch Linux ARM mirrors by country
case "$COUNTRY" in
  us)
    MIRROR="Server = http://us.mirror.archlinuxarm.org/$arch/$repo"
    ;;
  de)
    MIRROR="Server = http://de.mirror.archlinuxarm.org/$arch/$repo"
    ;;
  uk)
    MIRROR="Server = http://uk.mirror.archlinuxarm.org/$arch/$repo"
    ;;
  fr)
    MIRROR="Server = http://fr.mirror.archlinuxarm.org/$arch/$repo"
    ;;
  au)
    MIRROR="Server = http://au.mirror.archlinuxarm.org/$arch/$repo"
    ;;
  *)
    MIRROR="Server = http://mirror.archlinuxarm.org/$arch/$repo"
    ;;
esac

# Backup old mirrorlist
sudo cp "$MIRRORLIST_FILE" "$MIRRORLIST_FILE.bak.$(date +%Y%m%d%H%M%S)"

echo "$MIRROR" | sudo tee "$MIRRORLIST_FILE"
echo "[OK] Set ARM mirror: $MIRROR"

echo "Updating package database..."
sudo pacman -Syy
