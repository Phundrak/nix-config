{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.home.media.mpd-mpris;
  cfgMpd = config.home.media.mpd;
in {
  options.home.media.mpd-mpris.enable = mkOption {
    type = types.bool;
    default = cfgMpd.enable;
    example = false;
  };
  config.services.mpd-mpris.enable = cfg.enable;
}
