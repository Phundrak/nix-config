{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.home.cli.bat;
in {
  options.home.cli.bat.extras = mkEnableOption "Enables extra packages for bat.";
  config.programs.bat = {
    enable = true;
    config = {
      theme = "Nord";
      map-syntax = [
        ".spacemacs*:Lisp"
      ];
    };
    extraPackages = mkIf cfg.extras (with pkgs.bat-extras; [
      batman
      batpipe
    ]);
  };
}
