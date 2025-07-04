{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.system.services.fwupd;
in {
  options.system.services.fwupd.enable = mkEnableOption "Enable fwupd";
  config.services.fwupd = mkIf cfg.enable {
    inherit (cfg) enable;
  };
}
