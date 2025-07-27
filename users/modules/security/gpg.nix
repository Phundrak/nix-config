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
      default =
        if config.home.dev.editors.emacs.enable
        then pkgs.pinentry-emacs
        else pkgs.pinentry-gtk2;
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
      enableSshSupport = true;
      pinentry.package = cfg.pinentry.package;
    };
  };
}
