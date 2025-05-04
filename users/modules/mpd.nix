{
  services.mpd = {
    enable = true;
    musicDirectory = "/home/phundrak/Music";
    playlistDirectory = "/home/phundrak/Music/playlists";
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
