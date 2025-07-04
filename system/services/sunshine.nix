{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.system.services.sunshine;
in {
  options.system.services.sunshine = {
    enable = mkEnableOption "Enables Sunshine";
    autostart = mkEnableOption "Enables autostart";
  };
  config.services.sunshine = mkIf cfg.enable {
    inherit (cfg) enable;
    autoStart = cfg.autostart;
    capSysAdmin = true;
    openFirewall = true;
    settings.sunshine_name = config.system.networking.hostname;
  };
}
