{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.home.creug;
in {
  imports = [../modules];
  options.home.creug = {
    sshKey = {
      content = mkOption {
        type = types.nullOr types.str;
        example = "ssh-ed25519 AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
        default = null;
      };
      file = mkOption {
        type = with types; nullOr path;
        default = "/home/creug/.ssh/id_ed25519.pub";
      };
    };
  };

  config = {
    nixpkgs.config.allowUnfree = true;

    home = {
      username = "creug";
      homeDirectory = "/home/creug";
      packages = [pkgs.tree pkgs.ncdu];
      preferXdgDirectories = true;

      creug.sshKey.file = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";

      dev.vcs = {
        jj.enable = false;
        git.enable = true;
        publicKey = cfg.sshKey;
      };

      security.ssh.enable = true;

      shell = {
        bash.enable = true;
        zsh.enable = true;
        starship.enable = true;
        tmux.enable = false;
        zoxide.enable = false;
      };

      stateVersion = "24.11"; # Do not modify!
    };

    manual.manpages.enable = true;
  };
}
