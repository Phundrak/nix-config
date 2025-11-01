{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.mySystem.services.calibre;
in {
  options.mySystem.services.calibre = {
    enable = mkEnableOption "Enable Calibre Web";
    user = mkOption {
      type = types.str;
      default = "phundrak";
    };
    group = mkOption {
      type = types.str;
      default = "users";
    };
    dataDir = mkOption {
      type = types.str;
      example = "/tank/calibre/conf";
      default = "/tank/calibre/conf";
    };
    library = mkOption {
      type = types.str;
      example = "/tank/calibre/library";
      default = "/tank/calibre/library";
    };
  };
  config.services.calibre-web = mkIf cfg.enable {
    inherit (cfg) enable user dataDir group;
    options = {
      calibreLibrary = cfg.library;
      enableBookConversion = true;
      enableBookUploading = true;
    };
  };
}
