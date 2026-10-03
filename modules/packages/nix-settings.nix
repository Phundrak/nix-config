{
  flake.modules.nixos.nix-settings = {
    lib,
    config,
    ...
  }:
    with lib; let
      cfg = config.mySystem.packages.nix;
    in {
      options.mySystem.packages.nix = {
        allowUnfree = mkEnableOption "Enable unfree packages";
        disableSandbox = mkEnableOption "Disable Nix sandbox";
        gc = {
          automatic = mkOption {
            type = types.bool;
            default = true;
          };
          dates = mkOption {
            type = types.str;
            default = "Monday 01:00 UTC";
          };
          options = mkOption {
            type = types.str;
            default = "--delete-older-than 30d";
          };
        };
        nix-ld.enable = mkEnableOption "Enable unpatched binaries support";
        trusted-users = mkOption {
          type = types.listOf types.str;
          example = ["alice" "bob"];
          default = ["@wheel" "root"];
        };
      };

      config = {
        nixpkgs.config.allowUnfree = true;
        nix.settings.sandbox = cfg.disableSandbox;
        nix.gc = cfg.gc;
        programs.nix-ld = cfg.nix-ld;
        nix.settings.trusted-users = cfg.trusted-users;
        nix.settings.experimental-features = ["nix-command" "flakes"];
        nix.settings.auto-optimise-store = true;
      };
    };
}
