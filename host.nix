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
  # Plasma ships its own Bluetooth applet (Bluedevil); blueman just
  # adds a second, competing tray icon/agent.

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
      libvdpau-va-gl            # VDPAU → VAAPI shim
      # (vpl-gpu-rt removed: oneVPL GPU runtime only supports Tiger Lake
      #  and newer, so it does nothing on Ice Lake.)
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

      # IdeaPads (non-ThinkPad) don't support arbitrary start/stop
      # thresholds — only ideapad_laptop "conservation mode", which
      # caps charge at ~60% (80% on some models). 1 = on, 0 = off.
      # Turn off before a trip when she needs a full charge:
      #   sudo tlp setcharge 0 0 BAT0   (or: sudo tlp fullcharge)
      STOP_CHARGE_THRESH_BAT0 = 1;
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
  # hibernate after a delay. Requires swap >= RAM (check `free -h`).
  #
  # NOTE: while someone is logged into Plasma, PowerDevil takes the
  # lid-switch inhibitor and its own settings win (System Settings →
  # Power Management). These logind settings apply at the SDDM
  # login screen / with no session.
  #
  # TEST ONCE before trusting it with her work: save everything,
  # run `systemctl hibernate`, power back on, confirm the session
  # comes back. If it cold-boots instead, set the resume device
  # explicitly (see commented block below).
  ############################################################
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend-then-hibernate";
    HandleLidSwitchExternalPower = "suspend";
    HandleLidSwitchDocked = "ignore";
    # HandlePowerKey = "suspend";
  };

  systemd.sleep.settings.Sleep = {
    HibernateDelaySec = "30min";
  };

  # Only needed if the hibernate test above fails. Get the offset with:
  #   sudo btrfs inspect-internal map-swapfile -r /swapfile
  # boot.resumeDevice = "/dev/disk/by-uuid/e09ba8fa-2f50-4754-a46f-144d7c7b0693";
  # boot.kernelParams = [ "resume_offset=XXXXXX" ];

  ############################################################
  # Backlight — Plasma handles the brightness keys itself.
  # brightnessctl (packages.nix) works unprivileged via logind's
  # SetBrightness D-Bus call, so no udev rules / light needed.
  ############################################################

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
    # fontconfig.useEmbeddedBitmaps defaults to true as of 26.05
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
