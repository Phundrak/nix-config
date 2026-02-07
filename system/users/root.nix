{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mySystem.users.root;
in {
  options.mySystem.users.root.disablePassword = mkEnableOption "Disables root password";
  config = {
    users.users.root = {
      hashedPassword = mkIf cfg.disablePassword "*";
      shell = pkgs.zsh;
    };
  };
}
