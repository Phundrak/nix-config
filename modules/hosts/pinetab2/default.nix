{config, ...}: let
  m = config.flake.modules.nixos;
in {
  flake.modules.nixos.pinetab2-base = {config, ...}: {
    imports = [
      m.system-default
      m.sops-system
      m.hyprland
      m.niri
      m.waydroid
      m.xserver
      m.amdgpu
      m.docker
      m.bluetooth
      m.opentablet
      m.sound
      m.i18n-input
      m.appimage
      m.flatpak
      m.ssh
      m.pinetab2
    ];

    system.stateVersion = "25.11";

    mySystem = {
      desktop = {
        hyprland.enable = true;
        niri.enable = true;
        waydroid.enable = true;
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
        input.opentablet.enable = true;
        pinetab2.enable = true;
        sound.enable = true;
      };
      i18n.input.enable = true;
      misc.keymap = "fr-bepo";
      networking = {
        hostname = "pinetab2";
        id = "99a11b15";
        wifi.disablePowersave = true;
      };
      packages = {
        appimage.enable = true;
        flatpak.enable = true;
        nix = {
          gc.automatic = true;
          nix-ld.enable = true;
        };
      };
      services.ssh.enable = true;
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
  };
}
