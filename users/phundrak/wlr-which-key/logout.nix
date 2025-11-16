{pkgs, ...}:
pkgs.writeShellScriptBin "logout" ''
  ${pkgs.procps}/bin/pidof -x Hyprland && uwsm stop
''
