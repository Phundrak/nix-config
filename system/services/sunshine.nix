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
    applications.apps = [
      {
        name = "Desktop";
        image-path = "desktop.png";
      }
      {
        name = "Low Res Desktop";
        image-path = "desktop.png";
      }
      {
        name = "Steam Big Picture";
        detached = ["setsid steam steam://open/bigpicture"];
        prep-cmd = {
          do = "";
          undo = "setsid steam steam://close/bigpicture";
        };
        image-path = "steam.png";
      }
      {
        name = "OpenTTD";
        cmd = "openttd";
        image-path = "/home/phundrak/.config/sunshine/covers/igdb_18074.png";
      }
      {
        name = "OpenMW";
        cmd = "openmw";
        image-path = "/home/phundrak/.config/sunshine/covers/igdb_24775.png";
      }
      {
        name = "Vintage Story";
        cmd = "flatpak run at.vintagestory.VintageStory";
        image-path = "/home/phundrak/.config/sunshine/covers/igdb_69547.png";
      }
    ];
  };
}
