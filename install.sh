#!/bin/bash

# Exit immediately if a command exits with a non-zero status
#set -eEo pipefail

# Validate sudo access and refresh timestamp at the start
sudo -v

# Define Omarchy locations
export OMARCHY_PATH="$HOME/.local/share/omarchy"
export OMARCHY_INSTALL="$OMARCHY_PATH/install"
export OMARCHY_INSTALL_LOG_FILE="/var/log/omarchy-install.log"
export PATH="$OMARCHY_PATH/bin:$PATH"

# Set default compilation flags (do not suppress warnings or disable FORTIFY_SOURCE)
export CFLAGS=""
export CXXFLAGS=""
export CPPFLAGS=""
export LDFLAGS=""
export MAKEFLAGS="-s"

# Set locale first for proper TUI display
source "$OMARCHY_INSTALL/preflight/locale.sh"

# Install
source "$OMARCHY_INSTALL/helpers/all.sh"
source "$OMARCHY_INSTALL/preflight/all.sh"
source "$OMARCHY_INSTALL/packaging/all.sh"
source "$OMARCHY_INSTALL/config/all.sh"
source "$OMARCHY_INSTALL/login/all.sh"
source "$OMARCHY_INSTALL/post-install/all.sh"
