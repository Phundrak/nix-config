{config, ...}: let
  m = config.flake.modules.nixos;
in {
  flake.modules.nixos.gampo = {
    config,
    pkgs,
    ...
  }: {
    imports = [
      ./_hardware.nix
      m.system-default
      m.sops-system
      m.kernel
      m.loader
      m.plymouth
      m.hyprland
      m.xserver
      m.docker
      m.bluetooth
      m.fingerprint
      m.corne
      m.disable-ibm-trackpoint
      m.opentablet
      m.sound
      m.i18n-input
      m.appimage
      m.flatpak
      m.steam
      m.fwupd
      m.ssh
    ];

    mySystem = {
      boot = {
        kernel = {
          cpuVendor = "intel";
          package = pkgs.linuxPackages;
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
      misc.keymap = "fr-bepo";
      networking = {
        hostname = "gampo";
        id = "0630b33f";
      };
      packages.nix = {
        gc.automatic = true;
        nix-ld.enable = true;
      };
      services = {
        fwupd.enable = true;
        ssh.enable = true;
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

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database
    # versions on your system were taken. It‘s perfectly fine and
    # recommended to leave this value at the release version of the
    # first install of this system. Before changing this value read
    # the documentation for this option (e.g. man configuration.nix or
    # on https://nixos.org/nixos/options.html).
    system.stateVersion = "23.11"; # Did you read the comment?
  };
}
