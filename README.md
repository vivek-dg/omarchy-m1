<!-- <img width="2560" height="1600" alt="screenshot-2025-09-28_11-19-38" src="https://github.com/user-attachments/assets/dbce832d-4054-4fbb-8057-e521be4859f8" /> -->

# Omarchy-M1 Parallels installation steps

_Disclaimer: Absolutely zero warranty or promises that this would work. This guide is intended for Apple Silicon MacBooks M1/M2 and has only been tested on the M1 variant. It is advised that you follow the instructions in the manual very carefully. Since this Parallels, there is no risk of bricking the MacBook or getting stuck in a Boot Loop._

## Step 1: Install Arch Linux Parallels (M1) VM

There is existing documentation on installing Arch Linux on https://wiki.archlinux.org/title/Parallels_Desktop. We're interested in the prebuilt VM from 2022. The idea is to use that as a base and then build on it to avoid the painful process of installing Arch by hand.

* **Download the VM** https://pkgbuild.com/~tpowa/parallels/5.19.x/
* **Copy the file** named 'Arch Linux Parallels Desktop.pvm' into your ~/Parallels directory
* **Open the .pvm file in Parallels** Open the Parallels Desktop application, go to File > Open, and select the file from your computer. You can also simply double-click the .pvm file to open it automatically, or drag and drop it onto the Parallels Control Center.

## Step 2: Initial Arch Linux Setup

After installation, boot into Arch Linux and perform the initial setup:

* **Login** provide ```root``` for the user and ```123``` for password based on the default config on the image
* **Upgrade Arch** to the latest verion with ```pacman -Syyu```
* **Reboot** Once the upgrade completes, issue a ```reboot``` command
* **Login once again** as a ```root``` user.
* **Install initial dependencies** ```pacman -S git sudo neovim base-devel``` 


## Step 3: Create User Account

Create a new user account and configure sudo access:

1. **Create user** - `useradd -m -G wheel <username>`
2. **Set password** - `passwd <username>`
3. **Configure sudo** - `EDITOR=nano visudo`
4. **Enable wheel group** - Uncomment `%wheel ALL=(ALL:ALL) ALL`
5. **Save and exit** - Ctrl O, Enter, Ctrl X
6. **Switch to new user** - `su - <username>`

## Step 4: Install AUR Helper and Omarchy Mac

As your new user, set up the AUR helper and install Omarchy Mac:

1. **Install yay AUR helper**:
   ```bash
   git clone https://aur.archlinux.org/yay.git
   cd yay
   makepkg -si
   ```

3. **Clone and setup Omarchy**:
   ```bash
   git clone https://github.com/vivek-dg/omarchy-m1.git ~/.local/share/omarchy
   cd ~/.local/share/omarchy
   bash install.sh
   ```

   And you're done! Now, please wait for the installation to complete and enter password when required.

**Note**: If mirrors break during installation, run `bash fix-mirrors.sh` then run `install.sh` again.


## Omarchy Mac Menu

Omarchy Mac now includes the **Omarchy Mac Menu** by default, which replaces Walker with fuzzel for better aarch64 compatibility and performance. The menu system uses fuzzel as the frontend while maintaining all the original functionality.

Key improvements:
- Better performance on aarch64 systems (Apple Silicon Macs)
- Fuzzel-based frontend for improved stability
- Maintains all original omarchy menu functionality
- Automatic migration from walker-based setup


## Mirrorlist updates

Omarchy may provide a recommended mirrorlist during install, but it will not silently overwrite an existing system mirrorlist. The installer and helper scripts follow a safe default:


If you want to force a full overwrite you can either run the helper with `--force` and/or `--backup` to keep a timestamped backup, or set the environment variable `OMARCHY_FORCE_MIRROR_OVERWRITE=1` during install.

<!--
---

New updates coming soon...

### If you enjoy __Omarchy Mac__, please give it a star and share your exprience on Twitter/X by tagging me [@tiredkebab](https://x.com/tiredkebab) 

Join [Omarchy Mac Discord server](https://discord.gg/KNQRk7dMzy) for updates and support.

- Please consider donation-  [![Buy Me A Coffee](https://img.shields.io/badge/Buy%20Me%20A%20Coffee-FFDD00?style=for-the-badge&logo=buymeacoffee&logoColor=black)](https://buymeacoffee.com/malik2015no)

-->

## Acknowledgements

Thanks [DHH](https://github.com/dhh) for creating Omarchy, and [Naeem Malik](https://github.com/malik-na) for Omarchy-Mac.

## Contributors

- Thank you [IvanKurbakov](https://github.com/tayowrld) for making [Omarchy Mac Menu](https://github.com/tayowrld/omarchy-mac-menu)
