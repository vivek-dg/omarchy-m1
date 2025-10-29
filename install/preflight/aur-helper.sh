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

# TLS sanity (harmless if repeated)
sudo pacman -S --needed --noconfirm ca-certificates ca-certificates-mozilla openssl go base-devel
sudo update-ca-trust || true
sudo timedatectl set-ntp true || true

# tune makepkg to go faster
sudo sed -i 's/^#*MAKEFLAGS=.*/MAKEFLAGS="-j$(nproc)"/' /etc/makepkg.conf
sudo sed -i 's/^#*BUILDENV=.*/BUILDENV=(!distcc color ccache)/' /etc/makepkg.conf
echo 'PKGDEST=/var/cache/pacman/pkgbuild' | sudo tee -a /etc/makepkg.conf
echo 'SRCDEST=/var/cache/pacman/src' | sudo tee -a /etc/makepkg.conf

# --- Optional but recommended: Enable ccache ---
if ! pacman -Qi ccache >/dev/null 2>&1; then
	echo "[Omarchy] Installing ccache for faster AUR builds..."
	if [ "$(id -u)" -eq 0 ]; then
		pacman -S --needed --noconfirm ccache
	else
		sudo pacman -S --needed --noconfirm ccache
	fi
fi

# Configure makepkg to use ccache safely
if ! grep -q 'BUILDENV=.*ccache' /etc/makepkg.conf; then
	sudo sed -i 's/^#*BUILDENV=.*/BUILDENV=(!distcc color ccache)/' /etc/makepkg.conf
fi

# Set up cache directories
if [ "$(id -u)" -eq 0 ]; then
	mkdir -p /var/cache/ccache /var/cache/pacman/{pkgbuild,src}
	chown -R "$(logname 2>/dev/null || echo root)":"$(logname 2>/dev/null || echo root)" /var/cache/ccache /var/cache/pacman
else
	sudo mkdir -p /var/cache/ccache /var/cache/pacman/{pkgbuild,src}
	sudo chown -R "$USER":"$USER" /var/cache/ccache /var/cache/pacman
fi

# Point ccache to a persistent location
echo 'export CCACHE_DIR=/var/cache/ccache' | sudo tee -a /etc/makepkg.conf >/dev/null

# --- now ensure yay exists ---
if ! command -v yay >/dev/null 2>&1; then
	echo "Installing yay..."
	# Prefer repo binary first
	if sudo pacman -S --needed --noconfirm yay; then
		echo "yay installed from repo."
	else
		# GitHub build (no AUR; reliable on ARM)
		export GOPATH="${HOME}/go"
		export PATH="${HOME}/go/bin:${PATH}"
		go install github.com/Jguer/yay/v12@latest
		sudo install -m 0755 "${HOME}/go/bin/yay" /usr/local/bin/yay
	fi
fi

command -v yay >/dev/null || {
	echo "❌ yay not installed (AUR disabled & GitHub build failed)"
	exit 1
}
echo "✅ yay ready (no AUR clone used)"
