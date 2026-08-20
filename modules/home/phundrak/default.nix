{config, ...}: let
  m = config.flake.modules.homeManager;
in {
  flake.modules.homeManager.phundrak = {
    pkgs,
    config,
    lib,
    ...
  }:
    with lib; let
      cfg = config.home.phundrak;
      fullDesktop = config.home.fullDesktop;
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
      askpass = import ../cli/_scripts/askpass.nix {inherit pkgs;};
      launchWithEmacsclient = import ../cli/_scripts/launch-with-emacsclient.nix {
        inherit pkgs config;
      };
    in {
      imports = [
        m.home-base
        m.sops-user-phundrak
        m.phundrak-ai
        m.phundrak-email
        m.phundrak-firefox
        m.phundrak-tmux
        m.phundrak-zellij
        m.phundrak-packages
        ./_wlr-which-key
      ];

      options.home.phundrak = {
        sshKey = {
          content = mkOption {
            type = types.nullOr types.str;
            example = "ssh-ed25519 AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
            default = null;
          };
          file = mkOption {
            type = with types; nullOr path;
            default = "/home/phundrak/.ssh/id_ed25519.pub";
          };
        };
      };

      config = mkMerge [
        # light-home.nix — unconditional base
        {
          nixpkgs.config.allowUnfree = true;

          home = {
            username = "phundrak";
            homeDirectory = "/home/phundrak";
            packages = [pkgs.tree pkgs.ncdu];
            preferXdgDirectories = true;

            phundrak.sshKey.file = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";

            dev.vcs = {
              jj.enable = true;
              git.enable = true;
              publicKey = cfg.sshKey;
            };

            security.ssh = {
              enable = true;
              hosts = config.sops.secrets."ssh/hosts".path;
            };

            shell = {
              bash.enable = true;
              zsh.enable = true;
              starship = {
                enable = true;
                jjIntegration = true;
              };
              tmux.enable = true;
              zoxide = {
                enable = true;
                replaceCd = true;
              };
            };

            stateVersion = "24.11"; # Do not modify!
          };

          manual.manpages.enable = true;
        }

        # home.nix — full-desktop content, now gated on home.fullDesktop
        (mkIf fullDesktop {
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

          manual.html.enable = true;
        })
      ];
    };
}
