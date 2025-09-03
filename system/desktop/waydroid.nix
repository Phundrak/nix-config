{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mySystem.desktop.waydroid;
in {
  options.mySystem.desktop.waydroid.enable = mkEnableOption "Enables Waydroid";
  config = mkIf cfg.enable {
    virtualisation.waydroid.enable = cfg.enable;
    environment.systemPackages = [pkgs.waydroid-helper];
  };
}
