{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.kdeconnect;
in {
  options.modules.kdeconnect.enable = mkEnableOption "Enable KDEConnect";

  config.services.kdeconnect = mkIf cfg.enable {
    enable = true;
    indicator = true;
  };
}
