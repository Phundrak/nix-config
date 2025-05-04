# Edit this configuration file to define what should be installed on your
# system.  Help is available in the configuration.nix(5) man page and in
# the NixOS manual (accessible by running ‘nixos-help’).
{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.default
    ../../modules/locale.nix
    ../../modules/system.nix
    ../../modules/ssh.nix
    ../../modules/endlessh.nix
    ../../programs/nano.nix
  ];

  system = {
    amdgpu.enable = false;
    boot = {
      kernel = {
        hardened = true;
        cpuVendor = "amd";
      };
      zfs = {
        enable = true;
        pools = ["tank"];
      };
    };
    docker.enable = true;
    networking = {
      hostname = "tilo";
      id = "7110b33f";
      firewall = {
        openPorts = [
          22 # SSH
          80 # HTTP
          443 # HTTPS
          2222 # endlessh
          25565 # Minecraft
        ];
        extraCommands = ''
          iptables -I INPUT 1 -i 172.16.0.0/12 -p tcp -d 172.17.0.1 -j ACCEPT
          iptables -I INPUT 1 -i 172.16.0.0/12 -p tcp -d 172.17.0.1 -j ACCEPT
        '';
      };
    };
    nix.gc.automatic = true;
    sound.enable = false;
    users = {
      root.disablePassword = true;
      phundrak = true;
    };
    console.keyMap = "fr-bepo";
  };

  modules = {
    ssh = {
      enable = true;
      allowedUsers = ["phundrak"];
      passwordAuthentication = false;
    };
    endlessh.enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = [pkgs.openssl];

  # imports = [
  #   # Include the results of the hardware scan.
  #   ./services.nix
  # ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
