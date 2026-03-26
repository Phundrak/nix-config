{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.home.myServices;
in {
  imports = [
    ./blanket.nix
    ./mbsync.nix
    ./mpris-proxy.nix
    ./playerctld.nix
  ];
  options.home.myServices.fullDesktop = mkOption {
    description = "Enable all modules";
    type = types.bool;
    default = config.home.fullDesktop;
  };
  config.home.myServices = {
    blanket.enable = mkDefault cfg.fullDesktop;
    mbsync.enable = mkDefault cfg.fullDesktop;
    mpris-proxy.enable = mkDefault cfg.fullDesktop;
    playerctld.enable = mkDefault cfg.fullDesktop;
  };
}
