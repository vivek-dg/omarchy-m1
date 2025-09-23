#!/bin/bash
# Set Arch Linux ARM mirrors for best performance
# Usage: sudo ./set-arm-mirrors.sh [country_code]

MIRRORLIST_FILE="/etc/pacman.d/mirrorlist"
COUNTRY=${1:-us}
FORCE=0
BACKUP=0
shift || true
while [[ $# -gt 0 ]]; do
  case "$1" in
    --force) FORCE=1; shift ;;
    --backup) BACKUP=1; shift ;;
    *) shift ;;
  esac
done

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
  # Merge behavior: append the ARM mirror Server line only if not already present
  existing=$(grep -E '^\s*Server\s*=' "$MIRRORLIST_FILE" || true)
  if echo "$existing" | grep -F -q "$MIRROR"; then
    echo "[OK] ARM mirror already present in $MIRRORLIST_FILE; not changing file."
  else
    if [[ $BACKUP -eq 1 ]]; then
      sudo cp "$MIRRORLIST_FILE" "$MIRRORLIST_FILE.bak.$(date +%Y%m%d%H%M%S)"
      echo "[INFO] Backed up existing mirrorlist to $MIRRORLIST_FILE.bak.*"
    fi
    echo "$MIRROR" | sudo tee -a "$MIRRORLIST_FILE" > /dev/null
    echo "[OK] Appended ARM mirror to $MIRRORLIST_FILE: $MIRROR"
    echo "Updating package database..."
    sudo pacman -Syy
  fi
else
  # Force overwrite or mirrorlist missing -> write the single ARM server entry
  if [[ -f "$MIRRORLIST_FILE" && $BACKUP -eq 1 ]]; then
    sudo cp "$MIRRORLIST_FILE" "$MIRRORLIST_FILE.bak.$(date +%Y%m%d%H%M%S)"
    echo "[INFO] Backed up existing mirrorlist to $MIRRORLIST_FILE.bak.*"
  fi

  echo "$MIRROR" | sudo tee "$MIRRORLIST_FILE"
  echo "[OK] Set ARM mirror: $MIRROR"

  echo "Updating package database..."
  sudo pacman -Syy
fi
