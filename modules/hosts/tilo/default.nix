{config, ...}: let
  m = config.flake.modules.nixos;
in {
  flake.modules.nixos.tilo = {...}: {
    imports = [
      ./_hardware.nix
      m.system-default
      m.kernel
      m.hardened
      m.loader
      m.zfs
      m.docker
      m.calibre
      m.endlessh
      m.jellyfin
      m.plex
      m.ssh
    ];

    mySystem = {
      boot = {
        kernel.cpuVendor = "amd";
        zfs.pools = ["tank"];
      };
      dev.docker.enable = true;
      misc.keymap = "fr-bepo";
      networking = {
        hostname = "tilo";
        id = "7110b33f";
        firewall = {
          openPorts = [
            80 # HTTP
            443 # HTTPS
            25565 # Minecraft
          ];
        };
      };
      packages.nix.gc.automatic = true;
      services = {
        calibre.enable = true;
        endlessh.enable = true;
        jellyfin.enable = true;
        plex = {
          enable = true;
          dataDir = "/tank/web/stacks/plex/plex-config";
        };
        ssh = {
          enable = true;
          allowedUsers = ["phundrak"];
          passwordAuthentication = false;
        };
      };
      users = {
        root.disablePassword = true;
        phundrak = {
          enable = true;
          trusted = true;
        };
      };
    };

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "24.11"; # Did you read the comment?
  };
}
