# Ensure we have gum available
if ! command -v gum &>/dev/null; then
  sudo pacman -S --needed --noconfirm gum
fi

# Get terminal size from /dev/tty (works in all scenarios: direct, sourced, or piped)
if [ -e /dev/tty ]; then
  TERM_SIZE=$(stty size 2>/dev/null </dev/tty)

  if [ -n "$TERM_SIZE" ]; then
    export TERM_HEIGHT=$(echo "$TERM_SIZE" | cut -d' ' -f1)
    export TERM_WIDTH=$(echo "$TERM_SIZE" | cut -d' ' -f2)
  else
    # Fallback to reasonable defaults if stty fails
    export TERM_WIDTH=80
    export TERM_HEIGHT=24
  fi
else
  # No terminal available (e.g., non-interactive environment)
  export TERM_WIDTH=80
  export TERM_HEIGHT=24
fi

export LOGO_PATH="$OMARCHY_PATH/logo.txt"
export LOGO_WIDTH=$(awk '{ if (length > max) max = length } END { print max+0 }' "$LOGO_PATH" 2>/dev/null || echo 0)
export LOGO_HEIGHT=$(wc -l <"$LOGO_PATH" 2>/dev/null || echo 0)

export PADDING_LEFT=$((($TERM_WIDTH - $LOGO_WIDTH) / 2))
export PADDING_LEFT_SPACES=$(printf "%*s" $PADDING_LEFT "")

# Tokyo Night theme colors
export COLOR_BG="\e[40m"        # Black background
export COLOR_FG="\e[37m"        # White foreground
export COLOR_ACCENT="\e[96m"    # Bright cyan
export COLOR_SUCCESS="\e[92m"   # Bright green
export COLOR_WARNING="\e[93m"   # Bright yellow
export COLOR_ERROR="\e[91m"     # Bright red
export COLOR_INFO="\e[94m"      # Bright blue
export COLOR_RESET="\e[0m"      # Reset

# Tokyo Night theme for gum confirm
export GUM_CONFIRM_PROMPT_FOREGROUND="6"     # Cyan for prompt
export GUM_CONFIRM_SELECTED_FOREGROUND="0"   # Black text on selected
export GUM_CONFIRM_SELECTED_BACKGROUND="2"   # Green background for selected
export GUM_CONFIRM_UNSELECTED_FOREGROUND="7" # White for unselected
export GUM_CONFIRM_UNSELECTED_BACKGROUND="0" # Black background for unselected
export PADDING="0 0 0 $PADDING_LEFT"         # Gum Style
export GUM_CHOOSE_PADDING="$PADDING"
export GUM_FILTER_PADDING="$PADDING"
export GUM_INPUT_PADDING="$PADDING"
export GUM_SPIN_PADDING="$PADDING"
export GUM_TABLE_PADDING="$PADDING"
export GUM_CONFIRM_PADDING="$PADDING"

# Enhanced gum styling
export GUM_CHOOSE_SELECTED_FOREGROUND="0"
export GUM_CHOOSE_SELECTED_BACKGROUND="6"
export GUM_CHOOSE_UNSELECTED_FOREGROUND="7"
export GUM_INPUT_CURSOR_FOREGROUND="6"
export GUM_INPUT_PROMPT_FOREGROUND="6"

clear_logo() {
  printf "\033[H\033[2J" # Clear screen and move cursor to top-left
  gum style --foreground 6 --padding "1 0 0 $PADDING_LEFT" "$(<"$LOGO_PATH")"
}

show_cursor() {
  printf "\033[?25h" # Show cursor
}

hide_cursor() {
  printf "\033[?25l" # Hide cursor
}
