{
  config,
  inputs,
  ...
}: {
  imports = [
    inputs.sops-nix.nixosModules.sops
    ../../system/desktop
    ../../system/dev
    ../../system/hardware
    ../../system/i18n
    ../../system/misc.nix
    ../../system/network
    ../../system/packages
    ../../system/security
    ../../system/services
    ../../system/users
  ];

  system.stateVersion = "25.11";
  # documentation.nixos.enable = false;
  # nix.settings.trusted-users = ["root" "@wheel"];

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

}
