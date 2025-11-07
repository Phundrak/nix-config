{pkgs, ...}:
pkgs.writeShellScriptBin "center-window" ''
  ${pkgs.procps}/bin/pidof -x Hyprland && ${pkgs.hyprland}/bin/hyprctl dispatch centerwindow
''
