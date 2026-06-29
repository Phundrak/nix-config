{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.flake.options.phundrak;
in {
  options.flake.options.phundrak = {
    sudo = mkEnableOption "Make phundrak a superuser";
    trusted = mkOption {
      description = "Mark phundrak as trusted by Nix";
      type = types.bool;
      default = cfg.sudo;
    };
  };
  config = {
    users.users.phundrak = {
      isNormalUser = true;
      description = "Greg";
      extraGroups =
        ["networkmanager" "dialout" "games" "audio" "input"]
        ++ optional cfg.sudo "wheel";
      shell = pkgs.zsh;
      openssh.authorizedKeys.keyFiles = filesystem.listFilesRecursive ./keys;
    };
    nix.settings = mkIf cfg.trusted {
      trusted-users = ["phundrak"];
    };
  };
}
