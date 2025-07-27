{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.home.desktop.swaync;
in {
  options.home.desktop.swaync.enable = mkEnableOption "Enables swaync";
  config = mkIf cfg.enable {
    services.swaync.enable = true;
    home.packages = [pkgs.swaynotificationcenter];
  };
}
