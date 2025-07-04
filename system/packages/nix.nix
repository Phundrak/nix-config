{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.system.packages.nix;
in {
  options.system.packages.nix = {
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
      default = [];
    };
  };

  config = {
    nix = {
      inherit (cfg) gc;
      settings = {
        inherit (cfg) trusted-users;
        sandbox = cfg.disableSandbox;
        experimental-features = ["nix-command" "flakes"];
        auto-optimise-store = true;
      };
    };
    nixpkgs.config.allowUnfree = true;
    programs = {
      inherit (cfg) nix-ld;
    };
  };
}
