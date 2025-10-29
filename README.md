<!-- <img width="2560" height="1600" alt="screenshot-2025-09-28_11-19-38" src="https://github.com/user-attachments/assets/dbce832d-4054-4fbb-8057-e521be4859f8" /> -->

# Omarchy-M1 Parallels installation steps

_Disclaimer: Absolutely zero warranty or promises that this would work. This guide is intended for Apple Silicon MacBook M1/M2 and has only been tested on the M1 variant. It is advised that you follow the instructions in the manual very carefully. Since this Parallels, there is no risk of bricking the MacBook or getting stuck in a Boot Loop._

## Step 1: Install Arch Linux Parallels (M1) VM

There is existing documentation on installing Arch Linux on https://wiki.archlinux.org/title/Parallels_Desktop. We're interested in the prebuilt VM from 2022. The idea is to use that as a base and then build on it to avoid the painful process of installing Arch by hand.

- **Download the VM** https://pkgbuild.com/~tpowa/parallels/5.19.x/
- **Copy the file** named 'Arch Linux Parallels Desktop.pvm' into your ~/Parallels directory
- **Open the .pvm file in Parallels** Open the Parallels Desktop application, go to File > Open, and select the file from your computer. You can also simply double-click the .pvm file to open it automatically, or drag and drop it onto the Parallels Control Center.

## Step 2: Initial Arch Linux Setup

After installation, boot into Arch Linux and perform the initial setup:
- **Login** provide `root` for the user and `123` for password based on the default config on the image
- **Update to a better password** `passwd root`

## Step 3: Create User Account and Upgrade Arch

**The following script** automatically creates a user named `omuser` with password `123` and `sudo` permissions. It also refreshes pacman databases, and upgrades system (no extra packages)
```bash
curl -sL https://raw.githubusercontent.com/vivek-dg/omarchy-m1/main/prereq.sh | bash
```

## Step 4: Install Omarchy
```bash
curl -sL https://raw.githubusercontent.com/vivek-dg/omarchy-m1/main/boot.sh | bash
```

   And you're done! Now, please wait for the installation to complete and enter password when required.

**Note**: If mirrors break during installation, run `bash fix-mirrors.sh` then run `install.sh` again.


## Step 5: Install Parallels Tools - Optional

The Parallels tools fail since kernel support even with the latest Parallels tools as of writing this file is only 6.13. Arch ARM64 builds don't even have linux-lts, they don't really make it easy to install 6.13 or any other older kernel version. Even if you install the Parallels Tools, they will most likely just not work as expected for many/all features. I just installed it to get rid of those errors.

- **Load the Parallel Tools ISO in the CD/DVD slot** Follow the instructions [How to install Parallels Tools in Linux virtual machine](https://kb.parallels.com/en/129740) from step 1 to 3 to load the ISO image for the parallels tools for ARM Linux.
- **Install Parallels Tools**
```bash
mkdir -p /mnt/cdrom
sudo mount /dev/cdrom /mnt/cdrom
/mnt/cdrom/install
```

## Omarchy Mac Menu

Omarchy Mac now includes the **Omarchy Mac Menu** by default, which replaces Walker with fuzzel for better aarch64 compatibility and performance. The menu system uses fuzzel as the frontend while maintaining all the original functionality.

**Key improvements:**
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
