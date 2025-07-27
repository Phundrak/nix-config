{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.home.desktop.kdeconnect;
in {
  options.home.desktop.kdeconnect.enable = mkEnableOption "Enable KDE Connect";
  config.services.kdeconnect = mkIf cfg.enable {
    enable = true;
    indicator = true;
  };
}
