#!/usr/bin/env bash
ansi_yellow='\033[1;33m'
reset='\033[0m'

printf "${ansi_yellow}automated system update script...${reset}\n"
lsd --tree /etc/nixos
printf "${ansi_yellow}(1/3) updating flake...${reset}\n"
printf "${ansi_yellow}type your password then (enter), there is no typing feedback...\n...but you are typing trust me!${reset}\n"
sudo nix flake update --flake /etc/nixos
printf "${ansi_yellow}(2/3) nixos-rebuild switch...${reset}\n"
sudo nixos-rebuild switch --flake /etc/nixos#ideapad |& nom
printf "${ansi_yellow}(3/3) system update complete!\nyou can now close this window, or press (ctrl + d)${reset}\n"
