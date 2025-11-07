{pkgs, ...}:
pkgs.writeShellScriptBin "close-window" ''
  ${pkgs.procps}/bin/pidof -x Hyprland && ${pkgs.hyprland}/bin/hyprctl dispatch killactive
''
