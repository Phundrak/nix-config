{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.mySystem.desktop.hyprland;
in {
  options.mySystem.desktop.hyprland.enable = mkEnableOption "Enables Hyprland";
  config.programs.hyprland = mkIf cfg.enable {
    inherit (cfg) enable;
    withUWSM = true;
  };
}
