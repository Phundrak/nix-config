{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.home.desktop.eww;
in {
  options.home.desktop.eww.enable = mkEnableOption "Enable eww support";
  config.programs.eww = mkIf cfg.enable {
    inherit (cfg) enable;
    configDir = ./eww-config;
  };
}
