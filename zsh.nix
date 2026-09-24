{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
        "history"
        "dirhistory"
        "z"
      ];
    };

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];

    shellAliases = {
      catnips    = "catnip -d alsa_output.pci-0000_0c_00.6.analog-stereo";
      siren      = "mpv --loop ~/media/warsiren.mp3";

      # --- Nix ---
      #nrs    = "sudo nixos-rebuild switch --upgrade --flake /etc/nixos#enterprise";
      #nrt    = "sudo nixos-rebuild test --flake /etc/nixos#enterprise";
      #nrb    = "sudo nixos-rebuild boot --flake /etc/nixos#enterprise";
      cfg    = "$EDITOR /etc/nixos/";
      ns     = "nix search nixpkgs";
      nsp    = "nix-shell -p";
      nsu    = "nix search nixpkgs-unstable";
      ngc    = "sudo nix-collect-garbage -d";
      nlo    = "nix profile list";
      rebuild    = "sudo nixos-rebuild switch --flake ~/nix-config#enterprise";
      update = "sh /etc/nixos/update.sh";

      # --- Git ---
      #g      = "git";
      ga     = "git add";
      gaa    = "git add --all";
      gc     = "git commit";
      gcm    = "git commit -m";
      gca    = "git commit --amend";
      gco    = "git checkout";
      gcb    = "git checkout -b";
      gd     = "git diff";
      gds    = "git diff --staged";
      gl     = "git log --oneline --graph --decorate";
      gla    = "git log --oneline --graph --decorate --all";
      gp     = "git push";
      gpf    = "git push --force-with-lease";
      gpl    = "git pull";
      gst    = "git status";
      gstash = "git stash";
      gpop   = "git stash pop";
      gr     = "git remote -v";
      grb    = "git rebase";
      gri    = "git rebase -i";
      grs    = "git restore";
      grss   = "git restore --staged";
      gcp    = "git cherry-pick";

      # --- General QoL ---
      ".."   = "cd ..";
      "..."  = "cd ../..";
      "...." = "cd ../../..";
      ll     = "ls -lah";
      la     = "ls -A";
      l      = "ls -CF";
      makemine   = "sudo chown -R $USER:$(id -gn)";
      mkdir  = "mkdir -p";
      cp     = "cp -iv";
      mv     = "mv -iv";
      rm     = "rm -iv";
      df     = "df -h";
      du     = "du -sh";
      free   = "free -h";
      grep   = "grep --color=auto";
      p      = "python3";
      #vi     = "nvim";
      #vim    = "nvim";
      #v      = "nvim";
      y      = "yazi";
      yz     = "yazi";
      zshrc  = "$EDITOR ~/.config/zsh/.zshrc";
      vimrc  = "$EDITOR ~/.config/nvim/init.lua";
    };

    initContent = ''
      # Powerlevel10k instant prompt
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi

      # Source p10k config if it exists (run `p10k configure` to generate it)
      [[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
    '';
  };
}
