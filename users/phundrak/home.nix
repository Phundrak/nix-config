{
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [
    ./ai.nix
    ./light-home.nix
    ./packages.nix
    ./email.nix
    ./firefox.nix
    ./tmux.nix
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
      "opencode/cors" = {};
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
        spotify = {
          enable = true;
          spicetify.enable = true;
        };
        wl-kbptr = {
          enable = true;
          config = {
            general = {
              # first eight chars to select areas, last three chars
              # for left, right, middle click
              # First eigh chars to select areas: auiectsr
              # last three chars for left, right, and middle click: tsr
              home_row_keys = "auiectsrtsr";
              modes = "tile,bisect,click";
            };
          };
        };
      };
      dev = {
        editors.emacs.package = emacsPackage;
        vcs.jj.signing.enable = true;
      };
      fullDesktop = true;
      file = {
        ".XCompose".source = ./XCompose;
        "${config.home.homeDirectory}/.ssh/allowed_signers" = {
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
      media.mopidy.enable = false;
    };

    manual = {
      html.enable = true;
      manpages.enable = true;
    };
  };
}
