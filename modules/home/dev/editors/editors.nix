{config, ...}: let
  m = config.flake.modules.homeManager;
in {
  flake.modules.homeManager.editors = {
    config,
    lib,
    ...
  }:
    with lib; let
      cfg = config.home.dev.editors;
    in {
      imports = [
        m.emacs
      ];

      options.home.dev.editors.fullDesktop = mkEnableOption "Enable all editors";
      config.home.dev.editors.emacs = {
        enable = mkDefault cfg.fullDesktop;
        service = mkDefault cfg.fullDesktop;
        mu4eMime = mkDefault cfg.fullDesktop;
        org-protocol = mkDefault cfg.fullDesktop;
      };
    };
}
