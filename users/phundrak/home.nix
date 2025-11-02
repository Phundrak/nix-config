{
  pkgs,
  config,
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
        EDITOR = "${config.home.dev.editors.emacs.package}/bin/emacsclient -c -a ${config.home.dev.editors.emacs.package}/bin/emacs";
        LAUNCH_EDITOR = "${launchWithEmacsclient}/bin/launch-with-emacsclient";
        SUDO_ASKPASS = "${askpass}/bin/askpass";
        LSP_USE_PLISTS = "true";
      };
      desktop.waybar.style = ./config/waybar/style.css;
      dev = {
        ai.claude.enable = true;
        editors.emacs.package = emacsPackage;
        vcs.jj.signing.enable = true;
      };
      fullDesktop = true;
    };

    manual = {
      html.enable = true;
      manpages.enable = true;
    };
  };
}
