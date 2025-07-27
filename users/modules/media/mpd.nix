{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.home.media.mpd;
in {
  options.home.media.mpd.enable = mkEnableOption "Enables MPD";
  config.services.mpd = mkIf cfg.enable {
    inherit (cfg) enable;
    musicDirectory = "${config.home.homeDirectory}/Music";
    playlistDirectory = "${config.home.homeDirectory}/Music/playlists";
    network.startWhenNeeded = true;
    extraConfig = ''
      follow_outside_symlinks "yes"
      follow_inside_symlinks "yes"

      bind_to_address "localhost"
      auto_update "yes"

      audio_output {
        type "fifo"
        name "my_fifo"
        path "/tmp/mpd.fifo"
        format "44100:16:2"
      }
    '';
  };
}
