{config, ...}: let
  m = config.flake.modules.homeManager;
in {
  flake.modules.homeManager.dev = {
    config,
    lib,
    ...
  }:
    with lib; let
      cfg = config.home.dev;
    in {
      imports = [
        m.ai
        m.editors
        m.vcs
      ];

      options.home.dev.fullDesktop = mkEnableOption "Enables everything except AI";
      config.home.dev = {
        vcs.fullDesktop = mkDefault cfg.fullDesktop;
        editors.fullDesktop = mkDefault cfg.fullDesktop;
      };
    };
}
