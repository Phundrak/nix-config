{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.mbsync;
in {
  options.modules.mbsync = {
    enable = mkEnableOption "Enables mbsync";
    passwordFile = mkOption {
      type = types.str;
      example = "/var/email/password";
    };
    service.enable = mkOption {
      type = types.bool;
      default = true;
    };
    host = mkOption {
      type = types.str;
      default = "mail.phundrak.com";
    };
    user = mkOption {
      type = types.str;
      default = "lucien@phundrak.com";
    };
  };

  config = mkIf cfg.enable {
    systemd.user.services.mbsync.unitConfig.After = ["sops-nix.service"];
    services.mbsync.enable = cfg.service.enable;
    programs.mbsync.enable = true;
  };
}
