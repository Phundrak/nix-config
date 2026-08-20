{inputs, ...}: {
  flake-file.inputs.spicetify = {
    url = "github:Gerg-L/spicetify-nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.modules.homeManager.spotify = {
    pkgs,
    config,
    lib,
    ...
  }:
    with lib; let
      inherit (pkgs.stdenv.hostPlatform) system;
      cfg = config.home.desktop.spotify;
      spicePkgs = inputs.spicetify.legacyPackages.${system};
    in {
      imports = [inputs.spicetify.homeManagerModules.default];

      options.home.desktop.spotify = {
        enable = mkEnableOption "Enable Spotify";
        spicetify.enable = mkEnableOption "Enable Spicetify";
      };
      config.programs = mkIf cfg.enable {
        spotify-player.enable = cfg.enable;
        spicetify = mkIf cfg.spicetify.enable {
          inherit (cfg.spicetify) enable;
          theme = spicePkgs.themes.sleek;
          colorScheme = "Nord";
        };
      };
    };
}
