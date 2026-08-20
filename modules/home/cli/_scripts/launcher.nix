{pkgs, ...}:
pkgs.writeShellScriptBin "app-launcher" ''
  LOG_FILE="$HOME/.local/share/app-launcher.log"

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
      logger info "Using Caelestia app launcher"
       caelestia shell drawers toggle launcher || \
          logger error "failed to launch Caelestia app launcher"
      exit 0
  fi
  rofi -show drun
''
