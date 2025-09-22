if [[ -n ${OMARCHY_ONLINE_INSTALL:-} ]]; then
  # Install build tools
  sudo pacman -S --needed --noconfirm base-devel

  # Configure pacman
  sudo cp -f ~/.local/share/omarchy/default/pacman/pacman.conf /etc/pacman.conf
  # Use safe mirrorlist updater to avoid overwriting a user's mirrorlist
  if [[ -x "$OMARCHY_BIN/omarchy-refresh-pacman-mirrorlist" ]]; then
    # allow force via env var for automated installs
    if [[ -n "${OMARCHY_FORCE_MIRROR_OVERWRITE:-}" ]]; then
      sudo "$OMARCHY_BIN/omarchy-refresh-pacman-mirrorlist" --force --backup || true
    else
      sudo "$OMARCHY_BIN/omarchy-refresh-pacman-mirrorlist" || true
    fi
  else
    sudo cp -f ~/.local/share/omarchy/default/pacman/mirrorlist /etc/pacman.d/mirrorlist
  fi

  # Refresh all repos
  sudo pacman -Syu --noconfirm
fi
