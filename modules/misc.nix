{
  flake.modules.nixos.misc = {
    lib,
    config,
    ...
  }:
    with lib; let
      cfg = config.mySystem.misc;
    in {
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
        console.keyMap = cfg.keymap;
        time.timeZone = cfg.timezone;
        environment.pathsToLink = [
          "/share/bash-completion"
          "/share/zsh"
        ];
        services = {
          orca.enable = false;
          envfs.enable = true;
        };
      };
    };
}
