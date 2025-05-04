{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.sops-nix.nixosModules.sops
    ./system/hardware-configuration.nix
    ./services.nix
    ../../modules/system.nix
    ../../modules/sops.nix
    ../../modules/opentablet.nix
    ../../programs/flatpak.nix
    ../../programs/steam.nix
  ];

  sops.secrets.extraHosts = {
    inherit (config.users.users.root) group;
    owner = config.users.users.phundrak.name;
    mode = "0440";
  };

  security.polkit.enable = true;

  fileSystems."/games" = {
    device = "/dev/disk/by-uuid/77d32db8-2e85-4593-b6b8-55d4f9d14e1a";
    fsType = "ext4";
  };

  system = {
    amdgpu.enable = true;
    boot.plymouth.enable = true;
    docker = {
      enable = true;
      podman.enable = true;
      autoprune.enable = true;
    };
    networking = {
      hostname = "marpa";
      id = "7EA4A111";
      hostFiles = [config.sops.secrets.extraHosts.path];
      firewall.openPortRanges = [
        {
          # Sunshine
          from = 1714;
          to = 1764;
        }
      ];
    };
    sound = {
      enable = true;
      jack = true;
    };
  };

  security.rtkit.enable = true;

  nix.settings.trusted-users = ["root" "phundrak"];
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    clinfo # AMD
    curl
    openssl
    wget
  ];

  programs.nix-ld.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
