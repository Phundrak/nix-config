{pkgs, ...}:
pkgs.writeShellScriptBin "sshbind" ''
  ssh -L "$1:$3:$1" "$2" -N''
