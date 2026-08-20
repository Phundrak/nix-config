{
  pkgs,
  config,
  ...
}:
pkgs.writeShellScriptBin "launch-with-emacsclient" ''
  filename="$1"
  line="$2"
  column="$3"
  ${config.home.dev.editors.emacs.package}/bin/emacsclient +$line:$column "$filename"''
