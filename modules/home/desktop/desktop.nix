{config, ...}: let
  m = config.flake.modules.homeManager;
in {
  flake.modules.homeManager.desktop = {
    lib,
    config,
    ...
  }:
    with lib; let
      cfg = config.home.desktop;
    in {
      imports = [
        m.caelestia
        m.firefox
        m.hyprland
        m.hyprpaper
        m.kdeconnect
        m.kitty
        m.obs
        m.rofi
        m.spotify
        m.swaync
        m.theme
        m.waybar
        m.wl-kbptr
        m.wlr-which-key
        m.wlsunset
      ];

      options.home.desktop.fullDesktop = mkEnableOption "Enable options for graphical environments";
      config.home.desktop = {
        firefox.enable = mkDefault cfg.fullDesktop;
        hyprland.enable = mkDefault cfg.fullDesktop;
        kdeconnect.enable = mkDefault cfg.fullDesktop;
        kitty.enable = mkDefault cfg.fullDesktop;
        obs.enable = mkDefault cfg.fullDesktop;
        rofi.enable = mkDefault cfg.fullDesktop;
        spotify.enable = mkDefault cfg.fullDesktop;
        spotify.spicetify.enable = mkDefault cfg.fullDesktop;
        theme.enable = mkDefault cfg.fullDesktop;
        wlr-which-key.enable = mkDefault cfg.fullDesktop;
      };
    };
}
