{pkgs, ...}:
pkgs.writeShellScriptBin "fullscreen" ''
  ${pkgs.procps}/bin/pidof -x Hyprland && ${pkgs.hyprland}/bin/hyprctl dispatch fullscreen
''
