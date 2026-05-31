{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.home.media.ncmpcpp;
in {
  options.home.media.ncmpcpp.enable = mkEnableOption "Enable ncmpcpp";
  config.programs.ncmpcpp = let
    musicDir = config.services.mpd.musicDirectory;
  in
    mkIf cfg.enable {
      inherit (cfg) enable;
      mpdMusicDir = musicDir;
      settings = {
        # directories
        ncmpcpp_directory = "${config.home.homeDirectory}/.config/ncmpcpp";
        lyrics_directory = "${musicDir}/.lyrics";

        # MPD
        mpd_host = "localhost";
        mpd_port = 6600;
        mpd_connection_timeout = 5;
        mpd_crossfade_time = 0;

        # music visualizer
        visualizer_output_name = "my_fifo";
        visualizer_in_stereo = "yes";
        # visualizer_type = "spectrum";
        visualizer_look = "+|";
        visualizer_color = "blue, cyan, green, yellow, magenta, red";

        system_encoding = "UTF-8";

        # song format
        song_list_format = "(6)[]{} (23)[red]{a} (26)[yellow]{t|f} (40)[green]{b} (4)[blue]{l}";
        now_playing_prefix = "$b";
        now_playing_suffix = "$8$/b";

        # columns settings
        song_columns_list_format = "(6)[]{} (23)[red]{a} (26)[yellow]{t|f} (40)[green]{b} (4)[blue]{l}";

        playlist_shorten_total_times = "yes";
        playlist_display_mode = "columns";
        browser_display_mode = "columns";
        search_engine_display_mode = "columns";
        playlist_editor_display_mode = "columns";
        autocenter_mode = "yes";
        centered_cursor = "yes";

        progressbar_look = "─> ";
        header_visibility = "no";
        statusbar_visibility = "no";
        titles_visibility = "no";
        allow_for_physical_item_deletion = "yes";

        lastfm_preferred_language = "en";
        space_add_mode = "add_remove";

        locked_screen_width_part = "50";
        ask_for_locked_screen_width_part = "yes";
        jump_to_now_playing_song_at_start = "yes";
        ask_before_clearing_playlists = "yes";
        clock_display_seconds = "no";
        display_volume_level = "yes";
        display_bitrate = "no";
        display_remaining_time = "yes";
        regular_expressions = "extended";
        ignore_leading_the = "yes";
        ignore_diacritics = "yes";
        mouse_support = "no";
        tags_separator = ";";
        enable_window_title = "yes";
        search_engine_default_search_mode = 1;
        external_editor = "emacsclient -c";
        use_console_editor = "yes";

        # colours
        colors_enabled = "yes";
        volume_color = "default";
        progressbar_color = "black";
        progressbar_elapsed_color = "white";
        statusbar_color = "white";
      };
    };
}
