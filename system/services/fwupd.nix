{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.mySystem.services.fwupd;
in {
  options.mySystem.services.fwupd.enable = mkEnableOption "Enable fwupd";
  config.services.fwupd = mkIf cfg.enable {
    inherit (cfg) enable;
  };
}
