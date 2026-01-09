{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
with lib; let
  cfg = config.home.desktop.spotify;
  system = pkgs.stdenv.hostPlatform.system;
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
