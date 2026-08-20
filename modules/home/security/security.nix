{config, ...}: let
  m = config.flake.modules.homeManager;
in {
  flake.modules.homeManager.security = {
    config,
    lib,
    ...
  }:
    with lib; let
      cfg = config.home.security;
    in {
      imports = [
        m.gpg
        m.ssh
      ];
      options.home.security.fullDesktop = mkEnableOption "Enable all modules";
      config.home.security = {
        gpg.enable = mkDefault cfg.fullDesktop;
        ssh.enable = mkDefault cfg.fullDesktop;
      };
    };
}
