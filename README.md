# nixos-ideaPad3
my mom's NixOS laptop!


## 1. Install NixOS

Boot the installer, partition/format your disk, mount it, then:

```bash
sudo nixos-generate-config --root /mnt
sudo nixos-install
reboot
```

## 2. Enable flakes & install git

Add to `/etc/nixos/configuration.nix` temporarily:

```nix
nix.settings.experimental-features = [ "nix-command" "flakes" ];
environment.systemPackages = with pkgs; [ git ];
```

Then rebuild:

```bash
sudo nixos-rebuild switch
```

## 3. Clone the config

```bash
cd /tmp
git clone https://github.com/rezadoz/nixos-ideaPad3.git
```

Back up your auto-generated hardware config, then replace `/etc/nixos`:

```bash
sudo cp /etc/nixos/hardware-configuration.nix /tmp/hardware-configuration.nix.bak
sudo rm /etc/nixos/*.nix
sudo cp /tmp/nixos-ideaPad3/*.nix /etc/nixos/
sudo cp /tmp/hardware-configuration.nix.bak /etc/nixos/hardware-configuration.nix
```

This keeps the repo's `configuration.nix`, `host.nix`, `packages.nix`, `flake.nix` (and any others) but uses **your machine's** `hardware-configuration.nix`.

## 4. Create the user

The config defines a user named `operator`. Either:

- Keep the name and set a password after first rebuild: `sudo passwd operator`, or
- Rename `operator` to your username in `configuration.nix` (two places: `users.users.<name>` and `home-manager.users.<name>`)

## 5. Match the hostname

`flake.nix` and `host.nix` both use `ideapad`. Change both if you want a different name.

## 6. Build

```bash
cd /etc/nixos
sudo nixos-rebuild switch --flake .#ideapad
```

## 7. Post-install

```bash
sudo passwd operator              # if you kept the default user
sudo systemctl status tlp         # confirm power mgmt is running
sudo powertop --calibrate         # one-time, optional
```

## Notes

- If Wi-Fi (Realtek RTL8821CE) is unstable, add to `host.nix`:
```nix
  boot.extraModprobeConfig = "options rtw88_8821ce disable_msi=1";
```
- If screen flickers, remove `i915.enable_psr=0` from `boot.kernelParams` in `configuration.nix`.
- For hibernation, increase swap in `host.nix` to match your RAM size.
- Pull upstream updates later with:
```bash
  cd /tmp && rm -rf nixos-ideaPad3
  git clone https://github.com/rezadoz/nixos-ideaPad3.git
  # then re-copy as in step 3, preserving your hardware-configuration.nix
  sudo nix flake update /etc/nixos
  sudo nixos-rebuild switch --flake /etc/nixos#ideapad
```
