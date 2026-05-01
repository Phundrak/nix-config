{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.mySystem.misc;
in {
  imports = [
    ./boot
    ./desktop
    ./dev
    ./hardware
    ./i18n
    ./network
    ./packages
    ./security
    ./services
    ./users
  ];

  options.mySystem.misc = {
    timezone = mkOption {
      type = types.str;
      default = "Europe/Paris";
    };
    keymap = mkOption {
      type = types.str;
      default = "fr";
      example = "fr-bepo";
      description = "Keymap to use in the TTY console";
    };
  };

  config = {
    boot.tmp.cleanOnBoot = true;
    console.keyMap = cfg.keymap;
    time.timeZone = cfg.timezone;
    environment.pathsToLink = [
      "/share/bash-completion"
      "/share/zsh"
    ];
    services = {
      orca.enable = false;
      envfs.enable = true;
    };

    nix.settings = {
      substituters = [
        "http://marpa:5000?priority=5"
        "https://phundrak.cachix.org?priority=10"
        "https://nix-community.cachix.org?priority=20"
        "https://cache.nixos.org?priority=40"
      ];
      trusted-public-keys = [
        "marpa-local:XoO+dFN4PeauF52pYuy3Vh4Sdtl2qIdxu5aUasWKv6Q="
        "phundrak.cachix.org-1:osJAkYO0ioTOPqaQCIXMfIRz1/+YYlVFkup3R2KSexk="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];
      http-connections = 128;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };
}
