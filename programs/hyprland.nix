{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.hyprland;
in {
  options.modules.hyprland = {
    enable = mkEnableOption "Enables Hyprland";
    config = mkOption {
      type = types.lines;
      default = "";
    };
    waybar = {
      config = mkOption {
        type = types.lines;
        default = "";
      };
      style = mkOption {
        type = types.nullOr types.path;
        default = null;
      };
    };
  };

  config = {
    wayland.windowManager.hyprland = mkIf cfg.enable {
      enable = true;
      xwayland.enable = true;
      systemd.enable = true;
      extraConfig = cfg.config;
    };
    services.wpaperd = {
      enable = true;
      settings = ''
        [default]
        path = "/home/phundrak/Pictures/Wallpapers/nord"
        duration = "5m"
        sorting = "ascending"
      '';
    };
    programs.waybar = {
      enable = true;
      inherit (cfg.waybar) config style;
      systemd.enableInspect = true;
    };
  };
}
