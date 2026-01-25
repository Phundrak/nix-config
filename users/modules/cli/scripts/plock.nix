{pkgs, ...}:
pkgs.writeShellScriptBin "plock" ''
  LOG_FILE="$HOME/.local/share/plock.log"

  logger() {
      local level="$1"
      local message="$2"
      local timestamp
      timestamp=$(date +"%Y-%m-%d %H:%M:%S")
      printf "[%s] [%-7s] %s\n" "$timestamp" "''${level^^}" "$message" >> "$LOG_FILE"
  }

  CAELESTIA_ACTIVE=$(systemctl --user is-active caelestia.service)
  logger debug "Caelestia activity: $CAELESTIA_ACTIVE"
  if systemctl --user is-active caelestia.service | grep 'active' &> /dev/null ; then
      logger info "locking Caelestia session"
      caelestia shell lock lock || \
          logger error "failed to lock Caelestia session"
      exit 0
  fi

  TMPBG="/tmp/screen.png"
  if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
      logger info "wayland session detected"
      SCREENER=${pkgs.grim}/bin/grim
      LOCKER="${pkgs.swaylock}/bin/swaylock -feF"
  else
      logger info "x11 session detected"
      SCREENER=${pkgs.scrot}/bin/scrot
      LOCKER="${pkgs.i3lock}/bin/i3lock -ef"
  fi

  $SCREENER "$TMPBG"
  logger info "generating lock screen image"
  ${pkgs.corrupter}/bin/corrupter -add 0 "$TMPBG" "$TMPBG" || logger error "failed to generate lock screen image"
  logger info "locking screen"
  logger debug "locking screen with command `''${SCREENER}`"
  $LOCKER -ti "$TMPBG"
  rm "$TMPBG"
''
