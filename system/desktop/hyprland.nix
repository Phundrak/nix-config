{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.system.desktop.hyprland;
in {
  options.system.desktop.hyprland.enable = mkEnableOption "Enables Hyprland";
  config.programs.hyprland = mkIf cfg.enable {
    inherit (cfg) enable;
    withUWSM = true;
  };
}
