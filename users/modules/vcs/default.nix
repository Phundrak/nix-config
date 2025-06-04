{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.vcs;
in {
  imports = [./git.nix ./jujutsu.nix];

  options.modules.vcs = {
    git = {
      enable = mkEnableOption "enables git";
      cliff = mkEnableOption "enables git-cliff support";
      sendmail = {
        enable = mkOption {
          type = types.bool;
          default = true;
        };
        server = mkOption {
          type = types.nullOr types.str;
          default = "mail.phundrak.com";
        };
        user = mkOption {
          type = types.nullOr types.str;
          default = null;
        };
        encryption = mkOption {
          type = types.enum ["tls" "ssl" "none"];
          default = "none";
        };
        port = mkOption {
          type = types.nullOr types.int;
          default = 587;
        };
        passwordFile = mkOption {
          type = types.nullOr types.path;
          default = null;
          description = ''
            Path to a file containing the password necessary for authenticating
            against the mailserver.

            This file should contain the password only, with no newline.
          '';
        };
      };
      browser = mkOption {
        type = types.nullOr types.str;
        example = "${pkgs.firefox}/bin/firefox";
        default = null;
      };
      completeConfig = mkEnableOption "Complete configuration for workstations";
      mergeTool = mkOption {
        type = types.str;
        default = "ediff";
      };
      emacs = {
        integration = mkEnableOption "enables Emacs integration";
        pkg = mkOption {
          type = types.package;
          default = pkgs.emacs;
        };
      };
    };
    jj.enable = mkEnableOption "enables jujutsu";
    name = mkOption {
      type = types.str;
      default = "Lucien Cartier-Tilet";
    };
    email = mkOption {
      type = types.str;
      default = "lucien@phundrak.com";
    };
    editor = mkOption {
      type = types.str;
      default = "${pkgs.emacs}/bin/emacsclient -c -a ${pkgs.emacs}/bin/emacs";
    };
    publicKey = {
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

  config = lib.mkIf (cfg.git.enable || cfg.jj.enable) {
    home.file.".ssh/allowed_signers".text = mkIf (cfg.publicKey.content != null) (mkDefault ''
      ${cfg.email} namespaces="git" ${cfg.publicKey.content}
    '');
    modules = {
      git = mkIf cfg.git.enable {
        inherit (cfg.git) enable cliff sendmail browser completeConfig emacs mergeTool;
        inherit (cfg) email name editor;
        publicKeyFile = cfg.publicKey.file;
      };
      jj = mkIf cfg.jj.enable {
        inherit (cfg.jj) enable;
        inherit (cfg) name email editor;
        signing.enable = cfg.publicKey.content != null;
        signing.sshKey =
          if (cfg.publicKey.file == null)
          then cfg.publicKey.content
          else cfg.publicKey.file;
      };
    };
  };
}
