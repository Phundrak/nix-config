{
  flake.modules.homeManager.waybar = {
    config,
    lib,
    ...
  }:
    with lib; let
      cfg = config.home.desktop.waybar;
    in {
      options.home.desktop.waybar = {
        enable = mkEnableOption "Enables waybar.";
        battery = mkEnableOption "Enables battery support.";
        style = mkOption {
          type = types.path;
          example = ./style.css;
        };
      };
      config.programs.waybar = mkIf cfg.enable {
        inherit (cfg) enable;
        systemd.enable = true;
        settings = {
          topBar = {
            height = 24;
            spacing = 2;
            modules-left = ["hyprland/workspaces" "hyprland/submap" "hyprland/window"];
            modules-center = [];
            modules-right = [
              "idle_inhibitor"
              "group/audio"
              "group/hardware"
              "network"
              "privacy"
              "clock"
              "tray"
            ];

            idle_inhibitor = {
              format = "{icon}";
              format-icons = {
                activated = "";
                deactivated = "";
              };
            };

            mpris = {
              dynamic-order = ["title" "artist" "album"];
              dynamic-importance-order = ["title" "artist" "album"];
              format = "DEFAULT: {player_icon} {dynamic}";
              format-paused = "DEFAULT: {status_icon} <i>{dynamic}</i>";
              player-icons = {
                default = "▶";
                mpv = "🎵";
              };
              status-icons.paused = "⏸";
              ignored-players = [];
            };

            pulseaudio = {
              format = "{volume}% {icon} {format_source}";
              format-bluetooth = "{volume}% {icon} {format_source}";
              format-bluetooth-muted = " {icon} {format_source}";
              format-muted = " {format_source}";
              format-source = "{volume}% ";
              format-source-muted = "";
              format-icons = {
                headphone = "";
                hands-free = "";
                headset = "";
                phone = "";
                portable = "";
                car = "";
                default = ["" "" ""];
              };
              on-click = "pavucontrol";
            };

            network = {
              format-wifi = "{essid} ({signalStrength}%) ";
              format-ethernet = "{ipaddr}/{cidr} ";
              tooltip-format = "{ifname} via {gwaddr} ";
              format-linked = "{ifname} (No IP) ";
              format-disconnected = "Disconnected ⚠";
              format-alt = "{ifname}: {ipaddr}/{cidr}";
            };

            "group/audio" = {
              modules = ["pulseaudio" "pulseaudio/slider" "mpris"];
              orientation = "inherit";
              drawer.transition-duration = 300;
            };

            "group/hardware" = {
              modules = lists.optional cfg.battery "battery" ++ ["cpu" "memory" "disk"];
              orientation = "inherit";
              drawer.transition-duration = 300;
            };

            cpu = {
              format = "{usage}% ";
              tooltip = false;
            };

            memory.format = "{}% ";

            disk = {
              format = "{path}: {used}/{total} ({percentage_used}%)";
              unit = "GB";
            };

            battery = {
              states = {
                good = 90;
                warning = 30;
                critical = 15;
              };
              format = "{capacity}% {icon}";
              format-charging = "{capacity}% ";
              format-plugged = "{capacity}% ";
              format-alt = "{time} {icon}";
              # An empty format will hide the module
              format-good = "";
              format-full = "";
              format-icons = ["" "" "" "" ""];
            };

            clock = {
              timezones = ["Europe/Paris" "Asia/Tokyo" "America/New_York" "America/Los_Angeles" "Asia/Kathmandu"];
              tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
              format-alt = "{:%Y-%m-%d}";
              actions = {
                on-click-right = "mode";
                on-scroll-up = "tz_up";
                on-scroll-down = "tz_down";
              };
              calendar = {
                mode = "year";
                mode-mon-col = 3;
                weeks-pos = "right";
                on-scroll = 1;
                format = {
                  months = "<span color='#eceff4'><b>{}</b></span>";
                  days = "<span color='#5e81ac'><b>{}</b></span>";
                  weeks = "<span color='#8fbcbb'><b>W{:%W}</b></span>";
                  weekdays = "<span color='#d8dee9'><b>{}</b></span>";
                  today = "<span color='#a3be8c'><b><u>{}</u></b></span>";
                };
              };
            };

            tray.spacing = 10;
          };
        };
        style = builtins.readFile cfg.style;
      };
    };
}
