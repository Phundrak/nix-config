{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.home.myServices.mbsync;
in {
  options.home.myServices.mbsync = {
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
