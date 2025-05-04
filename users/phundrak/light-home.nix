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
        example = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGj+J6N6SO+4P8dOZqfR1oiay2yxhhHnagH52avUqw5h";
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
          "/home/phundrak/.ssh/id_ed25519"
        ];
        # this will use an age key that is expected to already be in the filesystem
        # keyFile = "/home/phundrak/.config/sops/age/keys.txt";
        keyFile = "/home/phundrak/.local/sops-nix/key.txt";
        # generate a new key if the key specified above does not exist
        generateKey = true;
      };
    };

    home = {
      username = "phundrak";
      homeDirectory = "/home/phundrak";
      packages = [pkgs.tree pkgs.ncdu];
      stateVersion = "24.11"; # Please read the comment before changing.
    };

    modules = {
      shell.starship.enable = true;
      vcs = {
        git.enable = true;
        jj.enable = true;
        publicKey = cfg.sshKey;
      };
      ssh = {
        enable = true;
        hosts = config.sops.secrets."ssh/hosts".path;
      };
    };

    manual.manpages.enable = true;
  };
}
