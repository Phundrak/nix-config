{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.home.media.streamlink;
in {
  options.home.media.streamlink.enable = mkEnableOption "Enable Streamlink";
  config.programs.streamlink = mkIf cfg.enable {
    enable = true;
    settings = {
      player = "${pkgs.mpv}/bin/mpv";
    };
  };
}
