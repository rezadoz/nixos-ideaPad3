# Your Laptop: A Friendly Guide 💻

Welcome! This is the guide for your Lenovo IdeaPad laptop. You don't need to know anything about computers to use it — this page explains the everyday stuff in plain English.

If something here doesn't make sense, or something goes wrong, **don't worry and don't try to fix it the hard way — just call Bryan.** Nothing you do by accident here will permanently break the laptop (more on why below).

---

## What makes this laptop special

Your laptop doesn't run Windows or Mac. It runs something called **NixOS** with a desktop called **KDE Plasma**. It looks and works a lot like Windows: there's a menu button in the bottom-left corner, a taskbar along the bottom, and a clock in the bottom-right.

The nice thing about this setup is that the whole laptop is built from a "recipe." Bryan keeps that recipe safe online, so if anything ever goes badly wrong, the laptop can be put back exactly the way it was. It also means updates can always be undone (see [If something goes wrong](#if-something-goes-wrong)).

---

## Turning it on and logging in

1. Press the power button.
2. For a few seconds you'll see a plain black screen with a short list of options. **You don't need to touch anything** — just wait and it will continue on its own.
3. At the login screen, click your name (**nasrin**), type your password, and press **Enter**.

---

## Finding your programs

Click the **menu button** in the bottom-left corner (like the Start button on Windows). You can scroll through the list, or just start typing the name of what you want and press **Enter**.

Here's what's installed and what each one is for:

| What you want to do | Program to open |
| --- | --- |
| Browse the internet | **Firefox** (or **Chromium**, a Chrome-like browser) |
| Write letters, make spreadsheets or slideshows | **LibreOffice** (Writer, Calc, Impress) — works with Word and Excel files |
| Quick notes or plain text | **Kate** |
| Look at photos | **Geeqie** |
| Edit photos | **GIMP** |
| Watch videos or play music files | **mpv** (usually opens automatically when you double-click a video) |
| Send files between your phone and laptop | **KDE Connect** (install the "KDE Connect" app on your phone too) |
| Browse your files and folders | **Dolphin** (the folder icon) |

---

## Wi-Fi, Bluetooth, sound, and brightness

All of these live in the **bottom-right corner** of the screen, next to the clock.

- **Wi-Fi:** Click the Wi-Fi icon, pick your network, and type the password. The laptop remembers it after that.
- **Bluetooth** (wireless headphones, speakers, mouse): Click the Bluetooth icon, make sure it's turned on, and pick your device. Put your device in "pairing mode" first if it's the first time.
- **Volume:** Click the speaker icon, or use the volume keys on the keyboard.
- **Screen brightness:** Use the brightness keys on the keyboard (the ones with a little sun symbol).

---

## Printing

Printing is set up to find printers on your home network automatically. In any program, choose **File → Print** (or press **Ctrl + P**) and pick your printer from the list.

If your printer doesn't show up, make sure it's turned on and connected to the same Wi-Fi as the laptop, then try again. Still no luck? Call Bryan.

---

## The battery — please read this one!

**Your battery will stop charging at about 60%. This is on purpose, not a problem.**

Keeping a laptop battery charged to 100% all the time wears it out faster. Stopping around 60% makes the battery last years longer. So if you see the battery icon stop at 60% while plugged in, everything is working correctly.

**Going on a trip and need a full battery?** Ask Bryan, or if you're comfortable, open **Konsole** (see [Updating](#updating-your-laptop) for how), type this, press **Enter**, and type your password:

```
sudo tlp fullcharge
```

It will charge all the way to 100% just this once, and go back to the 60% limit afterward.

The laptop also automatically runs a bit slower and cooler when it's on battery, so the battery lasts longer.

---

## Closing the lid

Closing the lid puts the laptop to **sleep**. Open it up and you'll be right where you left off.

If you leave it closed for a long time while it's not plugged in, it may go into a deeper sleep to save battery. **Always save your work before closing the lid for a long time**, just to be safe.

---

## Updating your laptop

Updates keep the laptop safe and working well. It's a good idea to update **about once a month**.

1. Make sure the laptop is **plugged in** and **connected to Wi-Fi**.
2. Click the menu button, type **Konsole**, and press **Enter**. A window with text will open — this is called a "terminal." It looks technical, but you only need to type one word.
3. Type this and press **Enter**:

   ```
   update
   ```

4. It will ask for your password. **When you type your password, nothing will appear on the screen — no dots, no stars, nothing.** That's normal! Your typing is still being counted. Just type it and press **Enter**.
5. Lots of text will scroll by. This can take anywhere from a few minutes to half an hour. Let it run and don't close the window.
6. When you see **"system update complete!"**, you're done. You can close the window.

It's a good idea to **restart the laptop** after an update.

If you see red text or an error message, don't panic — take a picture of the screen with your phone and send it to Bryan. A failed update does **not** change anything on your laptop.

---

## If something goes wrong

### A program froze
Click the **X** in the corner of its window. If it won't close, wait a minute and try again. Last resort: restart the laptop.

### The laptop is acting strange after an update
This is where this laptop really shines — **every update can be undone.**

1. Restart the laptop.
2. When the short black list appears at startup, press the **down arrow** key once to pick the **second** item in the list, then press **Enter**.
3. The laptop will start up exactly as it was before the last update.

Then let Bryan know, so he can fix the problem properly.

### The whole screen is frozen
Hold the **power button** down for about 10 seconds until the laptop turns off. Wait a moment, then turn it back on.

### Anything else
Call Bryan! 📞

---

## Things the laptop takes care of on its own

You don't need to do anything about these — they just happen in the background:

- **Cleaning up old files** from updates, once a week, so the laptop doesn't fill up.
- **Protecting the laptop** with a built-in firewall that blocks unwanted connections from the internet.
- **Keeping the laptop cool** so it doesn't get too hot or slow down.
- **Keeping the clock correct** (set to Eastern Time).

---

## A few golden rules

1. **Save your work often** (Ctrl + S).
2. **Keep important files backed up** somewhere else too — a USB stick or online storage.
3. **Update about once a month**, while plugged in.
4. **If the battery stops at 60%, that's normal.**
5. **When in doubt, call Bryan.** You can't break anything he can't fix.

---

<details>
<summary><b>For Bryan: technical notes</b> (you can ignore this part)</summary>

- Flake host: `ideapad` · config lives at `/etc/nixos` (root-owned) · user `nasrin`
- Rebuild: `sudo nixos-rebuild switch --flake /etc/nixos#ideapad` (alias: `rebuild`)
- Update: `bash /etc/nixos/update.sh` (alias: `update`) — flake update → rebuild via `nom`
- Inputs: `nixos-26.05`, `nixos-unstable`, `home-manager` · `system.stateVersion = "25.11"`
- Desktop: Plasma 6 + SDDM · audio: PipeWire · printing: CUPS + Avahi, Brother drivers as fallback
- Power: TLP with IdeaPad conservation mode (`STOP_CHARGE_THRESH_BAT0 = 1`), `power-profiles-daemon` disabled, thermald on
- Lid: logind `suspend-then-hibernate` (30 min) at SDDM; PowerDevil settings win inside a Plasma session. **Hibernate-from-swapfile is untested** — see the commented `resume_offset` fallback in `host.nix`
- Boot: systemd-boot, `configurationLimit = 10`, latest kernel, `i915.enable_psr=0`
- Maintenance: weekly `nix.gc` (older than 14d), `auto-optimise-store`
- Files: `flake.nix`, `configuration.nix`, `host.nix` (hardware/power/network), `packages.nix`, `zsh.nix` (home-manager zsh + p10k), `hardware-configuration.nix` (generated, don't edit)

</details>

---
The following is technical info for Bryan
---

# nixos-ideaPad3

NixOS flake configuration for my mom's Lenovo IdeaPad laptop (flake host: `ideapad`).

## Overview

This repo is the `/etc/nixos` configuration for the machine, managed as a Nix flake. It's built and switched with `nixos-rebuild --flake`, and the repo itself lives at `/etc/nixos` on the machine, owned by root.


## Changelog

### 2026-09-25

Moved off the EOL `nixos-25.11` branch and cleared the build warnings it had accumulated.

- Bumped `nixpkgs` and `home-manager` inputs to `26.05` (`system.stateVersion` left at `25.11` — unrelated)
- Migrated `services.logind` lid-switch options to `services.logind.settings.Login.*`
- Migrated `systemd.sleep.extraConfig` to `systemd.sleep.settings.Sleep`
- Wired up `zsh.nix`: set nasrin's login shell to zsh (was previously unused) and fixed p10k instant-prompt ordering
- Corrected several shell aliases copied from another host's config (`rebuild`, `catnips`, `zshrc`, `nsu`)
- Removed `unstable.kdePackages.konsole` (mixed-Qt risk), `blueman` (redundant with Plasma's Bluedevil), `vpl-gpu-rt` (no Ice Lake support)
- Fixed TLP battery thresholds for IdeaPad hardware (conservation mode, not ThinkPad start/stop thresholds)
- Renamed `libreoffice-qt6` → `libreoffice-qt`
- Added `services.avahi` (driverless printer discovery), `boot.loader.systemd-boot.configurationLimit`, weekly `nix.gc`, and a `.gitignore`
- Documented an untested hibernation risk (resume-from-swapfile) and added a commented `boot.resumeDevice`/`resume_offset` fallback


## Structure

```
.
├── flake.nix                   # inputs (nixos-26.05, nixos-unstable, home-manager) + host definition
├── flake.lock
├── configuration.nix           # boot, locale, desktop (Plasma 6), audio, printing, user, nix settings
├── hardware-configuration.nix  # generated by nixos-generate-config — don't edit
├── host.nix                    # laptop hardware: swap, bluetooth, Intel iGPU, TLP, lid/sleep, fonts, networking
├── packages.nix                # system packages
├── zsh.nix                     # home-manager zsh / oh-my-zsh / powerlevel10k config
└── update.sh                   # flake update → rebuild → commit + push
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
