{config, ...}: let
  m = config.flake.modules.homeManager;
in {
  flake.modules.homeManager.home-base = {
    config,
    lib,
    ...
  }:
    with lib; let
      cfg = config.home;
    in {
      imports = [
        m.basics
        m.cli
        m.desktop
        m.dev
        m.media
        m.my-services
        m.security
        m.shell
      ];

      options.home = {
        fullDesktop = mkEnableOption "Enable most modules";
        gpuType = mkOption {
          type = types.nullOr (types.enum ["nvidia" "amd" "intel"]);
          default = null;
          example = "amd";
        };
      };
      config.home = {
        cli.fullDesktop = mkDefault cfg.fullDesktop;
        desktop.fullDesktop = mkDefault cfg.fullDesktop;
        dev.fullDesktop = mkDefault cfg.fullDesktop;
        media.fullDesktop = mkDefault cfg.fullDesktop;
        security.fullDesktop = mkDefault cfg.fullDesktop;
        myServices.fullDesktop = mkDefault cfg.fullDesktop;
      };
    };
}
