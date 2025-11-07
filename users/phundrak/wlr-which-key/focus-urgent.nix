{pkgs, ...}:
pkgs.writeShellScriptBin "focus-urgent" ''
  ${pkgs.procps}/bin/pidof -x Hyprland && ${pkgs.hyprland}/bin/hyprctl dispatch focusurgentorlast
''
