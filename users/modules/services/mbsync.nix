{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.home.services.mbsync;
in {
  options.home.services.mbsync = {
    enable = mkEnableOption "Enables mbsync";
    service.enable = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = mkIf cfg.enable {
    systemd.user.services.mbsync.unitConfig.After = ["sops-nix.service"];
    services.mbsync.enable = cfg.service.enable;
    programs.mbsync.enable = true;
  };
}
