{pkgs, ...}:
pkgs.writeShellScriptBin "screenshot" ''
  OUTFILE_BASE="$HOME/Pictures/Screenshots/Screenshot_$(date +%Y-%m-%d_%H.%M.%S)"
  OUTFILE="$OUTFILE_BASE.png"
  SUFFIX=0

  while getopts ':cd:egs' OPTION; do
      case "$OPTION" in
          c )
              COPY="yes"
              ;;
          d )
              DELAY="$OPTARG"
              ;;
          e )
              EDIT="yes"
              ;;
          g )
              GIMP="yes"
              ;;
          s )
              SELECT="yes"
              ;;
          ? )
              echo "Usage: $(basename "$0") [-c] [-d DELAY] [-e] [-g] [-s]"
              exit 1
              ;;
      esac
  done

  if [ "$SELECT" = "yes" ]; then
    AREA="$(${pkgs.slurp}/bin/slurp)"
  fi

  if [ -n "$DELAY" ]; then
    sleep "$DELAY"
  fi

  if [ "$SELECT" = "yes" ]; then
    ${pkgs.grim}/bin/grim -g "$AREA" "$OUTFILE"
  else
    ${pkgs.grim}/bin/grim "$OUTFILE"
  fi

  if [ "$EDIT" = "yes" ];then
    ${pkgs.swappy}/bin/swappy -f "$OUTFILE" -o "$OUTFILE"
  fi

  if [ "$GIMP" = "yes" ]; then
    ${pkgs.gimp}/bin/gimp "$OUTFILE"
  fi

  if [ "$COPY" = "yes" ]; then
    ${pkgs.wl-clipboard-rs}/bin/wl-copy < "$OUTFILE"
  fi
''
