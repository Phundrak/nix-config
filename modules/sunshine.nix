{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.sunshine;
in {
  options.modules.sunshine = {
    enable = mkEnableOption "Enables moonlight";
    autostart = mkEnableOption "Enables autostart";
  };
  config.services.sunshine = mkIf cfg.enable {
    enable = true;
    autoStart = cfg.autostart;
    capSysAdmin = true;
    openFirewall = true;
    settings = {
      sunshine_name = "marpa";
    };
  };
}
