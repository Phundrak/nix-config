{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.system.desktop.niri;
in {
  options.system.desktop.niri.enable = mkEnableOption "Enables Niri";
  config.programs.niri = mkIf cfg.enable {
    inherit (cfg) enable;
  };
}
