{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.home.myServices.blanket;
in {
  options.home.myServices.blanket.enable = mkEnableOption "Enable blanket";
  config.services.blanket.enable = cfg.enable;
}
