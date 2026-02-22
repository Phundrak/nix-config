{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.mySystem.hardware.fingerprint;
in {
  options.mySystem.hardware.fingerprint.enable = mkEnableOption "Enable fingerprint reader";
  config = mkIf cfg.enable {
    hardware.facter.detected.fingerprint.enable = cfg.enable;
  };
}
