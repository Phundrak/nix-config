{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.home.cli.yt-dlp;
in {
  options.home.cli.yt-dlp.enable = mkEnableOption "Enable yt-dlp";
  config.programs.yt-dlp = mkIf cfg.enable {
    inherit (cfg) enable;
    settings = {
      embed-thumbnail = true;
      embed-subs = true;
      sub-langs = "all";
    };
  };
}
