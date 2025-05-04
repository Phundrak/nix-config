{pkgs, ...}: {
  programs.mpv = {
    enable = true;
    config = {
      force-window = "immediate";
      ytdl-format = "bestvideo[height<=1080]+bestaudio";
      force-seekable = true; # force streams to be seekable
      cache-default = 4000000;
      slang = "jpn,jp,eng,en,fra,fr";
      alang = "eng,en,fra,fr";
      gpu-api = "vulkan";
      osc = true;
      profile = "gpu-hq";
      geometry = "50%x50%";
      autofit-larger = "90%x90%";

      # Screenshots
      screenshot-format = "png";
      screenshot-high-bit-depth = true;
      screenshot-png-compression = 6;
      screenshot-directory = "~/Pictures/Screenshots/mpv";

      deband = true;
      deband-iterations = 2;
      deband-threshold = 35;
      deband-range = 20;
      deband-grand = 5;

      dither-depth = "auto";

      sub-auto = "fuzzy";

      scale = "ewa_lanczossharp";
      dscale = "mitchel";
      cscale = "ewa_lanczossharp";
    };
    scripts = with pkgs.mpvScripts; [
      crop
      encode
      inhibit-gnome
      mpris
      mpv-cheatsheet
      quality-menu
      sponsorblock
      thumbfast
      # twitch-chat
      youtube-chat
      youtube-upnext
    ];
    bindings = {
      Q = "quit-watch-later";
      P = "show-progress";
      "/" = "add volume -2";
      "*" = "add volume 2";
      m = "cycle mute";
      M = "vf toggle hflip";
      "Ctrl+r" = "cycle_values video-rotate \"90\" \"180\" \"270\" \"0\"";
    };
  };
}
