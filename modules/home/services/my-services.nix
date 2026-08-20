{config, ...}: let
  m = config.flake.modules.homeManager;
in {
  flake.modules.homeManager.my-services = {
    config,
    lib,
    ...
  }:
    with lib; let
      cfg = config.home.myServices;
    in {
      imports = [
        m.blanket
        m.mbsync
        m.mpris-proxy
        m.playerctld
      ];
      options.home.myServices.fullDesktop = mkOption {
        description = "Enable all modules";
        type = types.bool;
        default = config.home.fullDesktop;
      };
      config.home.myServices = {
        blanket.enable = mkDefault cfg.fullDesktop;
        mbsync.enable = mkDefault cfg.fullDesktop;
        mpris-proxy.enable = mkDefault cfg.fullDesktop;
        playerctld.enable = mkDefault cfg.fullDesktop;
      };
    };
}
