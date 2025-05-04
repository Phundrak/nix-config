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
    programs.mbsync = {
      enable = true;
      extraConfig = ''
        IMAPAccount Main
        Host ${cfg.host}
        User ${cfg.user}
        PassCmd "cat ${cfg.passwordFile}"
        SSLType IMAPS
        SSLVersion TLSv1.2
        CertificateFile /etc/ssl/certs/ca-certificates.crt

        IMAPStore main-remote
        Account Main

        MaildirStore main-local
        Subfolders Verbatim
        Path ~/Mail/
        Inbox ~/Mail/Inbox

        Channel main
        Far :main-remote:
        Near :main-local:
        Create Both
        SyncState *
        Patterns *
      '';
    };
  };
}
