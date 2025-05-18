{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.swaync;
in {
  options.modules.swaync = {
    enable = mkEnableOption "Enables swaync";
  };

  config = mkIf cfg.enable {
    services.swaync.enable = true;
    home.packages = [pkgs.swaynotificationcenter];
  };
}
