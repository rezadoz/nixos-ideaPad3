{ config, pkgs, lib, ... }:

{
  ############################################################
  # Swap
  #
  # 8 GB on-disk swapfile is fine for an IdeaPad 3 (typically
  # 4-12 GB RAM). Bump to RAM-size if you ever want hibernation.
  # zram on top gives you fast compressed swap in RAM.
  ############################################################
  swapDevices = [
    {
      device = "/swapfile";
      size = 8 * 1024;          # MB → 8 GB
    }
  ];

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };

  ############################################################
  # Bluetooth
  ############################################################
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;    # battery reporting, etc.
      };
    };
  };
  services.blueman.enable = true;

  ############################################################
  # Graphics — Intel Ice Lake (10th gen) iGPU
  #
  # The IdeaPad 3 15IIL05 ships with i3/i5/i7-10xxG1/G4/G7 CPUs
  # whose integrated UHD/Iris Plus graphics need the i915 driver
  # plus VAAPI for hardware video decode.
  ############################################################
  hardware.graphics = {
    enable = true;
    enable32Bit = true;         # 32-bit games / Steam
    extraPackages = with pkgs; [
      intel-media-driver        # iHD VAAPI driver (Gen9+, includes Ice Lake)
      vpl-gpu-rt                # successor to intel-media-sdk on newer kernels
      libvdpau-va-gl            # VDPAU → VAAPI shim
    ];
  };

  # Hint apps that don't auto-detect to use the iHD driver.
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
  };

  ############################################################
  # Power management — TLP
  #
  # TLP is the safe default for Lenovo laptops. Do NOT also
  # enable services.auto-cpufreq or services.power-profiles-daemon
  # — they fight each other.
  ############################################################
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 60;

      # Lenovo battery care thresholds (works if your firmware
      # exposes them; harmless if not). Stop charging at 80% to
      # prolong battery lifespan.
      START_CHARGE_THRESH_BAT0 = 75;
      STOP_CHARGE_THRESH_BAT0 = 80;
    };
  };

  # power-profiles-daemon ships enabled by default on Plasma 6.
  # Disable it so TLP can take over without conflict.
  services.power-profiles-daemon.enable = false;

  # Thermald helps Intel laptops avoid throttling. Cheap insurance.
  services.thermald.enable = true;

  # Alternative: auto-cpufreq. Leave commented unless you want to
  # swap *away* from TLP (don't run both).
  # services.auto-cpufreq.enable = true;

  ############################################################
  # Lid / suspend behaviour
  #
  # Suspend-then-hibernate: suspend immediately, then move to
  # hibernate after a delay. Saves battery if the laptop sits
  # closed for a long time. Requires a swap area large enough
  # to fit RAM — if your laptop has more RAM than the 8 GB swap
  # above, bump the swap size.
  ############################################################
  services.logind = {
    lidSwitch = "suspend-then-hibernate";
    lidSwitchExternalPower = "suspend";
    lidSwitchDocked = "ignore";
#     extraConfig = ''  # The option definition `services.logind.extraConfig' is bad. Use services.logind.settings.Login instead.
#       HandlePowerKey=suspend
#       IdleAction=suspend-then-hibernate
#       IdleActionSec=15min
#     '';
  };

  systemd.sleep.extraConfig = ''
    HibernateDelaySec=30min
  '';

  ############################################################
  # Backlight — brightnessctl works without root via udev rules
  # included by the package. The `video` group on the user is set
  # in configuration.nix TODO: FIX
  ############################################################
  programs.light.enable = false;  # we use brightnessctl instead

  ############################################################
  # Firmware (recommended for laptops; lets `fwupdmgr` pull
  # Lenovo BIOS/EC updates from LVFS). Uncomment if you want it.
  ############################################################
  # services.fwupd.enable = true;

  ############################################################
  # Fonts
  ############################################################
  fonts = {
    packages = with pkgs; [
      nerd-fonts.agave
      nerd-fonts.fira-code
      nerd-fonts.hack
      nerd-fonts.iosevka
      nerd-fonts.jetbrains-mono
      nerd-fonts.meslo-lg
      nerd-fonts.victor-mono
      nerd-fonts.zed-mono
      cozette
      dina-font
      liberation_ttf
      noto-fonts
      noto-fonts-color-emoji
    ];
    fontconfig = {
      enable = true;
      useEmbeddedBitmaps = true;
    };
  };

  ############################################################
  # Networking
  #
  # NetworkManager handles roaming Wi-Fi/Ethernet — no static IP
  # on a laptop. Firewall on with sensible defaults; nothing
  # listens on the network unless you turn on a service below.
  ############################################################
  networking = {
    hostName = "ideapad";        # change if you want
    networkmanager.enable = true;
    # Let NM handle DHCP per-interface; global DHCP off.
    useDHCP = lib.mkDefault false;

    nameservers = [ "1.1.1.1" "9.9.9.9" ];

    firewall = {
      enable = true;
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
    };
  };

  ############################################################
  # Services you previously had — DISABLED for a laptop.
  # Uncomment any you actually want.
  ############################################################

  # SSH server: handy for remote access, but a laptop on hostile
  # networks is the wrong place for it. Only enable if you know
  # you need it.
  # services.openssh = {
  #   enable = true;
  #   openFirewall = true;
  #   settings = {
  #     PasswordAuthentication = false;   # use keys
  #     PermitRootLogin = "no";
  #     KbdInteractiveAuthentication = false;
  #     X11Forwarding = false;
  #   };
  #   ports = [ 22 ];
  # };

  # Jellyfin / nginx: media-server stuff. Not appropriate for a
  # laptop that sleeps and roams networks. Re-enable only if you
  # really mean it.
  # services.jellyfin = {
  #   enable = true;
  #   openFirewall = true;
  # };
  # services.nginx = {
  #   enable = true;
  #   recommendedGzipSettings = true;
  #   recommendedOptimisation = true;
  #   recommendedProxySettings = true;
  #   recommendedTlsSettings = true;
  # };
}
