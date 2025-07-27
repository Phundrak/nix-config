{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.home.desktop.qt;
in {
  options.home.desktop.qt.enable = mkEnableOption "Enable Qt support";
  config.qt.enable = cfg.enable;
}
