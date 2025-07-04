{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.system.packages.flatpak;
in {
  options.system.packages.flatpak = {
    enable = mkEnableOption "Enable Flatpak support";
    builder.enable = mkEnableOption "Enable Flatpak builder";
  };
  config = {
    services.flatpak = mkIf cfg.enable {
      inherit (cfg) enable;
    };
    environment.systemPackages = mkIf cfg.builder.enable [
      pkgs.flatpak-buildR
    ];
  };
}
