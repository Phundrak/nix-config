{
  flake.modules.nixos.misc = {
    lib,
    config,
    ...
  }:
    with lib; let
      cfg = config.mySystem.misc;
    in {
      options.mySystem.misc.timezone = mkOption {
        type = types.str;
        default = "Europe/Paris";
      };
      options.mySystem.misc.keymap = mkOption {
        type = types.str;
        default = "fr";
        example = "fr-bepo";
        description = "Keymap to use in the TTY console";
      };

      config = {
        console.keyMap = cfg.keymap;
        time.timeZone = cfg.timezone;
        services.envfs.enable = true;
        services.orca.enable = false;
        boot.tmp.cleanOnBoot = true;
        environment.pathsToLink = [
          "/share/bash-completion"
          "/share/zsh"
        ];
      };
    };
}
