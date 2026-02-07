{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mySystem.users.phundrak;
in {
  options.mySystem.users.phundrak = {
    enable = mkEnableOption "Enables user phundrak";
    trusted = mkEnableOption "Mark the user as trusted by Nix";
  };

  config = {
    users.users.phundrak = mkIf cfg.enable {
      isNormalUser = true;
      description = "Lucien Cartier-Tilet";
      extraGroups = ["networkmanager" "wheel" "docker" "dialout" "podman" "plugdev" "games" "audio" "input"];
      shell = pkgs.zsh;
      openssh.authorizedKeys.keyFiles = lib.filesystem.listFilesRecursive ../../users/phundrak/keys;
    };
    nix.settings = mkIf cfg.trusted {
      trusted-users = ["phundrak"];
    };
  };
}
