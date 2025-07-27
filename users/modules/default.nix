{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.home;
in {
  imports = [
    ./basics.nix
    ./cli
    ./desktop
    ./dev
    ./media
    ./services
    ./security
    ./shell
  ];

  options.home.fullDesktop = mkEnableOption "Enable most modules";
  config.home = {
    cli.fullDesktop = mkDefault cfg.fullDesktop;
    desktop.fullDesktop = mkDefault cfg.fullDesktop;
    dev.fullDesktop = mkDefault cfg.fullDesktop;
    media.fullDesktop = mkDefault cfg.fullDesktop;
    security.fullDesktop = mkDefault cfg.fullDesktop;
    services.fullDesktop = mkDefault cfg.fullDesktop;
  };
}
