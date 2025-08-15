{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.mySystem.hardware.opentablet;
in {
  options.mySystem.hardware.opentablet.enable = mkEnableOption "Enables OpenTablet drivers";
  config.hardware.opentabletdriver = mkIf cfg.enable {
    inherit (cfg) enable;
    daemon.enable = true;
  };
}
