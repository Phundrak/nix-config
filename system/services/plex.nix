{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.system.services.plex;
in {
  options.system.services.plex = {
    enable = mkEnableOption "Enable Plex";
    group = mkOption {
      type = types.string;
      default = "users";
      example = "users";
      description = "Group under which Plex runs";
    };
    dataDir = mkOption {
      type = types.string;
      example = "/tank/plex-config";
    };
    user = mkOption {
      type = types.string;
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
