#!/bin/bash
# File: bootstrap-omarchy-m1-min.sh
# Purpose: minimal prep for vivek-dg/omarchy-m1 on Arch Linux ARM (Parallels)
# - Update OS
# - Ensure sudo exists
# - Create user 'omuser' (password: 123), grant sudo
# - Drop into 'omuser' login shell
# NOTE: Intentionally *not* installing git/base-devel/others; Omarchy-M1 handles those.

set -euo pipefail

require_root() {
  if [[ ${EUID:-$(id -u)} -ne 0 ]]; then
    echo "This script must be run as root." >&2
    exit 1
  fi
}

pkg_installed() {
  pacman -Q "$1" &>/dev/null
}

enable_wheel_sudo_nopasswd() {
  # Enable wheel group in sudoers with NOPASSWD if not already enabled
  if ! grep -Eq '^\s*%wheel\s+ALL=\(ALL:ALL\)\s+NOPASSWD:\s*ALL' /etc/sudoers; then
    # Keep a backup and append a safe include
    cp -n /etc/sudoers /etc/sudoers.bak
    echo "%wheel ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers
    visudo -c >/dev/null
  fi
}

create_user_if_missing() {
  local user="$1" pass="$2"
  if ! id -u "$user" &>/dev/null; then
    useradd -m -G wheel -s /bin/bash "$user"
    echo "${user}:${pass}" | chpasswd
  else
    # Ensure user is in wheel (for sudo) and has bash
    usermod -aG wheel "$user"
    chsh -s /bin/bash "$user" >/dev/null || true
  fi
}

main() {
  require_root

  # 0) Refresh pacman databases, upgrade system (no extra packages)
  pacman --noconfirm -Syy
  pacman --noconfirm -Su

  # 1) Ensure sudo is present (Omarchy-M1 will install the rest)
  if ! pkg_installed sudo; then
    pacman --noconfirm -S sudo
  fi

  # 2) Create user 'omuser' with password '123' and sudo rights
  create_user_if_missing "omuser" "123"
  enable_wheel_sudo_nopasswd

  echo "✅ System updated, user 'omuser' ready with password '123' and sudo access."
  echo "➡️  Switching to 'omuser' login shell now. Run your Omarchy-M1 installer from there."

  # 3) Drop into the user’s login shell
  exec su - omuser
}

main "$@"
