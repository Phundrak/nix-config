{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.mySystem.misc;
in {
  imports = [
    ./boot
    ./desktop
    ./dev
    ./hardware
    ./i18n
    ./network
    ./packages
    ./security
    ./services
    ./users
  ];

  options.mySystem.misc = {
    timezone = mkOption {
      type = types.str;
      default = "Europe/Paris";
    };
    keymap = mkOption {
      type = types.str;
      default = "fr";
      example = "fr-bepo";
      description = "Keymap to use in the TTY console";
    };
  };

  config = {
    boot.tmp.cleanOnBoot = true;
    time.timeZone = cfg.timezone;
    console.keyMap = cfg.keymap;
  };
}
