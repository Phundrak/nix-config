{config, ...}: let
  m = config.flake.modules.homeManager;
in {
  flake.modules.homeManager.cli = {
    config,
    lib,
    ...
  }:
    with lib; let
      cfg = config.home.cli;
    in {
      imports = [
        m.bat
        m.btop
        m.direnv
        m.eza
        m.mu
        m.nh
        m.nix-index
        m.scripts
        m.tealdeer
        m.yt-dlp
      ];

      options.home.cli.fullDesktop = mkEnableOption "Enable all optional modules and options";
      config.home.cli = {
        bat.extras = mkDefault cfg.fullDesktop;
        mu.enable = mkDefault cfg.fullDesktop;
        scripts.enable = mkDefault cfg.fullDesktop;
        yt-dlp.enable = mkDefault cfg.fullDesktop;
      };
    };
}
