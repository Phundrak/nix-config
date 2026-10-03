{
  flake.modules.homeManager.game-packages = {
    pkgs,
    lib,
    config,
    ...
  }:
    with lib; let
      cfg = config.home.games.game-packages;
    in {
      options.home.games.game-packages.enable = mkEnableOption "Install game launchers and clients";
      config.home.packages = mkIf cfg.enable (with pkgs; [
        atlauncher
        heroic
        openmw
        openttd-jgrpp
        moonlight-qt
        vintagestory
      ]);
    };
}
