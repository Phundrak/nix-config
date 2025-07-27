{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.home.services;
in {
  imports = [
    ./blanket.nix
    ./mbsync.nix
    ./mpris-proxy.nix
    ./playerctld.nix
  ];
  options.home.services.fullDesktop = mkEnableOption "Enable all modules";
  config.home.services = {
    blanket.enable = mkDefault cfg.fullDesktop;
    mbsync.enable = mkDefault cfg.fullDesktop;
    mpris-proxy.enable = mkDefault cfg.fullDesktop;
    playerctld.enable = mkDefault cfg.fullDesktop;
  };
}
