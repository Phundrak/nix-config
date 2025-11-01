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
      zfs = {
        enable = true;
        pools = ["tank"];
      };
    };
    dev.docker = {
      enable = true;
      extraDaemonSettings.data-root = "/tank/docker/";
    };
    misc.keymap = "fr";
    networking = {
      hostname = "elcafe";
      id = "501c7fb9";
    };
    packages.nix = {
      gc.automatic = true;
      trusted-users = [
        "root"
        "phundrak"
      ];
    };
    services = {
      endlessh.enable = true;
      plex = {
        enable = true;
        dataDir = "/tank/web/plex-config";
      };
      ssh = {
        enable = true;
        allowedUsers = ["phundrak"];
        passwordAuthentication = false;
      };
      traefik = {
        enable = true;
        envFiles = [config.sops.secrets."elcafe/traefik/env".path];
        dynConf = config.sops.secrets."elcafe/traefik/dynamic".path;
      };
    };
    users = {
      root.disablePassword = true;
      phundrak.enable = true;
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
