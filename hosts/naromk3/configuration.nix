{inputs, ...}: {
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.default
    ../../system
  ];

  mySystem = {
    boot = {
      kernel = {
        hardened = true;
        cpuVendor = "amd";
      };
      grub = {
        enable = true;
        device = "/dev/sdb";
      };
    };
    dev.docker.enable = true;
    misc.keymap = "fr-bepo";
    networking = {
      hostname = "NaroMk3";
      id = "0003beef";
      firewall = {
        openPorts = [
          22 # Gitea SSH
          80 # HTTP
          443 # HTTPS
        ];
      };
    };
    packages.nix = {
      gc.automatic = true;
      trusted-users = ["phundrak"];
    };
    services = {
      endlessh.enable = false;
      ssh = {
        enable = true;
        allowedUsers = ["phundrak"];
        passwordAuthentication = false;
        port = 2222; # port 22 will be used by Gitea
      };
    };
    users = {
      root.disablePassword = true;
      phundrak.enable = true;
    };
  };

  # This option defines the first version of NixOS you have installed
  # on this particular machine, and is used to maintain compatibility
  # with application data (e.g. databases) created on older NixOS
  # versions.
  #
  # Most users should NEVER change this value after the initial
  # install, for any reason, even if you've upgraded your system to a
  # new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and
  # OS are pulled from, so changing it will NOT upgrade your system -
  # see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT
  # mean your system is out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all
  # the changes it would make to your configuration, and migrated your
  # data accordingly.
  #
  # For more information, see `man configuration.nix` or
  # https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion
  system.stateVersion = "25.05"; # Did you read the comment?
}
