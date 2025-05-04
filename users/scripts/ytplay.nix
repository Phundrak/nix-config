{pkgs, ...}: let
  rofi = pkgs.rofi-wayland;
in
  pkgs.writeShellScriptBin "ytplay" ''
    URL=$(${rofi}/bin/rofi -dmenu -i -p "Video URL")
    if [ -z "$URL" ]; then
        echo "You need to provide a URL"
        exit 1
    fi
    RESOLUTION_CHOICE=$(${pkgs.yt-dlp}/bin/yt-dlp --list-formats "$URL" | \
                            grep -E "webm.*[0-9]+x[0-9]" | \
                            awk '{print $3 " " $1}' | \
                            sort -gu | \
                            ${rofi}/bin/rofi -dmenu -i -p "Resolution")
    mapfile -t RESOLUTION <<< "$RESOLUTION_CHOICE"
    RESOLUTION_CODE=''${RESOLUTION[0]}
    ${pkgs.mpv}/bin/mpv --ytdl-format="''${RESOLUTION_CODE}+bestaudio/best" "$URL"
  ''
