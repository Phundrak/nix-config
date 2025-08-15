{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.mySystem.services.printing;
in {
  options.mySystem.services.printing.enable = mkEnableOption "Enable printing with CUPS";
  config.services.printing = mkIf cfg.enable {
    inherit (cfg) enable;
  };
}
