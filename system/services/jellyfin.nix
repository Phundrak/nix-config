{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.mySystem.services.jellyfin;
in {
  options.mySystem.services.jellyfin = {
    enable = mkEnableOption "Enable Jellyfin";
    dataDir = mkOption {
      type = types.str;
      default = "/tank/jellyfin/data";
      example = "/tank/jellyfin/data";
    };
    user = mkOption {
      type = types.str;
      default = "phundrak";
    };
    group = mkOption {
      type = types.str;
      default = "users";
    };
  };
  config.services.jellyfin = mkIf cfg.enable {
    inherit (cfg) enable group user dataDir;
  };
}
