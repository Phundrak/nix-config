{
  config,
  pkgs,
  ...
}: {
  config.home.desktop.wlr-which-key.settings = {
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
      center-window = import ./center-window.nix {inherit pkgs;};
      close-window = import ./close-window.nix {inherit pkgs;};
      float-window = import ./float-window.nix {inherit pkgs;};
      focus-urgent = import ./focus-urgent.nix {inherit pkgs;};
      fullscreen = import ./fullscreen.nix {inherit pkgs;};
      logout = import ./logout.nix {inherit pkgs;};
      ytplay = import ../../modules/cli/scripts/ytplay.nix {inherit pkgs;};
    in [
      {
        key = "a";
        desc = "Apps";
        submenu = [
          {
            key = "b";
            desc = "Browser";
            cmd = "zen";
          }
          {
            key = "B";
            desc = "Qutebrowser";
            cmd = "${pkgs.qutebrowser}/bin/qutebrowser";
          }
          {
            key = "d";
            desc = "Discord";
            cmd = "${pkgs.vesktop}/bin/vesktop";
          }
          {
            key = "e";
            desc = "Emacs";
            cmd = "${config.home.dev.editors.emacs.package}/bin/emacsclient -c -n";
          }
          {
            key = "g";
            desc = "Gimp";
            cmd = "${pkgs.gimp}/bin/gimp";
          }
          {
            key = "n";
            desc = "Nemo";
            cmd = "${pkgs.nemo}/bin/nemo";
          }
          {
            key = "N";
            desc = "Nextcloud";
            cmd = "${pkgs.nextcloud-client}/bin/nextcloud";
          }
          {
            key = "r";
            desc = "Rofi";
            submenu = [
              {
                key = "b";
                desc = "Bluetooth";
                cmd = "${pkgs.rofi-bluetooth}/bin/rofi-bluetooth";
              }
              {
                key = "c";
                desc = "calc";
                cmd = "rofi -show calc";
              }
              {
                key = "e";
                desc = "Emoji";
                cmd = "rofi -show emoji";
              }
              {
                key = "r";
                desc = "App Menu";
                cmd = "rofi -show drun";
              }
              {
                key = "s";
                desc = "SSH";
                cmd = "rofi -show ssh";
              }
              {
                key = "y";
                desc = "YouTube";
                cmd = "${ytplay}/bin/ytplay";
              }
            ];
          }
        ];
      }
      {
        key = "b";
        desc = "Buffers";
        submenu = [
          {
            key = "c";
            desc = "Center";
            cmd = "${center-window}/bin/center-window";
          }
          {
            key = "d";
            desc = "Close";
            cmd = "${close-window}/bin/close-window";
          }
          {
            key = "f";
            desc = "Fullscreen";
            cmd = "${fullscreen}/bin/fullscreen";
          }
          {
            key = "F";
            desc = "Float";
            cmd = "${float-window}/bin/float-window";
          }
          {
            key = "u";
            desc = "Urgent";
            cmd = "${focus-urgent}/bin/focus-urgent";
          }
          {
            key = ".";
            desc = "Resize";
            submenu = [
              {
                key = left;
                desc = "Decrease Width";
                cmd = "echo decrease width";
                keep-open = true;
              }
              {
                key = down;
                desc = "Increase Height";
                cmd = "echo decrease height";
                keep-open = true;
              }
              {
                key = up;
                desc = "Decrease Height";
                cmd = "echo decrease height";
                keep-open = true;
              }
              {
                key = right;
                desc = "Increase Width";
                cmd = "echo increase width";
                keep-open = true;
              }
            ];
          }
        ];
      }
      {
        key = "p";
        desc = "Power";
        submenu = [
          {
            key = "l";
            desc = "Logout";
            cmd = "";
          }
          {
            key = "s";
            desc = "Suspend";
            cmd = "systemctl suspend";
          }
          {
            key = "r";
            desc = "Reboot";
            cmd = "systemctl reboot";
          }
          {
            key = "o";
            desc = "Poweroff";
            cmd = "systemctl poweroff";
          }
        ];
      }
      {
        key = "s";
        desc = "Screenshots";
        submenu = [
          {
            key = "Print";
            desc = "Screenshot";
            cmd = "screenshot";
          }
          {
            key = "d";
            desc = "Delayed";
            cmd = "screenshot -d 3";
          }
          {
            key = "D";
            desc = "Select, Delay, Edit, and Copy";
            cmd = "screenshot -secd 3";
          }
          {
            key = "e";
            desc = "Select, Edit, and Copy";
            cmd = "screenshot -sec";
          }
          {
            key = "g";
            desc = "Select, Gimp, and Copy";
            cmd = "screenshot -sgc";
          }
          {
            key = "s";
            desc = "Select and Copy";
            cmd = "screenshot -sc";
          }
        ];
      }
    ];
  };
}
