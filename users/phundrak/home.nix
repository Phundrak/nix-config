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
        EDITOR = "${emacsPackage}/bin/emacsclient -c -a ${emacsPackage}/bin/emacs";
        LAUNCH_EDITOR = "${launchWithEmacsclient}/bin/launch-with-emacsclient";
        SUDO_ASKPASS = "${askpass}/bin/askpass";
        LSP_USE_PLISTS = "true";
      };

      desktop = {
        waybar.style = ./config/waybar/style.css;
        wlr-which-key.settings = {
          font = "Cascadia Code 12";
          background = "#3b4252d0";
          color = "#eceff4";
          border = "#2e3440";
          border_width = 2;
          corner_r = 10;
          rows_per_column = 5;
          column_padding = 25;
          inhibit_compositor_keyboard_shortcuts = true;
          auto_kbd_layout = true;
          menu = let
            left = "c";
            down = "t";
            up = "s";
            right = "r";
          in [
            {
              key = "a";
              desc = "Apps";
              submenu = [
                { key = "b"; desc = "Browser"; cmd = "zen"; }
                { key = "B"; desc = "Qutebrowser"; cmd = "${pkgs.qutebrowser}/bin/qutebrowser"; }
                { key = "d"; desc = "Discord"; cmd = "${pkgs.vesktop}/bin/vesktop"; }
                { key = "e"; desc = "Emacs"; cmd = "${emacsPackage}/bin/emacsclient -c -n"; }
                { key = "g"; desc = "Gimp"; cmd = "${pkgs.gimp}/bin/gimp"; }
                { key = "n"; desc = "Nemo"; cmd = "${pkgs.nemo}/bin/nemo"; }
                {
                  key = "r";
                  desc = "Rofi";
                  submenu = [
                    { key = "b"; desc = "Bluetooth"; cmd = "rofi-bluetooth"; }
                    { key = "e"; desc = "Emoji"; cmd = "rofi -show emoji"; }
                    { key = "r"; desc = "App Menu"; cmd = "rofi -combi-modi drun,calc -show combi"; }
                    { key = "s"; desc = "SSH"; cmd = "rofi -show ssh"; }
                    { key = "y"; desc = "YouTube"; cmd = "ytplay"; }
                  ];
                }
              ];
            }
            {
              key = "b";
              desc = "Buffers";
              submenu = [
                { key = "d"; desc = "Close"; cmd = "echo close"; }
                { key = "f"; desc = "Fullscreen"; cmd = "echo fullscreen"; }
                { key = "F"; desc = "Float"; cmd = "echo float"; }
                {
                  key = ".";
                  desc = "Resize";
                  submenu = [
                    { key = left;  desc = "Decrease Width";  cmd = "echo decrease width";  keep-open = true; }
                    { key = down;  desc = "Increase Height"; cmd = "echo decrease height"; keep-open = true; }
                    { key = up;    desc = "Decrease Height"; cmd = "echo decrease height"; keep-open = true; }
                    { key = right; desc = "Increase Width";  cmd = "echo increase width";  keep-open = true; }
                  ];
                }
              ];
            }
            {
              key = "p";
              desc = "Power";
              submenu = [
                { key = "s"; desc = "Suspend"; cmd = "systemctl suspend"; }
                { key = "r"; desc = "Reboot"; cmd = "systemctl reboot"; }
                { key = "o"; desc = "Poweroff"; cmd = "systemctl poweroff"; }
              ];
            }
            {
              key = "s";
              desc = "Screenshots";
              submenu = [
                { key = "Print"; desc = "Screenshot"; cmd = "screenshot"; }
                { key = "d"; desc = "Delayed"; cmd = "screenshot -d 3"; }
                { key = "D"; desc = "Select, Delay, Edit, and Copy"; cmd = "screenshot -secd 3"; }
                { key = "e"; desc = "Select, Edit, and Copy"; cmd = "screenshot -sec"; }
                { key = "g"; desc = "Select, Gimp, and Copy"; cmd = "screenshot -sgc"; }
                { key = "s"; desc = "Select and Copy"; cmd = "screenshot -sc"; }
              ];
            }
          ];
        };
      };
      dev = {
        ai.claude.enable = true;
        editors.emacs.package = emacsPackage;
      };
      fullDesktop = true;
      shell.fish.enable = true;
    };

    manual.html.enable = true;
  };
}
