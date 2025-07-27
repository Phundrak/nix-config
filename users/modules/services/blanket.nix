{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.home.services.blanket;
in {
  options.home.services.blanket.enable = mkEnableOption "Enable blanket";
  config.services.blanket.enable = cfg.enable;
}
