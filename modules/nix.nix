{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.nix;
in {
  options.modules.nix = {
    disableSandbox = mkEnableOption "Disables Nix sandbox";
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
  };

  config = {
    nix = {
      settings = {
        sandbox = cfg.disableSandbox;
        experimental-features = ["nix-command" "flakes"];
        auto-optimise-store = true;
      };
      inherit (cfg) gc;
    };
    nixpkgs.config.allowUnfree = true;
  };
}
