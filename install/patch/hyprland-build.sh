#!/usr/bin/env bash
set -Eeuo pipefail

TS="$(date -u +%Y%m%d-%H%M%S)"
LOG_ROOT="/mnt/psf/omarchy-m1/logs-${TS}"
BUILD_DIR="$(mktemp -d -t hyprland-build-XXXXXX)"
PKG_URL="https://gist.githubusercontent.com/BluSyn/f8585a5da073532020e4ebcd1e3ecaef/raw/ed2e5ad2e10beeb34f87e85565d9e5735001333b/PKGBUILD"

mkdir -p "${LOG_ROOT}"
PAC_LOG="${LOG_ROOT}/pacman.log"
BLD_LOG="${LOG_ROOT}/makepkg.log"
ENV_LOG="${LOG_ROOT}/env.txt"
SYS_PAC_LOG_COPY="${LOG_ROOT}/system-pacman.log"

umask 022

cleanup() {
	if [[ -f /var/log/pacman.log ]]; then
		sudo cp -a /var/log/pacman.log "${SYS_PAC_LOG_COPY}" || true
	fi
	echo "[i] Logs saved under ${LOG_ROOT}"
	echo "[i] Build dir was ${BUILD_DIR}"
}
trap cleanup EXIT

log() {
	printf "%s %s\n" "$(date -u +%F\ %T)" "$*" | tee -a "${ENV_LOG}" >/dev/null
}

if [[ "${EUID}" -eq 0 ]]; then
	echo "Please run as a regular user (not root). sudo will be used when needed." | tee -a "${ENV_LOG}" >&2
	exit 1
fi

if ! command -v sudo >/dev/null 2>&1; then
	echo "This script requires 'sudo'." | tee -a "${ENV_LOG}" >&2
	exit 1
fi

{
	echo "==== ENV SNAPSHOT (${TS} UTC) ===="
	echo "User: ${USER}"
	echo "Shell: ${SHELL}"
	echo "PWD: ${PWD}"
	echo "Arch: $(uname -m)"
	echo "Kernel: $(uname -r)"
	echo "OS: $(grep ^PRETTY_NAME= /etc/os-release || true)"
	echo
	echo "== Tool versions =="
	if command -v gcc >/dev/null 2>&1; then gcc --version | head -n1; fi
	if command -v clang >/dev/null 2>&1; then clang --version | head -n1; fi
	if command -v ld >/dev/null 2>&1; then ld --version | head -n1; fi
	echo
	echo "== Mirrors (pacman.conf snippet) =="
	sed -n '1,120p' /etc/pacman.conf || true
	echo
	echo "== Installed packages (pre) =="
	pacman -Q | sort || true
} >>"${ENV_LOG}" 2>&1

log "[*] Syncing package databases and updating system (this may take a while)"
sudo pacman -Syu --noconfirm 2>&1 | tee -a "${PAC_LOG}"

log "[*] Ensuring base-devel and git are installed for makepkg"
sudo pacman -S --needed --noconfirm base-devel git 2>&1 | tee -a "${PAC_LOG}"

log "[*] Installing llvm20 (per confirmed fix)"
sudo pacman -S --needed --noconfirm llvm20 2>&1 | tee -a "${PAC_LOG}"

log "[*] Installing and enabling seatd; adding ${USER} to 'seat' group"
sudo pacman -S --needed --noconfirm seatd 2>&1 | tee -a "${PAC_LOG}"
sudo systemctl enable --now seatd.service 2>&1 | tee -a "${PAC_LOG}"
if ! id -nG "${USER}" | grep -qw seat; then
	sudo usermod -aG seat "${USER}" 2>&1 | tee -a "${PAC_LOG}"
	ADDED_SEAT_GROUP="yes"
else
	ADDED_SEAT_GROUP="no"
fi

log "[*] Fetching pinned PKGBUILD (BluSyn, Hyprland 0.51 patched for GCC 14.2)"
mkdir -p "${BUILD_DIR}"
curl -fsSL "${PKG_URL}" -o "${BUILD_DIR}/PKGBUILD"

log "[*] Verifying PKGBUILD presence"
test -s "${BUILD_DIR}/PKGBUILD"

log "[*] Running makepkg (will install deps via pacman, no AUR helper required)"
pushd "${BUILD_DIR}" >/dev/null
# makepkg refuses to run as root; we are non-root, OK.
makepkg -si --noconfirm --needed 2>&1 | tee -a "${BLD_LOG}"
popd >/dev/null

{
	echo
	echo "==== POST-INSTALL STATE ===="
	if command -v Hyprland >/dev/null 2>&1; then
		echo "Hyprland executable: $(command -v Hyprland)"
	else
		echo "Hyprland not found in PATH"
	fi
	echo
	echo "== Installed packages (post) =="
	pacman -Q | sort || true
} >>"${ENV_LOG}" 2>&1

echo "[clean-tmp-safe] Cleaning /tmp except GUI sockets..."
sudo find /tmp -mindepth 1 -maxdepth 1 \
	! -path /tmp/.X11-unix \
	! -path /tmp/.XIM-unix \
	! -path /tmp/.ICE-unix \
	-exec rm -rf {} + 2>/dev/null || true
df -h /tmp

echo
echo "====================================================================="
echo "Hyprland build/install finished."
echo "Logs: ${LOG_ROOT}"
if [[ "${ADDED_SEAT_GROUP:-no}" == "yes" ]]; then
	echo "NOTE: You were added to the 'seat' group. Log out or reboot to apply."
fi
echo "If Aquamarine complains about GPU on first run, ensure you're on a TTY and try after a reboot."
echo "====================================================================="
