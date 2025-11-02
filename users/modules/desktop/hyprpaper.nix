{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.home.desktop.hyprpaper;
in {
  options.home.desktop.hyprpaper = {
    enable = mkEnableOption "Enables Hyprpaper";
    default = mkOption {
      type = types.str;
      default = "/home/phundrak/Pictures/Wallpapers/nord/Nordic6.jpg";
      example = "/home/user/image.jpg";
    };
    wallpapers-dir = mkOption {
      type = types.str;
      default = "/home/phundrak/Pictures/Wallpapers/nord/";
      example = "/home/user/Pictures/";
    };
    rotation-interval = mkOption {
      type = types.str;
      default = "5m";
      example = "10m";
      description = "Interval between wallpaper rotations";
    };
  };
  config = mkIf cfg.enable {
    services.hyprpaper = {
      inherit (cfg) enable;
      settings = {
        ipc = "on";
        splash = false;
        preload = cfg.default;
        wallpaper = ", ${cfg.default}";
      };
    };
    systemd.user = {
      services.hyprpaper-rotation = {
        Unit = {
          Description = "Rotate Hyprpaper wallpaper";
          After = "graphical-session.target";
        };
        Service = {
          Type = "oneshot";
          ExecCondition = "pidof Hyprland";
          ExecStart = "${config.home.homeDirectory}/.config/hypr/hyprpaper-rotate.sh";
        };
      };

      timers.hyprpaper-rotation = {
        Unit = {
          Description = "Timer for rotating Hyprpaper wallpaper";
        };
        Timer = {
          OnBootSec = cfg.rotation-interval;
          OnUnitActiveSec = cfg.rotation-interval;
        };
        Install = {
          WantedBy = ["timers.target"];
        };
      };
    };
    home.file.".config/hypr/hyprpaper-rotate.sh" = {
      text = ''
        #!/usr/bin/env bash
        set -euo pipefail

        WALLPAPER_DIR="${cfg.wallpapers-dir}"

        # Find a random wallpaper
        WP=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | shuf -n 1)

        if [ -z "$WP" ]; then
          echo "No wallpapers found in $WALLPAPER_DIR"
          exit 1
        fi

        echo "Setting wallpaper to: $WP"

        # Load and set the wallpaper
        hyprctl hyprpaper preload "$WP" && hyprctl hyprpaper wallpaper ",$WP"
      '';
      executable = true;
    };
  };
}
