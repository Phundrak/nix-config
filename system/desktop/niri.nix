{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.mySystem.desktop.niri;
in {
  options.mySystem.desktop.niri.enable = mkEnableOption "Enables Niri";
  config.programs.niri = mkIf cfg.enable {
    inherit (cfg) enable;
  };
}
