# Dotfiles

Managed with [Dotbot](https://github.com/anishathalye/dotbot). Licensed under
the MIT License (see LICENSE.md).

## Install

    ./install <profile>

The profile defaults to the machine's hostname. Available profiles live in
`hosts/` (currently `gallifrey` and `generic`).

## Structure

Shared configuration lives at the top level and is installed on every
machine via `install.conf.yaml`. Machine-specific files live in
`hosts/<profile>/` and are installed on top of the shared set by
`hosts/<profile>/install.yaml`.

Host overlays used by shared configs:

- `hosts/<profile>/i3-host.conf` — included by the shared `i3/config`
  through `~/.config/i3/host.conf`
- `hosts/<profile>/sway-host.conf` — included by the shared `sway/config`
  through `~/.config/sway/host.conf`
- `hosts/<profile>/i3status.conf` — linked as `~/.config/i3status/config`
- `hosts/gallifrey/kanshi.conf` — linked as `~/.config/kanshi/config`
  (gallifrey only)
- `hosts/gallifrey/fish-host.fish` — sourced by the shared `fish/config.fish`
  through `~/.config/fish/host.fish`

Host-specific scripts live in `hosts/<profile>/bin/` and are linked
individually into `~/bin` (which is itself a symlink to the shared `bin/`).

Note: `bin/` directories are gitignored (`.gitignore`); new scripts are
not tracked by default, add them explicitly with `git add -f` if they
should be committed.

## Files not deployed by dotbot

`etc/` stores system configuration that is kept in this repository for
reference but is NOT installed by dotbot. Deploy or adapt it manually:

- `etc/iptables/` — sample firewall rules (used with `bin/nat_activate.sh`)
- `etc/udev/usb-wifi/` — udev rule, netctl hook and script to switch
  network interfaces when a USB wifi adapter is plugged in. The rule
  (`50-usb-wifi.rules`) still contains `<IF-NAME>` / `<MAC-ADDR>`
  placeholders and a `/opt/udev-usb-wifi.sh` path that must be filled in
  before use, and the script hardcodes `wlo1` as the internal interface.

## Adding a new machine

Create a `hosts/<name>/` directory with an `install.yaml` and any
host-specific files, then run `./install <name>` on that machine.
