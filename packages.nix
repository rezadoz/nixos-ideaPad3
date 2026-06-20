{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # applications
    btop                    # was btop-cuda; no NVIDIA on this laptop
    catnip
    chromium                # google chrome web browser
    feh
    fish
    ffmpeg
    geeqie
    gimp gimpPlugins.gmic
    libreoffice-qt6
    mpv
    qbittorrent
    qemu_full
    quickemu                # qemu wrapper
    retroarch
    #steam                  # redundant — using programs.steam.enable
    protonup-qt
    tlrc                    # tldr
    wineWow64Packages.waylandFull
    winetricks
    yazi
    zathura
    zsh zsh-powerlevel10k

    # utilities
    _7zz-rar unrar
    bat
    fastfetch
    file
    hunspellDicts.en-us-large
    imagemagick
    lsd
    ripgrep
    rsclock
    nix-output-monitor
    nmap
    pv
    qdirstat
    tree
    weather
    unzip
    yt-dlp
    wavemon
    zip
    unstable.kdePackages.konsole

    # laptop-specific tooling
    brightnessctl           # backlight control + udev rules
    powertop                # power-draw diagnostics
    acpi                    # battery info from the CLI
    lm_sensors              # temperature/fan sensors
    pciutils                # lspci — useful for hardware debugging
    usbutils                # lsusb
    wirelesstools           # iwconfig etc. (NM also fine on its own)
    iw                      # modern wireless tool

    # dev pkgs
    autoconf
    automake
    binutils
    clang
    cmake
    curl
    gcc
    gdb
    git
    gnumake
    libtool
    llvm
    meson
    ninja
    openssl
    patch
    pkg-config
    python3
    rustup
    stdenv.cc
    wget
  ];
}
