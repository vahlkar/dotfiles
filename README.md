# Dotfiles

Managed with [Dotbot](https://github.com/anishathalye/dotbot).

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
- `hosts/<profile>/i3status.conf` — linked as `~/.config/i3status/config`
- `hosts/gallifrey/fish-host.fish` — sourced by the shared `fish/config.fish`
  through `~/.config/fish/host.fish`

Host-specific scripts live in `hosts/<profile>/bin/` and are linked
individually into `~/bin` (which is itself a symlink to the shared `bin/`).

To configure a new machine, add a `hosts/<name>/` directory with an
`install.yaml` and any host-specific files, then run `./install <name>` on
that machine.
