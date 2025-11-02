{pkgs, ...}:
pkgs.writeShellScriptBin "close-window" ''
  pidof -x Hyprland && hyprctl dispatch killactive
''
