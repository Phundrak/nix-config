{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.mySystem.packages.flatpak;
in {
  options.mySystem.packages.flatpak = {
    enable = mkEnableOption "Enable Flatpak support";
    builder.enable = mkEnableOption "Enable Flatpak builder";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = lists.optional cfg.builder.enable pkgs.flatpak-builder;
    services.flatpak.enable = true;
  };
}
