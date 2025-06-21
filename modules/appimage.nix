{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.appimage;
in {
  options.modules.appimage.enable = mkEnableOption "Enables AppImage support";
  config.programs.appimage = mkIf cfg.enable {
    inherit (cfg) enable;
    binfmt = true;
  };
}
