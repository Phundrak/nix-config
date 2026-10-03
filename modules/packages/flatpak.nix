{
  flake.modules.nixos.flatpak = {
    pkgs,
    lib,
    config,
    ...
  }:
    with lib; let
      cfg = config.mySystem.packages.flatpak;
    in {
      config.services.flatpak.enable = true;
      options.mySystem.packages.flatpak.builder.enable = mkEnableOption "Enable Flatpak builder";
      config.environment.systemPackages = lists.optional cfg.builder.enable pkgs.flatpak-builder;
    };
}
