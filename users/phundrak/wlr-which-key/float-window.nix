{pkgs, ...}:
pkgs.writeShellScriptBin "float" ''
  pidof -x Hyprland && hyprctl dispatch togglefloating
  echo test
''
