{
  config,
  inputs,
  ...
}: {
  imports = [
    inputs.sops-nix.nixosModules.sops
    ./hardware-configuration.nix
    ../../system
  ];

  fileSystems = {
    "/home".options = [
      "compress=zstd:3" # Good balance of compression vs speed
      "space_cache=v2" # Better performance
      "noatime" # Don't update access times (less writes)
    ];
    "/mnt/ai" = {
      device = "/dev/disk/by-uuid/47e87286-caaa-4e43-b2fd-b9eceac90fe9";
      fsType = "btrfs";
      options = [
        "compress=zstd:3" # Good balance of compression vs speed
        "space_cache=v2" # Better performance
        "noatime" # Don't update access times (less writes)
      ];
    };
    "/mnt/games" = {
      device = "/dev/disk/by-uuid/a8453133-76dc-44bd-a825-444c3305fd9b";
      fsType = "btrfs";
      options = [
        "compress=zstd:3" # Good balance of compression vs speed
        "space_cache=v2" # Better performance
        "noatime" # Don't update access times (less writes)
      ];
    };
    "/games" = {
      device = "/dev/disk/by-uuid/77d32db8-2e85-4593-b6b8-55d4f9d14e1a";
      fsType = "ext4";
    };
  };

  services.displayManager.autoLogin = {
    user = "phundrak";
    enable = true;
  };

  mySystem = {
    boot = {
      extraModprobeConfig = ''
        options snd_usb_audio vid=0x1235 pid=0x8212 device_setup=1
      '';
      plymouth.enable = true;
      kernel.cpuVendor = "amd";
      systemd-boot = true;
    };
    desktop = {
      hyprland.enable = true;
      niri.enable = true;
      waydroid.enable = true;
      xserver = {
        enable = true;
        de = "gnome";
      };
    };
    dev = {
      docker = {
        enable = true;
        podman.enable = true;
        autoprune.enable = true;
      };
      qemu.enable = true;
    };
    hardware = {
      amdgpu.enable = true;
      bluetooth.enable = true;
      input = {
        corne.allowHidAccess = true;
        opentablet.enable = true;
      };
      sound = {
        enable = true;
        jack = true;
        scarlett.enable = true;
      };
    };
    misc.keymap = "fr-bepo";
    networking = {
      hostname = "marpa";
      id = "7EA4A111";
      firewall.openPortRanges = [
        {
          # Sunshine
          from = 1714;
          to = 1764;
        }
      ];
    };
    packages = {
      appimage.enable = true;
      flatpak.enable = true;
      nix.nix-ld.enable = true;
    };
    programs.steam.enable = true;
    services = {
      fwupd.enable = true;
      printing.enable = true;
      ssh.enable = true;
      sunshine = {
        enable = true;
        autostart = true;
      };
      languagetool.enable = true;
    };
    users = {
      root.disablePassword = true;
      phundrak = {
        enable = true;
        trusted = true;
      };
    };
  };

  sops.secrets.extraHosts = {
    inherit (config.users.users.root) group;
    owner = config.users.users.phundrak.name;
    mode = "0440";
  };

  services.udev.extraHwdb = ''
    mouse:usb:047d:80a6:*
     LIBINPUT_MIDDLE_EMULATION_ENABLED=1
  '';

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
