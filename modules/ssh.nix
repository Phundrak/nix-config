{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.ssh;
in {
  options.modules.ssh = {
    enable = mkEnableOption "Enables OpenSSH";
    allowedUsers = mkOption {
      type = types.listOf types.str;
      example = ["alice" "bob"];
      default = ["phundrak"];
    };
    passwordAuthentication = mkOption {
      type = types.bool;
      example = true;
      default = false;
    };
  };
  config.services.openssh = mkIf cfg.enable {
    enable = true;
    settings = {
      AllowUsers = cfg.allowedUsers;
      PermitRootLogin = "no";
      PasswordAuthentication = cfg.passwordAuthentication;
    };
  };
}
