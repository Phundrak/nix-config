{pkgs, ...}:
pkgs.writeShellScriptBin "askpass" ''
  ${pkgs.wofi}/bin/wofi -d -P -L 1 -p "$(printf $1 | sed s/://)"''
