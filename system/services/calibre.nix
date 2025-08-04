{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.system.services.calibre;
in {
  options.system.services.calibre = {
    enable = mkEnableOption "Enable Calibre Web";
    user = mkOption {
      type = types.string;
      default = "phundrak";
    };
    group = mkOption {
      type = types.string;
      default = "users";
    };
    dataDir = mkOption {
      type = types.string;
      example = "/tank/calibre/conf";
      default = "/tank/calibre/conf";
    };
    library = mkOption {
      type = types.string;
      example = "/tank/calibre/library";
      default = "/tank/calibre/library";
    };
  };
  config.services.calibre-web = mkIf cfg.enable {
    inherit (cfg) enable user group dataDir;
    options = {
      calibreLibrary = cfg.library;
      enableBookConversion = true;
      enableBookUploading = true;
    };
  };
}
