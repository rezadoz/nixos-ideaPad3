# nixos-ideaPad3

NixOS flake configuration for my mom's Lenovo IdeaPad laptop (flake host: `ideapad`).

## Overview

This repo is the `/etc/nixos` configuration for the machine, managed as a Nix flake. It's built and switched with `nixos-rebuild --flake`, and the repo itself lives at `/etc/nixos` on the machine, owned by root.

## Structure

Adjust this section to match the actual layout of the repo (e.g. `flake.nix`, `flake.lock`, `configuration.nix`, any `hosts/` or `modules/` directories).

```
.
├── flake.nix
├── flake.lock
├── configuration.nix
├── hardware-configuration.nix
└── update.sh
```

## Updating the system

Run `update.sh`. It:

1. Updates the flake inputs (`nix flake update`)
2. Rebuilds and switches the system (`nixos-rebuild switch --flake /etc/nixos#ideapad`)
3. On a successful rebuild, commits the updated config to this repo (tagged with the resulting system version) and pushes to `origin master`

If the flake update or the rebuild fails, the script stops before touching git, so a bad build never gets committed. A log of the last successful update time is kept at `~/.update.log`.

### Requirements

- `lsd` (used to print the repo tree at the start of the run)
- `nom` (`nix-output-monitor`, used to pipe the rebuild output)
- Git configured for root (`sudo git config --global user.name`/`user.email`), with push credentials cached via `credential.helper store`

## Notes

This is a personal/family machine config — expect it to be tailored to this specific laptop's hardware and my mom's use case rather than written as a general-purpose template.
