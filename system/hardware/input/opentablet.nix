{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.mySystem.hardware.input.opentablet;
in {
  options.mySystem.hardware.input.opentablet.enable = mkEnableOption "Enables OpenTablet drivers";
  config = mkIf cfg.enable {
    hardware.opentabletdriver = {
      inherit (cfg) enable;
      daemon.enable = true;
    };
    boot.kernelModules = ["wacom"];
  };
}
