# Install all base packages, skipping unavailable ones and listing failures at the end
mapfile -t packages < <(grep -v '^#' "$OMARCHY_INSTALL/omarchy-base.packages" | grep -v '^$')
failed_packages=()
for pkg in "${packages[@]}"; do
	if sudo pacman -S --noconfirm --needed "$pkg"; then
		echo "[OK] $pkg"
	else
		echo "[FAILED] $pkg"
		failed_packages+=("$pkg")
	fi
done

if (( ${#failed_packages[@]} > 0 )); then
	echo
	echo "==============================="
	echo "The following packages could not be installed:"
	for pkg in "${failed_packages[@]}"; do
		echo "  - $pkg"
	done
	echo "==============================="
fi
