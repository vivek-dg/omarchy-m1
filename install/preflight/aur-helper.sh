# install/preflight/aur-helper.sh
set -euo pipefail

if ! command -v yay >/dev/null 2>&1; then
  # Prefer repo binary first
  if sudo pacman -Sy --needed --noconfirm yay; then
    :
  else
    # Fallback to AUR binary package if repo one isn't there
    tmpdir="$(mktemp -d)"; trap 'rm -rf "$tmpdir"' EXIT
    git clone https://aur.archlinux.org/yay-bin.git "$tmpdir/yay-bin"
    ( cd "$tmpdir/yay-bin" && makepkg -si --noconfirm )
  fi
fi
