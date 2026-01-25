{
  config,
  pkgs,
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
      plymouth.enable = true;
      kernel = {
        cpuVendor = "intel";
        package = pkgs.linuxPackages;
        modules = ["i915"];
      };
      systemd-boot = true;
    };
    desktop = {
      hyprland.enable = true;
      xserver = {
        enable = true;
        de = "gnome";
      };
    };
    dev.docker = {
      enable = true;
      podman.enable = true;
      autoprune.enable = true;
    };
    hardware = {
      bluetooth.enable = true;
      input = {
        corne.allowHidAccess = true;
        ibmTrackpoint.disable = true;
        opentablet.enable = true;
      };
      sound.enable = true;
    };
    misc.keymap = "fr-bepo";
    networking = {
      hostname = "gampo";
      id = "0630b33f";
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
      ssh.enable = true;
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

  security.rtkit.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database
  # versions on your system were taken. It‘s perfectly fine and
  # recommended to leave this value at the release version of the
  # first install of this system. Before changing this value read
  # the documentation for this option (e.g. man configuration.nix or
  # on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
