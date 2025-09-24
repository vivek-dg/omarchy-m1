
# Add architecture-specific kernel packages
ARCH="$(uname -m)"
arch_packages=()
if [[ "$ARCH" == "aarch64" ]]; then
	arch_packages=("linux-asahi" "linux-asahi-headers" "asahi-fwextract" "asahi-desktop-meta")
else
	arch_packages=("linux" "linux-headers")
fi

# Read core and optional packages from omarchy-base.packages
core_packages=("${arch_packages[@]}")
optional_packages=()
in_optional=0
while IFS= read -r line; do
	[[ "$line" =~ ^#.*$ || -z "$line" ]] && continue
	if [[ "$line" == "OPTIONAL:" ]]; then
		in_optional=1
		continue
	fi
	if (( in_optional )); then
		optional_packages+=("$line")
	else
		core_packages+=("$line")
	fi
done < "$OMARCHY_INSTALL/omarchy-base.packages"

# Interactive selection for optional packages using gum
if command -v gum &>/dev/null && (( ${#optional_packages[@]} > 0 )); then
	clear_logo
	echo
	gum style --foreground 6 --bold --padding "0 0 0 $PADDING_LEFT" \
		"📦 Optional Package Selection"
	echo
	gum style --foreground 7 --padding "0 0 0 $PADDING_LEFT" \
		"Select optional packages to install (use space to select, enter to confirm):"
	echo
	selected_optional=$(printf '%s\n' "${optional_packages[@]}" | gum choose --no-limit --height 20)
	mapfile -t selected_optional_pkgs <<< "$selected_optional"
else
	selected_optional_pkgs=("${optional_packages[@]}")
fi

# Combine core and selected optional packages
packages=("${core_packages[@]}" "${selected_optional_pkgs[@]}")

# Pre-Install Compatibility Check
clear_logo
echo
gum style --foreground 6 --bold --padding "0 0 0 $PADDING_LEFT" \
	"🔍 Checking package availability..."
echo

unavailable_pkgs=()
for pkg in "${packages[@]}"; do
	if ! check_package_availability "$pkg"; then
		unavailable_pkgs+=("$pkg")
	fi
done

if (( ${#unavailable_pkgs[@]} > 0 )); then
	gum style --foreground 3 --bold --padding "0 0 0 $PADDING_LEFT" \
		"⚠️  Package Availability Warning"
	echo
	gum style --foreground 7 --padding "0 0 0 $PADDING_LEFT" \
		"The following packages are likely unavailable and will be skipped:"
	echo
	for pkg in "${unavailable_pkgs[@]}"; do
		gum style --foreground 3 --padding "0 0 0 $((PADDING_LEFT + 2))" \
			"⚠ $pkg"
	done
	echo
fi

# Install all base packages, trying AUR helpers as fallbacks
failed_packages=()
for pkg in "${packages[@]}"; do
	if check_package_availability "$pkg"; then
		if ! try_install_package "$pkg"; then
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
	clear_logo
	echo
	gum style --foreground 3 --bold --padding "0 0 0 $PADDING_LEFT" \
		"⚠️  Installation Summary"
	echo
	gum style --foreground 7 --padding "0 0 0 $PADDING_LEFT" \
		"The following packages could not be installed:"
	echo
	for pkg in "${failed_packages[@]}"; do
		gum style --foreground 1 --padding "0 0 0 $((PADDING_LEFT + 2))" \
			"✗ $pkg"
	done
	echo
	gum style --foreground 7 --italic --padding "0 0 0 $PADDING_LEFT" \
		"If you need help or want to request support for missing packages,"
	gum style --foreground 6 --italic --padding "0 0 0 $PADDING_LEFT" \
		"contact @tiredkebab on X (Twitter)."
else
	clear_logo
	echo
	gum style --foreground 2 --bold --padding "0 0 0 $PADDING_LEFT" \
		"✅ All packages installed successfully!"
fi

echo
gum style --foreground 6 --bold --padding "0 0 0 $PADDING_LEFT" \
	"Installation complete. For troubleshooting, see the install log."
gum style --foreground 7 --padding "0 0 0 $PADDING_LEFT" \
	"For support, contact @tiredkebab on X (Twitter)."
