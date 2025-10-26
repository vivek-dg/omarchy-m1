#!/usr/bin/env bash
# File: install/preflight/aur-helper.sh
# Description: Ensures yay is installed; aborts if pacman unsupported.
# Compatible: Arch Linux ARM (aarch64)
# -------------------------------------

set -euo pipefail

# --- check distro support for pacman ---
if ! command -v pacman >/dev/null 2>&1; then
  echo "❌ This distribution does not support pacman. Aborting install." >&2
  exit 1
fi

# --- optional sanity check for /etc/pacman.conf ---
if [[ ! -f /etc/pacman.conf ]]; then
  echo "❌ pacman.conf missing. This system is likely not a valid Arch/Arch ARM base. Aborting." >&2
  exit 1
fi

# --- proceed only if pacman works properly ---
if ! sudo pacman -Sy --noconfirm >/dev/null 2>&1; then
  echo "❌ pacman database refresh failed. Aborting." >&2
  exit 1
fi

echo "✅ pacman detected and functional."

# Prime sudo (prevents timeouts during long runs)
sudo -v || { echo "❌ sudo required"; exit 1; }
( while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done ) 2>/dev/null &

# TLS sanity (harmless if repeated)
sudo pacman -S --needed --noconfirm ca-certificates ca-certificates-mozilla openssl git go base-devel
sudo update-ca-trust || true
sudo timedatectl set-ntp true || true

# --- now ensure yay exists ---
if ! command -v yay >/dev/null 2>&1; then
  echo "Installing yay..."
  # Prefer repo binary first 
  if sudo pacman -S --needed --noconfirm yay; then
    echo "yay installed from repo."
  else
    # GitHub build (no AUR; reliable on ARM)
    export GOPATH="${HOME}/go"; export PATH="${HOME}/go/bin:${PATH}"
    go install github.com/Jguer/yay/v12@latest
    sudo install -m 0755 "${HOME}/go/bin/yay" /usr/local/bin/yay
  fi
fi


command -v yay >/dev/null || { echo "❌ yay not installed (AUR disabled & GitHub build failed)"; exit 1; }
echo "✅ yay ready (no AUR clone used)"
