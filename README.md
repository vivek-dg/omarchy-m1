# Omarchy

Turn a fresh Arch installation into a fully-configured, beautiful, and modern web development system based on Hyprland by running a single command. That's the one-line pitch for Omarchy (like it was for Omakub). No need to write bespoke configs for every essential tool just to get started or to be up on all the latest command-line tools. Omarchy is an opinionated take on what Linux can be at its best.

Read more at [omarchy.org](https://omarchy.org).

## License

Omarchy is released under the [MIT License](https://opensource.org/licenses/MIT).

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

