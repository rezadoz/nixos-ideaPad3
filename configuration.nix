# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help').

{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./host.nix
      ./packages.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Latest kernel — gets you newer Intel iGPU and Wi-Fi support.
  # If you want long-term stability instead, swap to
  # `pkgs.linuxPackages` (current LTS).
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Silent boot + quick fb console. Comment out if you want verbose boot.
  boot.kernelParams = [
    "quiet"
    "splash"
    # Ice Lake (10th gen) iGPU sometimes needs this if you see flicker
    # or backlight weirdness. Harmless to leave on.
    "i915.enable_psr=0"
  ];

  time.timeZone = "America/New_York";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.printing.enable = true;

  # sound
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    #jack.enable = true;
  };

  # Touchpad. libinput is enabled by default with Plasma6 + xserver,
  # but turning it on explicitly keeps tap-to-click & natural scroll
  # discoverable in your config.
  services.libinput = {
    enable = true;
    touchpad = {
      tapping = true;
      naturalScrolling = true;
      disableWhileTyping = true;
    };
  };

  users.users.operator = {
    isNormalUser = true;
    description = "operator";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" "input" ];
    packages = with pkgs; [
      kdePackages.kate
      # thunderbird
    ];
  };

  home-manager.users.operator = { pkgs, ... }: {
    imports = [ ./zsh.nix ];
    home.stateVersion = "25.11"; # DO NOT EDIT
  };

  programs.firefox.enable = true;

  programs.neovim = {
    enable = true;
    viAlias = false;
    vimAlias = false;
  };

  programs.steam.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git
    vim
    # wget
  ];

  system.stateVersion = "25.11"; # DO NOT EDIT
}
