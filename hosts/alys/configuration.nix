{inputs, ...}: {
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.default
    ../../system
  ];

  mySystem = {
    boot = {
      kernel.hardened = true;
      systemd-boot = false;
      zram = {
        enable = true;
        memoryMax = 512;
      };
    };
    dev.docker.enable = true;
    networking = {
      hostname = "alys";
      domain = "phundrak.com";
      id = "41157110";
    };
    packages.nix = {
      gc.automatic = true;
      trusted-users = ["root" "phundrak"];
    };
    services = {
      endlessh.enable = true;
      ssh = {
        enable = true;
        allowedUsers = ["phundrak"];
        passwordAuthentication = false;
      };
    };
    users = {
      root.disablePassword = true;
      phundrak.enable = true;
    };
  };
  system.stateVersion = "23.11";
}
