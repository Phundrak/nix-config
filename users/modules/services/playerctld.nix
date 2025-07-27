{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.home.services.playerctld;
in {
  options.home.services.playerctld.enable = mkEnableOption "Enable playerctld daemon";
  config.services.playerctld.enable = cfg.enable;
}
