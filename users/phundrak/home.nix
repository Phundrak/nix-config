{
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [
    ./light-home.nix
    ./packages.nix
    ./email.nix
    ./wlr-which-key
    ../modules
  ];

  config = let
    emacsPackage = with pkgs; ((emacsPackagesFor emacs).emacsWithPackages (
      epkgs:
        with epkgs; [
          mu4e
          pdf-tools
          tree-sitter
          tree-sitter-langs
          (treesit-grammars.with-grammars (grammar:
            with grammar; [
              tree-sitter-bash
              tree-sitter-c
              tree-sitter-cpp
              tree-sitter-css
              tree-sitter-dockerfile
              tree-sitter-http
              tree-sitter-javascript
              tree-sitter-jsdoc
              tree-sitter-json
              tree-sitter-just
              tree-sitter-markdown
              tree-sitter-markdown-inline
              tree-sitter-nix
              tree-sitter-rust
              tree-sitter-sql
              tree-sitter-toml
              tree-sitter-typescript
              tree-sitter-typst
              tree-sitter-vue
              tree-sitter-yaml
            ]))
        ]
    ));
    askpass = import ../modules/cli/scripts/askpass.nix {inherit pkgs;};
    launchWithEmacsclient = import ../modules/cli/scripts/launch-with-emacsclient.nix {
      inherit pkgs config;
    };
  in {
    sops.secrets = {
      emailPassword = {};
      "mopidy/bandcamp" = {};
      "mopidy/spotify" = {};
    };

    home = {
      sessionVariables = {
        LAUNCH_EDITOR = "${launchWithEmacsclient}/bin/launch-with-emacsclient";
        SUDO_ASKPASS = "${askpass}/bin/askpass";
        LSP_USE_PLISTS = "true";
        OPENAI_API_URL = "http://localhost:1234/";
      };
      desktop = {
        caelestia.enable = true;
        firefox = {
          enable = true;
          useZen = true;
          tridactyl = {
            enable = true;
            preConfig = "sanitise tridactyllocal tridactylsync";
            config = {
              editorcmd = "emacsclient -c";
              keyboardlayoutbase = "bepo";
              keyboardlayoutforce = "true";
              hintchars = "auiectsr";
              smothscroll = "true";
            };
            extraConfig = ''
              unbind h
              unbind j
              unbind k
              unbind l
              unbind c
              unbind t
              unbind s
              unbind r
              unbind H
              unbind J
              unbind K
              unbind L
              unbind C
              unbind T
              unbind S
              unbind R

              " === Bépo layout — scrolling (ctsr = hjkl) ===
              bind c scrollpx -300 0
              bind t scrollline 5
              bind s scrollline -5
              bind r scrollpx 300 0

              " Half/full page scroll (replacing C-f/C-b/C-d/C-u)
              bind <C-t> scrollpage 0.5
              bind <C-s> scrollpage -0.5

              " === History navigation (C/R = H/L) ===
              bind C back
              bind R forward

              " === Tab navigation ===
              bind T tabnext
              bind S tabprev

              " === Displaced commands ===
              " reload was on r → move to h (bépo's 'replace' position)
              bind h reload
              bind H reloadhard

              " tabopen was on t → move to j (bépo's 'find char to' position)
              bind j fillcmdline tabopen

              unbind ^http(s?)://youtube\.com f
              unbind ^http(s?)://youtube\.com t
              unbind ^http(s?)://youtube\.com l
              unbind ^http(s?)://youtube\.com j
              unbind ^http(s?)://twitch\.tv f

              bind < urlincrement -1
              bind > urlincrement 1
              bind ypv js tri.native.run(`mpv --ytdl-format="[height >=? 480]" --ontop --fs "''${document.location.href}"`)
              bind ypm hint -JF e => tri.native.run(`mpv --ytdl-format="[height >=? 480]" --ontop --fs "''${e.href}"`)
            '';
          };
        };
        spotify = {
          enable = true;
          spicetify.enable = true;
        };
      };
      dev = {
        ai.claude.enable = true;
        editors.emacs.package = emacsPackage;
        vcs.jj.signing.enable = true;
      };
      fullDesktop = true;
      file."${config.home.homeDirectory}/.ssh/allowed_signers" = {
        enable = true;
        text = lib.strings.join "\n" (
          map (file: let
            content = lib.strings.trim (builtins.readFile file);
            parts = lib.strings.splitString " " content;
            email = lib.lists.last parts;
          in "${email} namespaces=\"git\" ${content}")
          (lib.filesystem.listFilesRecursive ./keys)
        );
      };
    };

    manual = {
      html.enable = true;
      manpages.enable = true;
    };
  };
}
