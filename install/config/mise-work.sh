#!/bin/bash

# Add ./bin to path for all items in ~/Work
mkdir -p "$HOME/Work"

cat >"$HOME/Work/.mise.toml" <<'EOF'
[env]
_.path = "{{ cwd }}/bin"
EOF

if command -v mise &>/dev/null; then
	mise trust "$HOME/Work/.mise.toml"
fi
