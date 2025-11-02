{pkgs, ...}:
pkgs.writeShellScriptBin "focus-urgent" ''
  pidof -x Hyprland && hyprctl dispatch focusurgentorlast
''
