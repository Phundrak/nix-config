{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.mySystem.packages.appimage;
in {
  options.mySystem.packages.appimage.enable = mkEnableOption "Enables AppImage support";
  config.programs.appimage = mkIf cfg.enable {
    inherit (cfg) enable;
    binfmt = true;
  };
}
