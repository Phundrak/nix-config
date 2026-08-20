{pkgs, ...}:
pkgs.writeShellScriptBin "float" ''
  ${pkgs.procps}/bin/pidof -x Hyprland && ${pkgs.hyprland}/bin/hyprctl dispatch togglefloating
''
