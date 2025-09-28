source "$OMARCHY_INSTALL/helpers/packages.sh"

# Read all required packages from omarchy-base.packages
mapfile -t packages < <(grep -v '^#' "$OMARCHY_INSTALL/omarchy-base.packages" | grep -v '^$')

# Pre-Install Compatibility Check
echo "\e[34m[Omarchy] Checking package availability...\e[0m"
unavailable_pkgs=()
for pkg in "${packages[@]}"; do
	if ! omarchy_package_known_to_any_manager "$pkg"; then
		unavailable_pkgs+=("$pkg")
	fi
done
if (( ${#unavailable_pkgs[@]} > 0 )); then
	echo "\e[33m[Warning] The following packages were not found in pacman, yay, or paru metadata and may fail to install:\e[0m"
	for pkg in "${unavailable_pkgs[@]}"; do
		echo "  - $pkg"
	done
	echo
fi

# Install all base packages, skipping unavailable ones and listing failures at the end
failed_packages=()
for pkg in "${packages[@]}"; do
	if omarchy_package_installed "$pkg"; then
		echo "[SKIPPED] $pkg (already installed)"
		continue
	fi

	if omarchy_install_package_with_fallback "$pkg"; then
		echo "[OK] $pkg"
	else
		echo "[FAILED] $pkg"
		if omarchy_package_known_to_any_manager "$pkg"; then
			failed_packages+=("$pkg")
		else
			failed_packages+=("$pkg (not found in pacman/yay/paru)")
		fi
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
