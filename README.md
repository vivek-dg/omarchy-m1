# Omarchy-mac installation steps

_Disclaimer: This guide is intended for Apple Silicon MacBooks and has only been tested on the M1 variant released in 2020. It is advised that you follow the instructions in the manual very carefully lest you risk bricking the MacBook or getting stuck in a Boot Loop (I will provide a fix for that as well in the end)._

- Install Arch minimal from Asahi Alarm

**Step 1:**

Visit [https://asahi-alarm.org/](https://asahi-alarm.org/) and run the following script in your Terminal to start Asahi Alarm Installer:

```bash
curl https://asahi-alarm.org/installer-bootstrap.sh | sh
```

Once inside the Asahi Alarm Installer, please follow the on-screen instructions (very carefully). A few recommendations:

- Ideally, you should have at least `50 GB` available on your SSD that you can dedicate to the Linux partition.
- Choose `Asahi Arch Minimal` from the list of OS options the installer provides.

_You won't need to manually create partitions once you're inside Arch. Just run `pacman -Syu`, add a new user, and add it to sudo._

**Step 2:**

Log into the new user and install essential packages before installing Omarchy:

sudo pacman -S base-devel git wget gum
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



**In case you end up in a Boot Loop, here's the solution (don't ask me how I know):**

1. Don't panic!  
2. And follow this guide here – [https://support.apple.com/en-us/108900](https://support.apple.com/en-us/108900)

_New updates coming soon..._

(Find me on X/Twitter here - [https://x.com/tiredkebab](https://x.com/tiredkebab) )

- If you want to support - [coff.ee/malik2015no](coff.ee/malik2015no) 
