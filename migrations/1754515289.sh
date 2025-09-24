echo "Update and restart Walker to resolve stuck Omarchy menu"

# Use architecture-aware walker installation/update
if command -v omarchy-pkg-walker-install &>/dev/null; then
  omarchy-pkg-walker-install
else
  # Fallback to original method
  sudo pacman -Syu --noconfirm walker-bin
fi
omarchy-restart-walker
