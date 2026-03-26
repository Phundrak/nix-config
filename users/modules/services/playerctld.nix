{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.home.myServices.playerctld;
in {
  options.home.myServices.playerctld.enable = mkEnableOption "Enable playerctld daemon";
  config.services.playerctld.enable = cfg.enable;
}
