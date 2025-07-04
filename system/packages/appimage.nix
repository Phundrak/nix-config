{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.system.packages.appimage;
in {
  options.system.packages.appimage.enable = mkEnableOption "Enables AppImage support";
  config.programs.appimage = mkIf cfg.enable {
    inherit (cfg) enable;
    binfmt = true;
  };
}
