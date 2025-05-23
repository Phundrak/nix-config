{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.sops-nix.nixosModules.sops
    ./hardware-configuration.nix
    ./services
    ../../modules/opentablet.nix
    ../../modules/sops.nix
    ../../modules/system.nix
    ../../programs/flatpak.nix
    ../../programs/hyprland.nix
    ../../programs/steam.nix
  ];

  sops.secrets.extraHosts = {
    inherit (config.users.users.root) group;
    owner = config.users.users.phundrak.name;
    mode = "0440";
  };

  boot.initrd.kernelModules = ["i915"];

  system = {
    boot.plymouth.enable = true;
    docker = {
      enable = true;
      autoprune.enable = true;
      podman.enable = true;
    };
    networking = {
      hostname = "gampo";
      id = "0630b33f";
      hostFiles = [config.sops.secrets.extraHosts.path];
    };
    sound.enable = true;
  };

  modules.hyprland.enable = true;

  security.rtkit.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    curl
    openssl
    wget
  ];

  nix.settings.trusted-users = ["root" "phundrak"];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database
  # versions on your system were taken. It‘s perfectly fine and
  # recommended to leave this value at the release version of the
  # first install of this system. Before changing this value read
  # the documentation for this option (e.g. man configuration.nix or
  # on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
