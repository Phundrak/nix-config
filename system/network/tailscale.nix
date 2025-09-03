{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.mySystem.network.tailscale;
in {
  options.mySystem.network.tailscale = {
    enable = mkOption {
      type = types.bool;
      default = true;
    };
  };
  config.services.tailscale.enable = cfg.enable;
}
