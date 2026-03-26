{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.home.myServices.mpris-proxy;
in {
  options.home.myServices.mpris-proxy.enable = mkEnableOption "Enable MPRIS forwarding towards bluetooth and MIDI";
  config.services.mpris-proxy.enable = cfg.enable;
}
