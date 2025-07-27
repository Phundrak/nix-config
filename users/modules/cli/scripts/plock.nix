{pkgs, ...}:
pkgs.writeShellScriptBin "plock" ''
  TMPBG="/tmp/screen.png"
  if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
      SCREENER=${pkgs.grim}/bin/grim
      LOCKER="${pkgs.swaylock}/bin/swaylock -feF"
  else
      SCREENER=${pkgs.scrot}/bin/scrot
      LOCKER="${pkgs.i3lock}/bin/i3lock -ef"
  fi

  $SCREENER "$TMPBG"
  ${pkgs.corrupter}/bin/corrupter -add 0 "$TMPBG" "$TMPBG"
  $LOCKER -ti "$TMPBG"
  rm "$TMPBG"
''
