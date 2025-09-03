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
      corne.allowHidAccess = true;
      opentablet.enable = true;
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
      hostFiles = [config.sops.secrets.extraHosts.path];
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
      nix = {
        nix-ld.enable = true;
        trusted-users = ["root" "phundrak"];
      };
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
      phundrak.enable = true;
    };
  };

  sops.secrets.extraHosts = {
    inherit (config.users.users.root) group;
    owner = config.users.users.phundrak.name;
    mode = "0440";
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  fileSystems."/games" = {
    device = "/dev/disk/by-uuid/77d32db8-2e85-4593-b6b8-55d4f9d14e1a";
    fsType = "ext4";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
