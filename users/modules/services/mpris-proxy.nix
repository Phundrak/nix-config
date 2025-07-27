{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.home.services.mpris-proxy;
in {
  options.home.services.mpris-proxy.enable = mkEnableOption "Enable MPRIS forwarding towards bluetooth and MIDI";
  config.services.mpris-proxy.enable = cfg.enable;
}
