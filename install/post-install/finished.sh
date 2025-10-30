#!/bin/bash
stop_install_log

echo_in_style() {
	echo "$1" | tte --canvas-width 0 --anchor-text c --frame-rate 640 print
}

clear
echo
tte -i ~/.local/share/omarchy/logo.txt --canvas-width 0 --anchor-text c --frame-rate 920 laseretch
echo

# Display installation time if available
if [[ -f $OMARCHY_INSTALL_LOG_FILE ]] && grep -q "Total:" "$OMARCHY_INSTALL_LOG_FILE" 2>/dev/null; then
	echo
	TOTAL_TIME=$(tail -n 20 "$OMARCHY_INSTALL_LOG_FILE" | grep "^Total:" | sed 's/^Total:[[:space:]]*//')
	if [ -n "$TOTAL_TIME" ]; then
		echo_in_style "Installed in $TOTAL_TIME"
	fi
else
	echo_in_style "Finished installing"
fi

# Clean up temporary installer sudoers rule
if sudo test -f /etc/sudoers.d/99-omarchy-installer; then
	sudo rm -f /etc/sudoers.d/99-omarchy-installer &>/dev/null
fi

# Exit gracefully if user chooses not to reboot
if gum confirm --padding "0 0 0 $((PADDING_LEFT + 32))" --show-help=false --default --affirmative "Reboot Now" --negative "" ""; then
	# Clear screen to hide any shutdown messages
	clear

	# # Use systemctl if available, otherwise fallback to reboot command
	# if command -v systemctl &>/dev/null; then
	#   systemctl reboot --no-wall 2>/dev/null
	# else
	#   reboot 2>/dev/null
	# fi

	# Attempt reboot from within systemd if available; fallback to user-initiated reboot
	if pidof systemd >/dev/null 2>&1; then
		echo "[Omarchy] Rebooting system..."
		systemctl reboot || sudo systemctl reboot
	else
		echo "[Omarchy] No systemd session detected; rebooting via parent shell..."
		sudo loginctl reboot || sudo reboot || {
			echo "⚠️  Reboot failed — please run 'sudo reboot' manually."
		}
	fi

fi
