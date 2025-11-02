{pkgs, ...}:
pkgs.writeShellScriptBin "askpass" ''
  ${pkgs.rofi}/bin/rofi -dmenu -password -no-fixed-num-lines -p $(printf \"$*\" | sed 's/://')''
