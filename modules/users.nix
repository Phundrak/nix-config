{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.users;
in {
  options.modules.users = {
    root.disablePassword = mkEnableOption "Disables root password";
    phundrak = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = {
    users.users = {
      root = {
        hashedPassword = mkIf cfg.root.disablePassword "*";
        shell = pkgs.zsh;
      };
      phundrak = {
        isNormalUser = true;
        description = "Lucien Cartier-Tilet";
        extraGroups = ["networkmanager" "wheel" "docker" "dialout" "podman"];
        shell = pkgs.zsh;
        openssh.authorizedKeys.keyFiles = lib.filesystem.listFilesRecursive ./keys;
      };
    };
    programs.zsh.enable = true;
  };
}
