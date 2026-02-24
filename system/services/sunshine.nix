{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.mySystem.services.sunshine;
in {
  options.mySystem.services.sunshine = {
    enable = mkEnableOption "Enables Sunshine";
    autostart = mkEnableOption "Enables autostart";
  };
  config.services.sunshine = mkIf cfg.enable {
    inherit (cfg) enable;
    autoStart = cfg.autostart;
    capSysAdmin = true;
    openFirewall = true;
    settings = {
      sunshine_name = config.mySystem.networking.hostname;
      locale = "en_GB";
      system_tray = "enabled";
      output_name = 1;
    };
    applications.apps = let
      defaultPrep = [
        {
          do = "sh -c \"hyprctl -i 0 keyword monitor \\\"DP-2,\${SUNSHINE_CLIENT_WIDTH}x\${SUNSHINE_CLIENT_HEIGHT}@\${SUNSHINE_CLIENT_FPS},0x0,1\\\"\"";
          undo = "sh -c \"hyprctl -i 0 keyword monitor 'DP-2,2560x1080@60,0x0,1,transform,1'\"";
        }
      ];
    in [
      {
        name = "Desktop";
        image-path = "desktop.png";
        prep-cmd = defaultPrep;
      }
      {
        name = "Low Res Desktop";
        image-path = "desktop.png";
        prep-cmd = defaultPrep;
      }
      {
        name = "Steam Big Picture";
        detached = ["setsid steam steam://open/bigpicture"];
        prep-cmd = defaultPrep;
        image-path = "steam.png";
      }
      {
        name = "OpenTTD";
        cmd = "openttd";
        image-path = "/home/phundrak/.config/sunshine/covers/igdb_18074.png";
        prep-cmd = defaultPrep;
      }
      {
        name = "OpenMW";
        cmd = "openmw";
        image-path = "/home/phundrak/.config/sunshine/covers/igdb_24775.png";
        prep-cmd = defaultPrep;
      }
      {
        name = "Vintage Story";
        cmd = "flatpak run at.vintagestory.VintageStory";
        image-path = "/home/phundrak/.config/sunshine/covers/igdb_69547.png";
        prep-cmd = defaultPrep;
      }
    ];
  };
}
