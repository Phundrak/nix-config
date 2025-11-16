{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mySystem.users;
in {
  options.mySystem.users = {
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
        extraGroups = ["networkmanager" "wheel" "docker" "dialout" "podman" "plugdev" "games" "audio" "input"];
        shell = pkgs.zsh;
        openssh.authorizedKeys.keyFiles = lib.filesystem.listFilesRecursive ../../keys;
      };
    };
    programs.zsh.enable = true;
  };
}
