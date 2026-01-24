{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.home.desktop;
in {
  imports = [
    ./caelestia.nix
    ./eww.nix
    ./hyprland.nix
    ./kdeconnect.nix
    ./kitty.nix
    ./obs.nix
    ./qt.nix
    ./rofi
    ./spotify.nix
    ./swaync.nix
    ./theme.nix
    ./waybar.nix
    ./wlr-which-key.nix
    ./wlsunset.nix
  ];

  options.home.desktop.fullDesktop = mkEnableOption "Enable options for graphical environments";
  config.home.desktop = {
    eww.enable = mkDefault cfg.fullDesktop;
    hyprland.enable = mkDefault cfg.fullDesktop;
    kdeconnect.enable = mkDefault cfg.fullDesktop;
    kitty.enable = mkDefault cfg.fullDesktop;
    obs.enable = mkDefault cfg.fullDesktop;
    qt.enable = mkDefault cfg.fullDesktop;
    rofi.enable = mkDefault cfg.fullDesktop;
    spotify.enable = mkDefault cfg.fullDesktop;
    spotify.spicetify.enable = mkDefault cfg.fullDesktop;
    wlr-which-key.enable = mkDefault cfg.fullDesktop;
  };
}
