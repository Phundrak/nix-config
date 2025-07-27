{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.home.dev.vcs.jj;
in {
  options.home.dev.vcs.jj = {
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
      default =
        if config.home.dev.editors.emacs.enable
        then "${pkgs.emacs}/bin/emacsclient -c -a ${pkgs.emacs}/bin/emacs"
        else "${pkgs.nano}/bin/nano";
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
        show-cryptographic-signatures = true;
        inherit (cfg) editor;
      };
      signing = mkIf cfg.signing.enable {
        behavior = "own";
        backend = "ssh";
        key = cfg.signing.sshKey;
        backends."ssh.allowed-signers" = "~/.ssh/allowed_signers";
        backends."ssh.program" = "${pkgs.openssh}/bin/ssh-keygen";
      };
      aliases = {
        l = ["log"];
        lc = ["log" "-r" "(remote_bookmarks()..@)::"];
        n = ["new"];
        dm = ["desc" "-m"];
        tug = ["bookmark" "move" "--from" "heads(::@- & bookmarks())" "--to" "@-"];
      };
    };
  };
}
