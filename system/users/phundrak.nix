{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.system.users;
in {
  options.system.users = {
    root.disablePassword = mkEnableOption "Disables root password";
    phundrak.enable = mkEnableOption "Enables users phundrak";
  };

  config = {
    users.users = {
      root = {
        hashedPassword = mkIf cfg.root.disablePassword "*";
        shell = pkgs.zsh;
      };
      phundrak = mkIf cfg.phundrak.enable {
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
