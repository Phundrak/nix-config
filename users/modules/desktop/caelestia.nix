{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.home.desktop.caelestia;
in {
  options.home.desktop.caelestia.enable = mkEnableOption "Enables Caelestia Shell";
  config.programs.caelestia = mkIf cfg.enable {
    inherit (cfg) enable;
    systemd = {
      enable = true;
      target = "graphical-session.target";
      environment = [
        "QT3_QPA_PLATFORMTHEME=gtk3"
      ];
    };
    settings = {
      paths.wallpaperDir = "~/Pictures/Wallpapers/nord";
      general = {
        apps = {
          terminal = ["kitty"];
          audio = ["pavucontrol"];
          playback = ["mpv"];
          explorer = ["${pkgs.nemo-with-extensions}/bin/nemo"];
        };
        idle = {
          timeouts = [
            {
              timeout = 300;
              idleAction = "lock";
            }
          ];
        };
      };
      background = {
        desktopClock.enabled = true;
        visualiser.enabled = true;
      };
      dashboard = {
        enabled = true;
        showOnHover = true;
      };
      launcher = {
        enabled = true;
        showOnHover = true;
        useFuzzy = {
          apps = true;
          schemes = true;
          wallpapers = true;
        };
      };
      osd.enableMicrophone = true;
      bar = {
        status = {
          showAudio = true;
          showKbLayout = false;
        };
        tray.compact = true;
      };
      services = mkIf (config.home.gpuType != null) {
        inherit (config.home) gpuType;
      };
      session.commands = {
        logout = ["uwsm" "stop"];
        shutdown = ["systemctl" "poweroff"];
        hibernate = ["systemctl" "hibernate"];
        reboot = ["systemctl" "reboot"];
      };
    };
    cli = {
      enable = true;
      settings.theme.enableGtk = true;
    };
  };
}
