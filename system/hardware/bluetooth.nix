{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.mySystem.hardware.bluetooth;
in {
  options.mySystem.hardware.bluetooth.enable = mkEnableOption "Enable bluetooth";
  config = mkIf cfg.enable {
    hardware.bluetooth.enable = cfg.enable;
    services.blueman.enable = cfg.enable;
  };
}
