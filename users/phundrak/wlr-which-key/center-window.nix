{pkgs, ...}:
pkgs.writeShellScriptBin "center-window" ''
  pidof -x Hyprland && hyprctl dispatch centerwindow
''
