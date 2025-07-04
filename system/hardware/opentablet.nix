{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.system.hardware.opentablet;
in {
  options.system.hardware.opentablet.enable = mkEnableOption "Enables OpenTablet drivers";
  config.hardware.opentabletdriver = mkIf cfg.enable {
    inherit (cfg) enable;
    daemon.enable = true;
  };
}
