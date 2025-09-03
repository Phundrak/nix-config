{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.mySystem.services.languagetool;
in {
  options.mySystem.services.languagetool = {
    enable = mkEnableOption "Enables languagetool";
    port = mkOption {
      type = types.port;
      default = 8081;
      example = 80;
    };
  };
  config.services.languagetool = mkIf cfg.enable {
    inherit (cfg) enable port;
  };
}
