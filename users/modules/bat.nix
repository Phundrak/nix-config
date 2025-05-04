{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.bat;
in {
  options.modules.bat.extras = mkEnableOption "Enables extra packages for bat.";
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
      batgrep
    ]);
  };
}
