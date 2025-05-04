{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.git;
in {
  options.modules.git = {
    enable = mkEnableOption "enables git";
    email = mkOption {
      type = types.str;
      default = "lucien@phundrak.com";
    };
    name = mkOption {
      type = types.str;
      default = "Lucien Cartier-Tilet";
    };
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
    emacs = {
      integration = mkEnableOption "enables Emacs integration";
      pkg = mkOption {
        type = types.package;
        default = pkgs.emacs;
      };
    };
    mergeTool = mkOption {
      type = types.str;
      default = "ediff";
    };
    editor = mkOption {
      type = types.str;
      default = "${pkgs.emacs}/bin/emacsclient -c -a ${pkgs.emacs}/bin/emacs";
    };
    publicKeyFile = mkOption {
      type = types.nullOr types.str;
      default = null;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.git = let
      smtpEmail =
        if (cfg.sendmail.user == null)
        then cfg.email
        else cfg.sendmail.user;
    in {
      enable = true;
      userEmail = cfg.email;
      userName = cfg.name;
      extraConfig = {
        color.ui = "auto";
        column.ui = "auto";
        tag.sort = "version:refname";
        core = mkIf cfg.completeConfig {
          compression = 9;
          inherit (cfg) editor;
          whitespace = "fix,-indent-with-non-tab,trailing-space";
          preloadindex = true;
        };
        status = {
          branch = true;
          showStash = true;
        };
        diff = {
          algorithm = "histogram";
          colorMoved = "plain";
          mnemonicPrefix = true;
          renames = "copy";
          interHunkContext = 10;
        };
        commit.gpgsign = cfg.publicKeyFile != null;
        gpg.format = "ssh";
        gpg.ssh.allowedSignersFile = (mkIf (cfg.publicKeyFile != null)) "~/.ssh/allowed_signers";
        init.defaultBranch = "main";
        pull.rebase = true;
        push = {
          default = "simple";
          autoSetupRemote = true;
          followTags = true;
        };
        rebase = {
          autoSquash = true;
          autoStash = true;
          missingCommitsCheck = "warn";
          updateRefs = true;
        };
        help.autocorrect = "prompt";
        user.signingkey = mkIf (cfg.publicKeyFile != null) cfg.publicKeyFile;
        web.browser = mkIf (cfg.browser != null) cfg.browser;
        sendemail = mkIf cfg.sendmail.enable {
          smtpserver = cfg.sendmail.server;
          smtpuser = smtpEmail;
          smtpencryption = cfg.sendmail.encryption;
          smtpserverport = cfg.sendmail.port;
        };
        credentials = mkIf (cfg.sendmail.passwordFile != null) {
          "smtp://${smtpEmail}@${cfg.sendmail.server}:${toString cfg.sendmail.port}" = {
            helper = "cat ${cfg.sendmail.passwordFile}";
          };
        };
        magithub = mkIf cfg.emacs.integration {
          online = true;
          "status" = {
            includeStatusHeader = true;
            includePullRequestsSection = true;
            includeIssuesSection = true;
          };
        };
        merge = {
          tool = mkIf cfg.completeConfig cfg.mergeTool;
          conflictstyle = "zdiff3";
        };
        mergetool.ediff.cmd = mkIf (cfg.emacs.integration && cfg.completeConfig) "\"${cfg.emacs.pkg} --eval \" (progn (defun ediff-write-merge-buffer () (let ((file ediff-merge-store-file)) (set-buffer ediff-buffer-C) (write-region (point-min) (point-max) file) (message \\\"Merge buffer saved in: %s\\\" file) (set-buffer-modified-p nil) (sit-for 1))) (setq ediff-quit-hook 'kill-emacs ediff-quit-merge-hook 'ediff-write-merge-buffer) (ediff-merge-files-with-ancestor \\\"$LOCAL\\\" \\\"$REMOTE\\\" \\\"$BASE\\\" nil \\\"$MERGED\\\"))\"\"";
        github.user = "phundrak";
        url = {
          "https://phundrak@github.com" = {
            insteadOf = "https://github.com";
          };
          "https://phundrak@labs.phundrak.com" = {
            insteadOf = "https://labs.phundrak.com";
          };
          "https://github.com/RustSec/advisory-db" = {
            insteadOf = "https://github.com/RustSec/advisory-db";
          };
          "git@github.com:Phundrak/" = {
            insteadOf = "pg:";
          };
          "git@labs.phundrak.com/phundrak:" = {
            insteadOf = "p:";
          };
          "git@github.com" = {
            insteadOf = "gh:";
          };
          "git@labs.phundrak.com" = {
            insteadOf = "labs:";
          };
        };
      };
      ignores = [
        ".env"
        ".direnv/"

        "*~"
        "\#*\#"
        "*.elc"
        "auto-save-list"
        ".\#*"
        "*_flymake.*"
        "/auto/"
        ".projectile"
        ".dir-locals.el"

        "# Org mode files"
        ".org-id-locations"
        "*_archive"

        "*.out"
        "*.o"
        "*.so"

        "# Archives"
        "*.7zz"
        "*.dmg"
        "*.gz"
        "*.iso"
        "*.jar"
        "*.rar"
        "*.tar"
        "*.zip"

        "*.log"
        "*.sqlite"

        "dist/"
      ];
      aliases = {
        a = "add --all";
        aca = "!git add --all && git commit --amend";
        acan = "!git add --all && git commit --amend --no-edit";
        ap = "add --patch";
        b = "branch";
        bd = "branch -d";
        bdd = "branch -D";
        c = "commit -S";
        ca = "commit -Sa";
        can = "commit -Sa --no-edit";
        cm = "commit -Sm";
        cam = "commit -Sam";
        co = "checkout";
        cob = "checkout -b";
        cod = "checkout develop";
        cl = "clone";
        cl1 = "clone --depth 1";
        f = "fetch";
        fp = "fetch --prune";
        ps = "push";
        psf = "push --force-with-lease";
        pso = "push origin";
        psfo = "push --force-with-lease origin";
        pushall = "!git remote \vert{} xargs -L1 git push";
        psl = "!git remote \vert{} xargs -L1 git push";
        pullall = "!git remote \vert{} xargs -L1 git pull";
        pll = "!git remote \vert{} xargs -L1 git pull";
        pl = "pull";
        pb = "pull --rebase";
        r = "rebase";
        ra = "rebase --abort";
        rc = "rebase --continue";
        rd = "rebase develop";
        ri = "rebase -i";
        rmf = "rm -f";
        rmd = "rm -r";
        rmdf = "rm -rf";
        sm = "submodule";
        sms = "submodule status";
        sma = "submodule add";
        smu = "submodule update";
        smui = "submodule update --init";
        smuir = "submodule update --init --recursive";
        st = "stash";
        stc = "stash clear";
        stp = "stash pop";
        stw = "stash show";
        u = "reset --";
        d = "diff -w";
        l = "log --all --oneline --graph --decorate --pretty=format':%C(magenta)%h %C(white) %an %ar%C(auto) %D%n%s%n'";
        s = "status";
        staged = "diff --cached";
        upstream = "!git push -u origin HEAD";
        unstage = "reset --";
      };
    };
  };
}
