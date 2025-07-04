{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.system.services.printing;
in {
  options.system.services.printing.enable = mkEnableOption "Enable printing with CUPS";
  config.services.printing = mkIf cfg.enable {
    inherit (cfg) enable;
  };
}
