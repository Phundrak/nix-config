{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.home.desktop.wlsunset;
in {
  options.home.desktop.wlsunset = {
    enable = mkEnableOption "Enables wlsunset";
    latitude = mkOption {
      type = with types; nullOr (oneOf [str ints.unsigned float]);
      default = 48.5;
    };
    longitude = mkOption {
      type = with types; nullOr (oneOf [str ints.unsigned float]);
      default = 2.2;
    };
  };

  config.services.wlsunset = mkIf cfg.enable {
    inherit (cfg) enable latitude longitude;
  };
}
