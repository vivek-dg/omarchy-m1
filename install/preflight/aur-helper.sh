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

# --- now ensure yay exists ---
if ! command -v yay >/dev/null 2>&1; then
  echo "Installing yay..."
  # Prefer repo binary first 
  if sudo pacman -S --needed --noconfirm yay; then
    echo "yay installed from repo."
  else
    # Fallback to AUR binary package if repo one isn't there
    tmpdir="$(mktemp -d)"; trap 'rm -rf "$tmpdir"' EXIT
    git clone https://aur.archlinux.org/yay-bin.git "$tmpdir/yay-bin"
    ( cd "$tmpdir/yay-bin" && makepkg -si --noconfirm )
  fi
fi
