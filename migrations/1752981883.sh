echo "Replace wofi with walker as the default launcher"

if omarchy-cmd-missing walker; then
  # Use architecture-aware walker installation
  if command -v omarchy-pkg-walker-install &>/dev/null; then
    omarchy-pkg-walker-install
  else
    # Fallback to original method if new script not available
    omarchy-pkg-add walker-bin libqalculate
  fi

  omarchy-pkg-drop wofi
  rm -rf ~/.config/wofi

  mkdir -p ~/.config/walker
  cp -r ~/.local/share/omarchy/config/walker/* ~/.config/walker/
fi
