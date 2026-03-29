{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  configDir = config.xdg.configHome;
  cfg = config.home.desktop.wl-kbptr;
  iniFormat = pkgs.formats.ini {};
in {
  options.home.desktop.wl-kbptr = {
    enable = mkEnableOption "enable wl-kbptr";
    config = mkOption {
      inherit (iniFormat) type;
      default = {};
      description = ''
        Options to add to the {file}`config` file. See
        <https://github.com/moverest/wl-kbptr/blob/main/config.example>
        for options.
      '';
      example = {
        general = {
          home_row_keys = "abcd";
        };
      };
    };
  };
  config = mkIf cfg.enable {
    home = {
      packages = [pkgs.wl-kbptr];
      file."${configDir}/wl-kbptr/config" = mkIf (cfg.config != {}) {
        source = iniFormat.generate "wl-kbptr-config" cfg.config;
      };
    };
  };
}
