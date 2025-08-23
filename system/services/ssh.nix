{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.mySystem.services.ssh;
in {
  options.mySystem.services.ssh = {
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
    inherit (cfg) enable;
    settings = {
      AllowUsers = cfg.allowedUsers;
      PermitRootLogin = "no";
      PasswordAuthentication = cfg.passwordAuthentication;
    };
  };
}
