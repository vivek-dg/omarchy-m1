# Omarchy-mac installation steps

- Install Arch minimal from Asahi Alarm
- Log into root - username and password root
- `Nmtui` for wifi
- `pacman -S sudo git —needed base-devel`
- `useradd -m -G wheel <username>`
- `passwd <username>`
- `Set password`
- `EDITOR=nano visudo`
- Uncomment `%wheel ALL(ALL:ALL) ALL`
- Ctrl O, Enter, Ctrl X
- `su - username`
- `git clone https://aur.archlinux.org/yay.git` and `cd yay` `makepkg yay`
- makedir ~/.local/share dirs
- `cd .local/share`
- Clone omarchy-mac - `git clone https://github.com/malik-na/omarchy-mac.git`
- `mv omarchy-mac omarchy`
- `cd omarchy`
- `bash install.sh`
If mirrors break, run `bash fix-mirrors.sh`
Run install.sh again

## Mirrorlist updates

Omarchy may provide a recommended `mirrorlist` during install, but it will not
silently overwrite an existing system mirrorlist. The installer and helper
scripts follow a safe default:

- If `/etc/pacman.d/mirrorlist` does not exist, Omarchy will install the
	bundled default.
- If it exists, Omarchy will merge `Server = ...` entries from the bundled
	mirrorlist into the existing file so user-configured or distribution-specific
	mirrors (e.g., Arch Linux ARM) are preserved.

If you want to force a full overwrite you can either run the helper with
`--force` and/or `--backup` to keep a timestamped backup, or set the
environment variable `OMARCHY_FORCE_MIRROR_OVERWRITE=1` during install.

