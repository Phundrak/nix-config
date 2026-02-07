{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
with lib; let
  inherit (pkgs.stdenv.hostPlatform) system;
  cfg = config.home.desktop.spotify;
  spicePkgs = inputs.spicetify.legacyPackages.${system};
in {
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
}
