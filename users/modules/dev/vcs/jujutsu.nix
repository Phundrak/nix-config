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
        default = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
        description = "Path to the private SSH key for signing.";
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
        diff-editor = ":builtin";
        merge-editort = ":builtin";
        inherit (cfg) editor;
      };
      signing = mkIf cfg.signing.enable {
        behavior = "own";
        backend = "ssh";
        key = cfg.signing.sshKey;
        backends.ssh.allowed-signers = "${config.home.homeDirectory}/.ssh/allowed_signers";
        backends.ssh.program = "${pkgs.openssh}/bin/ssh-keygen";
      };
      aliases = {
        blame = ["file" "annotate"];
        consume = ["squash" "--into" "@" "--from"];
        eject = ["squash" "--from" "@" "--into"];
        d = ["diff"];
        dm = ["desc" "-m"];
        gc = ["git" "clone"];
        gcc = ["git" "clone" "--colocate"];
        l = ["log"];
        la = ["log" "-r" "::"];
        lc = ["log" "-r" "(remote_bookmarks()..@)::"];
        ll = ["log" "-T" "builtin_log_detailed"];
        open = ["log" "-r" "open()"];
        n = ["new"];
        nd = ["new" "dev()"];
        nt = ["new" "trunk()"];
        revlog = ["evolog"];
        s = ["show"];
        tug = ["bookmark" "move" "--from" "heads(::@- & bookmarks())" "--to" "@-"];
      };
      colors.working_copy.underline = true;
      git = {
        private-commits = "blacklist()";
        colocate = true;
        subprocess = true;
      };
      revset-aliases = {
        "immutable_heads()" = "present(trunk()) | tags()";
        # Resolves by default to latest main/master remote bookmarks
        "trunk()" = "latest((present(main) | present(master)) & remote_bookmarks())";
        # Same as trunk() but for `dev` or `develop` bookmarks
        "dev()" = "latest((present(dev) | present(develop)) & remote_bookmarks())";

        "user(x)" = "author(x) | committer(x)";
        "gh_pages()" = "ancestors(remote_bookmarks(exact:\"gh-pages\"))";

        #Private and WIP commits that should never be pushed
        "wip()" = "description(glob:\"wip:*\")";
        "private()" = "description(glob:\"private:*\")";
        "blacklist()" = "wip() | private()";

        # stack(x, n) is the set of mutable commits reachable from
        # 'x', with 'n' parents. 'n' is often useful to customize the
        # display and return set for certain operations. 'x' can be
        # used to target the set of 'roots' to traverse, e.g. @ is the
        # current stack.
        "stack()" = "ancestors(reachable(@, mutable()), 2)";
        "stack(x)" = "ancestors(reachable(x, mutable()), 2)";
        "stack(x, n)" = "ancestors(reachable(x, mutable()), n)";

        "open()" = "stack(dev().. & mine(), 1)";
        "ready()" = "open() ~ blacklist()::";
      };
      remotes.origin.auto-track-bookmarks = "*";
    };
  };
}
