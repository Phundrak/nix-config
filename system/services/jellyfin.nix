{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.system.services.jellyfin;
in {
  options.system.services.jellyfin = {
    enable = mkEnableOption "Enable Jellyfin";
    dataDir = mkOption {
      type = types.string;
      default = "/tank/jellyfin/data";
      example = "/tank/jellyfin/data";
    };
    user = mkOption {
      type = types.string;
      default = "phundrak";
    };
    group = mkOption {
      type = types.string;
      default = "users";
    };
  };
  config.services.jellyfin = mkIf cfg.enable {
    inherit (cfg) enable group user dataDir;
  };
}
