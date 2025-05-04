{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.jj;
in {
  options.modules.jj = {
    enable = mkEnableOption "enables jj";
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
    signing = {
      enable = mkEnableOption "enables signing jj commits";
      sshKey = mkOption {
        type = with types; nullOr (either path str);
        example = "~/.ssh/id_ed25519.pub";
        default = "~/.ssh/id_ed25519.pub";
        description = "Path to the public SSH key or its content.";
      };
    };
  };

  config.programs.jujutsu = mkIf cfg.enable {
    enable = true;
    settings = {
      user = {
        inherit (cfg) name email;
      };
      ui = {
        default-command = "st";
        pager = ":builtin";
        inherit (cfg) editor;
      };
      signing = mkIf cfg.signing.enable {
        behavior = "own";
        backend = "ssh";
        key = cfg.signing.sshKey;
        backends."ssh.allowed-signers" = "~/.ssh/allowed_signers";
        backends."ssh.program" = "${pkgs.openssh}/bin/ssh-keygen";
      };
    };
  };
}
