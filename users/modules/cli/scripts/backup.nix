{pkgs, ...}:
pkgs.writeShellScriptBin "backup" ''
  cp -r "$1" "$1.bak.$(date +%Y%m%d%H%M%S)"''
