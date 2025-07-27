{pkgs, ...}:
pkgs.writeShellScriptBin "rofi-emoji" ''
  SELECTED_EMOJI=$(grep -v "#" ~/.config/emoji | ${pkgs.wofi}/bin/wofi --dmenu -p "Select emoji" -i | awk '{print $1}' | tr -d '\n')
  if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    printf "%s" "$SELECTED_EMOJI" | ${pkgs.wl-clipboard-rs}/bin/wl-copy
  else
    printf "%s" "$SELECTED_EMOJI" | ${pkgs.xclip}/bin/xclip -sel clip
  fi

  if [ "$XDG_SESSION_TYPE" = "wayland" ]
  then EMOJI=$(${pkgs.wl-clipboard-rs}/bin/wl-paste)
  else EMOJI=$(${pkgs.xclip}/bin/xclip -o)
  fi

  test -z "$EMOJI" && notify-send "No emoji copied" -u low && exit
  EMOJI="$EMOJI copied to clipboard"
  ${pkgs.libnotify}/bin/notify-send -u low "$EMOJI"
''
