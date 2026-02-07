{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mySystem.users.creug;
in {
  options.mySystem.users.creug = {
    enable = mkEnableOption "Enables user creug";
    sudo = mkEnableOption "Make the user a superuser";
    trusted = mkOption {
      description = "Mark the user as trusted by Nix";
      default = cfg.sudo;
      example = true;
    };
  };

  config = {
    users.users.creug = mkIf cfg.enable {
      isNormalUser = true;
      description = "Greg";
      extraGroups =
        ["networkmanager" "dialout" "games" "audio" "input"]
        ++ lists.optional config.mySystem.dev.docker.enable "docker"
        ++ lists.optional config.mySystem.dev.docker.podman.enable "podman"
        ++ lists.optional cfg.sudo "wheel";
      shell = pkgs.zsh;
      openssh.authorizedKeys.keyFiles = lib.filesystem.listFilesRecursive ../../users/creug/keys;
    };
    nix.settings = mkIf cfg.trusted {
      trusted-users = ["creug"];
    };
  };
}
