{pkgs, ...}:
pkgs.writeShellScriptBin "fullscreen" ''
  pidof -x Hyprland && hyprctl dispatch fullscreen
''
