{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  emacsDefaultPackage = with pkgs; ((emacsPackagesFor emacs).emacsWithPackages (
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
  cfg = config.home.dev.editors.emacs;
in {
  options.home.dev.editors.emacs = {
    enable = mkEnableOption "enables Emacs";
    package = mkOption {
      type = types.package;
      default = emacsDefaultPackage;
    };
    service = mkEnableOption "enables Emacs service";
    mu4eMime = mkEnableOption "Enables mu4e to handle mailto scheme";
    org-protocol = mkEnableOption "Enables org-protocol";
  };

  config = {
    home.packages = with pkgs; [
      emacs-all-the-icons-fonts
      emacs-lsp-booster
    ];
    programs.emacs = mkIf cfg.enable {
      enable = true;
      inherit (cfg) package;
    };
    services.emacs = mkIf cfg.service {
      enable = true;
      inherit (cfg) package;
      startWithUserSession = "graphical";
    };

    xdg.desktopEntries.mu4e = mkIf cfg.mu4eMime {
      name = "mu4e";
      genericName = "mu4e";
      comment = "Maildir Utils for Emacs";
      mimeType = ["x-scheme-handler/mailto"];
      noDisplay = true;
      exec = "${cfg.package}/bin/emacsclient -c -n -a ${cfg.package}/bin/emacs -e \"(browse-url-mail \\\"\\$*\\\")\"";
      terminal = false;
      categories = ["Network" "Email" "TextEditor" "Utility"];
    };

    xdg.desktopEntries.org-protocol = mkIf cfg.org-protocol {
      name = "org-protocol";
      exec = "${cfg.package}/bin/emacsclient -c -n -a ${cfg.package}/bin/emacs %u";
      terminal = false;
      noDisplay = true;
      categories = ["System"];
      mimeType = ["x-scheme-handler/org-protocol"];
    };
  };
}
