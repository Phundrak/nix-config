{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.mySystem.services.plex;
in {
  options.mySystem.services.plex = {
    enable = mkEnableOption "Enable Plex";
    group = mkOption {
      type = types.str;
      default = "users";
      example = "users";
      description = "Group under which Plex runs";
    };
    dataDir = mkOption {
      type = types.str;
      example = "/tank/plex-config";
    };
    user = mkOption {
      type = types.str;
      default = "phundrak";
    };
  };
  config = {
    services.plex = mkIf cfg.enable {
      inherit (cfg) enable user group dataDir;
      openFirewall = cfg.enable;
    };
    boot.kernel.sysctl = {
      "kernel.unprivileged_userns_clone" = 1;
    };
  };
}
