#!/bin/bash
# Set Arch Linux ARM mirrors for best performance
# Usage: sudo ./set-arm-mirrors.sh [country_code]

MIRRORLIST_FILE="/etc/pacman.d/mirrorlist"
COUNTRY=${1:-us}
FORCE=0
BACKUP=0
if [[ "$2" == "--force" ]]; then
  FORCE=1
fi
if [[ "$2" == "--backup" ]]; then
  BACKUP=1
fi

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

if [[ -f "$MIRRORLIST_FILE" && $FORCE -eq 0 && -z "${OMARCHY_FORCE_MIRROR_OVERWRITE:-}" ]]; then
  echo "[SKIP] Existing mirrorlist found at $MIRRORLIST_FILE; not overwriting. Use --force or set OMARCHY_FORCE_MIRROR_OVERWRITE=1 to override."
else
  if [[ -f "$MIRRORLIST_FILE" && $BACKUP -eq 1 ]]; then
    sudo cp "$MIRRORLIST_FILE" "$MIRRORLIST_FILE.bak.$(date +%Y%m%d%H%M%S)"
    echo "[INFO] Backed up existing mirrorlist to $MIRRORLIST_FILE.bak.*"
  fi

  echo "$MIRROR" | sudo tee "$MIRRORLIST_FILE"
  echo "[OK] Set ARM mirror: $MIRROR"

  echo "Updating package database..."
  sudo pacman -Syy
fi
