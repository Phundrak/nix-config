{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.mySystem.hardware.input.opentablet;
in {
  options.mySystem.hardware.input.opentablet.enable = mkEnableOption "Enables OpenTablet drivers";
  config.hardware.opentabletdriver = mkIf cfg.enable {
    inherit (cfg) enable;
    daemon.enable = true;
  };
}
