{pkgs, ...}:
pkgs.writeShellScriptBin "hyprland-autostart" ''
  ${pkgs.waybar}/bin/waybar &
  ${pkgs.wlsunset}/bin/wlsunset -l 48.5 -L 2.2 -d 1500''
