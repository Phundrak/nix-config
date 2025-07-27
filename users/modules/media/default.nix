{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.home.media;
in {
  imports = [
    ./mopidy.nix
    ./mpd.nix
    ./mpd-mpris.nix
    ./mpv.nix
  ];

  options.home.media.fullDesktop = mkEnableOption "Enables everything";
  config.home.media = {
    mopidy.enable = mkDefault cfg.fullDesktop;
    mpd.enable = mkDefault (cfg.fullDesktop or cfg.mpd-mpris.enable);
    mpv.enable = mkDefault cfg.fullDesktop;
  };
}
