{pkgs, ...}:
pkgs.writeShellScriptBin "keygen"
"tr -cd '[:alnum:]' < /dev/urandom | fold -w 64 | head -n 1 | tr -d '\n'"
