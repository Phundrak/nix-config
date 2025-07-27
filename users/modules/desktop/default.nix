{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.home.desktop;
in {
  imports = [
    ./emoji.nix
    ./eww.nix
    ./hyprland.nix
    ./kdeconnect.nix
    ./kitty.nix
    ./obs.nix
    ./qt.nix
    ./swaync.nix
    ./waybar.nix
    ./wlsunset.nix
    ./wofi.nix
  ];

  options.home.desktop.fullDesktop = mkEnableOption "Enable options for graphical environments";
  config.home.desktop = {
    eww.enable = mkDefault cfg.fullDesktop;
    hyprland.enable = mkDefault cfg.fullDesktop;
    kdeconnect.enable = mkDefault cfg.fullDesktop;
    kitty.enable = mkDefault cfg.fullDesktop;
    obs.enable = mkDefault cfg.fullDesktop;
    qt.enable = mkDefault cfg.fullDesktop;
  };
}
