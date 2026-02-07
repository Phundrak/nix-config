{
  inputs,
  config,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.default
    ../../system
  ];

  sops.secrets = {
    "elcafe/traefik/env".restartUnits = ["traefik.service"];
    "elcafe/traefik/dynamic".restartUnits = ["traefik.service"];
  };

  mySystem = {
    boot = {
      kernel = {
        hardened = true;
        cpuVendor = "intel";
      };
      grub = {
        enable = true;
        device = "/dev/sdh";
      };
      zfs = {
        enable = true;
        pools = ["tank"];
      };
    };
    dev.docker = {
      enable = true;
      storage = "/tank/docker/";
    };
    misc.keymap = "fr";
    networking = {
      hostname = "elcafe";
      id = "501c7fb9";
    };
    packages.nix.gc.automatic = true;
    services = {
      endlessh.enable = true;
      ssh = {
        enable = true;
        allowedUsers = ["phundrak"];
        passwordAuthentication = true;
      };
      traefik = {
        enable = false;
        environmentFiles = [config.sops.secrets."elcafe/traefik/env".path];
        dynamicConfigFile = config.sops.secrets."elcafe/traefik/dynamic".path;
      };
    };
    users = {
      root.disablePassword = true;
      phundrak = {
        enable = true;
        trusted = true;
      };
      creug = {
        enable = true;
        sudo = true;
      };
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
