{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.home.security.gpg;
in {
  options.home.security.gpg = {
    enable = mkEnableOption "Enable GPG";
    pinentry.package = mkOption {
      type = types.package;
      default = pkgs.pinentry-gnome3;
    };
  };
  config = mkIf cfg.enable {
    programs.gpg = {
      inherit (cfg) enable;
      mutableKeys = true;
      mutableTrust = true;
    };
    services.gpg-agent = {
      enable = true;
      enableSshSupport = false;
      pinentry.package = cfg.pinentry.package;
    };
  };
}
