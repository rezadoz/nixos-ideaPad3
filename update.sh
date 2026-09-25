#!/usr/bin/env bash
# NixOS update script for Nasrin's ideapad
# now with automated git commit and push
# bryan wrote this don't touch it

ansi_yellow='\033[1;33m'
ansi_cyan='\033[1;36m'
ansi_green='\033[1;32m'
ansi_red='\033[1;31m'
reset='\033[0m'

LOG_FILE="$HOME/.update.log"
REPO="/etc/nixos"
HOST="ideapad"

# Git runs as root (the repo is root-owned) and authenticates via root's own
# cached credentials (credential.helper store + PAT), set up separately with
# `sudo git config --global credential.helper store`.
rgit() { sudo git -C "$REPO" "$@"; }

if [[ -z "$(sudo git config --global user.email 2>/dev/null)" ]]; then
    printf "${ansi_red}error: root has no git user.email configured — run 'sudo git config --global user.email you@example.com' (and user.name) first${reset}\n"
    exit 1
fi

# Print time since last update
if [[ -f "$LOG_FILE" ]]; then
    last_epoch=$(cat "$LOG_FILE")
    now_epoch=$(date +%s)
    diff=$(( now_epoch - last_epoch ))
    days=$(( diff / 86400 ))
    hours=$(( (diff % 86400) / 3600 ))
    minutes=$(( (diff % 3600) / 60 ))

    time_str=""
    [[ $days -gt 0 ]] && time_str+="${days}d "
    [[ $hours -gt 0 ]] && time_str+="${hours}h "
    [[ $minutes -gt 0 ]] && time_str+="${minutes}m"
    [[ -z "$time_str" ]] && time_str="just now"
    time_str="${time_str%" "}"

    printf "${ansi_cyan}last update ${time_str} ago...${reset}\n"
else
    printf "${ansi_cyan}no update log found — creating one after this run...${reset}\n"
fi
sleep 1

lsd --tree "$REPO"

printf "${ansi_yellow}(1/3) updating flake...${reset}\n"
if ! sudo nix flake update --flake "$REPO"; then
    printf "${ansi_red}error: flake update failed, aborting${reset}\n"
    exit 1
fi

printf "${ansi_yellow}(2/3) nixos-rebuild switch...${reset}\n"
sudo nixos-rebuild switch --flake "$REPO#$HOST" 2>&1 | nom
rebuild_status=${PIPESTATUS[0]}
if [[ $rebuild_status -ne 0 ]]; then
    printf "${ansi_red}error: nixos-rebuild failed (exit ${rebuild_status}), skipping log and git${reset}\n"
    exit "$rebuild_status"
fi

# Only log the update once the rebuild has actually succeeded
date +%s > "$LOG_FILE"

# Take the version from the activated system, so it's always a single clean string
version=$(readlink -f /run/current-system | grep -oP "(?<=-${HOST}-)\S+")
if [[ -z "$version" ]]; then
    printf "${ansi_yellow}warning: could not parse version number, skipping git commit${reset}\n"
    exit 0
fi

printf "${ansi_green}(3/3) committing config to git... [${version}]${reset}\n"
rgit add .
if rgit diff --cached --quiet; then
    printf "${ansi_cyan}nothing new to commit${reset}\n"
else
    rgit commit -m "$version"
fi

# Push even when there was nothing to commit, so earlier unpushed commits go out too
if ! rgit push origin master; then
    printf "${ansi_red}warning: git push failed (commit is saved locally)${reset}\n"
    exit 1
fi

printf "${ansi_green}system update complete! you can now close this window, or press (ctrl + d)${reset}\n"
