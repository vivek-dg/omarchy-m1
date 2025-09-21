# Omarchy Pre-Install Compatibility Check
echo "\e[34m[Omarchy] Checking package availability...\e[0m"
mapfile -t packages < <(grep -v '^#' "$OMARCHY_INSTALL/omarchy-base.packages" | grep -v '^$')
unavailable_pkgs=()
for pkg in "${packages[@]}"; do
	if ! pacman -Si "$pkg" &>/dev/null; then
		unavailable_pkgs+=("$pkg")
	fi
done
if (( ${#unavailable_pkgs[@]} > 0 )); then
	echo "\e[33m[Warning] The following packages are likely unavailable for your architecture and will be skipped:\e[0m"
	for pkg in "${unavailable_pkgs[@]}"; do
		echo "  - $pkg"
	done
	echo
fi

# Install all base packages, skipping unavailable ones and listing failures at the end
failed_packages=()
for pkg in "${packages[@]}"; do
	if pacman -Si "$pkg" &>/dev/null; then
		if sudo pacman -S --noconfirm --needed "$pkg"; then
			echo "[OK] $pkg"
		else
			echo "[FAILED] $pkg"
			failed_packages+=("$pkg")
		fi
	else
		echo "[SKIPPED] $pkg (not available)"
		failed_packages+=("$pkg (not available)")
	fi
done

# Post-install summary and support
echo
if (( ${#failed_packages[@]} > 0 )); then
	echo "==============================="
	echo "The following packages could not be installed:"
	for pkg in "${failed_packages[@]}"; do
		echo "  - $pkg"
	done
	echo "==============================="
	echo "If you need help or want to request support for missing packages, contact @tiredkebab on X (Twitter)."
else
	echo "\e[32mAll packages installed successfully!\e[0m"
fi

echo
echo "[Omarchy] Installation complete. For troubleshooting, see the install log. For support, contact @tiredkebab on X (Twitter)."
