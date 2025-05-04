{
  pkgs,
  emacsPackage,
  ...
}:
pkgs.writeShellScriptBin "launch-with-emacsclient" ''
  filename="$1"
  line="$2"
  column="$3"
  ${emacsPackage}/bin/emacsclient +$line:$column "$filename"''
