{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.hyprland;
in {
  options.modules.hyprland.enable = mkEnableOption "Enables Hyprland";
  config.programs.hyprland = mkIf cfg.enable {
    inherit (cfg) enable;
    withUWSM = true;
  };
}
