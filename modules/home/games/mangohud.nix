{
  flake.modules.homeManager.mangohud = {
    lib,
    config,
    ...
  }:
    with lib; let
      cfg = config.home.games.mangohud;
    in {
      options.home.games.mangohud.enable = mkEnableOption "Enable MangoHud performance overlay";
      config.programs.mangohud = mkIf cfg.enable {
        enable = true;
        enableSessionWide = true;
      };
    };
}
