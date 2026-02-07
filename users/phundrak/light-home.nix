{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.home.phundrak;
in {
  imports = [../modules];

  options.home.phundrak = {
    sshKey = {
      content = mkOption {
        type = types.nullOr types.str;
        example = "ssh-ed25519 AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
        default = null;
      };
      file = mkOption {
        type = with types; nullOr path;
        default = "/home/phundrak/.ssh/id_ed25519.pub";
      };
    };
  };

  config = {
    nixpkgs.config.allowUnfree = true;

    sops = {
      defaultSopsFile = ../../secrets/secrets.yaml;
      defaultSopsFormat = "yaml";
      secrets."ssh/hosts" = {};
      age = {
        # automatically import user SSH keys as age keys
        sshKeyPaths = [
          "${config.home.homeDirectory}/.ssh/id_ed25519"
        ];
        # this will use an age key that is expected to already be in the filesystem
        keyFile = "${config.home.homeDirectory}/.local/sops-nix/key.txt";
        # generate a new key if the key specified above does not exist
        generateKey = true;
      };
    };

    home = {
      username = "phundrak";
      homeDirectory = "/home/phundrak";
      packages = [pkgs.tree pkgs.ncdu];
      preferXdgDirectories = true;

      phundrak.sshKey.file = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";

      dev.vcs = {
        jj.enable = true;
        git.enable = true;
        publicKey = cfg.sshKey;
      };

      security.ssh = {
        enable = true;
        hosts = config.sops.secrets."ssh/hosts".path;
      };

      shell = {
        bash.enable = true;
        zsh.enable = true;
        starship = {
          enable = true;
          jjIntegration = true;
        };
        tmux.enable = true;
        zoxide = {
          enable = true;
          replaceCd = true;
        };
      };

      stateVersion = "24.11"; # Do not modify!
    };

    manual.manpages.enable = true;
  };
}
