{config, ...}: let
  m = config.flake.modules.homeManager;
in {
  flake.modules.homeManager.games = {
    config,
    lib,
    ...
  }:
    with lib; let
      cfg = config.home.games;
    in {
      imports = [
        m.mangohud
        m.game-packages
      ];

      options.home.games.fullDesktop = mkEnableOption "Enable all optional game-related modules";
      config.home.games = {
        mangohud.enable = mkDefault cfg.fullDesktop;
        game-packages.enable = mkDefault cfg.fullDesktop;
      };
    };
}
