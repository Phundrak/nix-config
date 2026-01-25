{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.home.desktop.hyprland;
  laptops = ["gampo"];
  caelestiaEnabled = config.home.desktop.caelestia.enable;
in {
  imports = [
    ./swaync.nix
    ./waybar.nix
    ./wlsunset.nix
    ./hyprpaper.nix
  ];

  options.home.desktop.hyprland = {
    enable = mkEnableOption "Enables Hyprland";
    emacsPkg = mkOption {
      type = types.package;
      default = config.home.dev.editors.emacs.package or pkgs.emacs;
      example = pkgs.emacs;
    };
    host = mkOption {
      type = types.enum ["gampo" "marpa"];
      description = ''
        Which host is Hyprland running on.

        This helps determine the monitors layout and enable battery support in waybar.
      '';
    };
  };

  config = mkIf cfg.enable {
    home.desktop = {
      hyprpaper.enable = mkDefault (! caelestiaEnabled);
      rofi.enable = mkDefault true;
      swaync.enable = mkDefault (! caelestiaEnabled);
      waybar = {
        enable = mkDefault (! caelestiaEnabled);
        battery = mkDefault (builtins.elem cfg.host laptops);
      };
      wlsunset.enable = mkDefault true;
    };
    services.blueman-applet.enable = ! caelestiaEnabled;
    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = false;
      importantPrefixes = ["$left" "$right" "$up" "$down" "$menu"];
      settings = {
        input = {
          kb_layout = "fr,us";
          kb_variant = "bepo_afnor,";
          # kb_options = "caps:ctrl_modifier";
          numlock_by_default = true;
          follow_mouse = 1;
          touchpad.natural_scroll = false;
          sensitivity = "0";
        };
        monitor =
          {
            "marpa" = [
              # "DP-1, 3440x1440@144, 1080x550, 1"
              # "DP-2, 2560x1080@60, 0x0, 1, transform, 1"
              "DP-2, 1366x768@60, 0x0, 1"
              # "DP-2, 1829x1143@60, 0x0, 1"
            ];
            "gampo" = [];
          }."${cfg.host}";
        general = {
          gaps_in = 5;
          gaps_out = 20;
          border_size = 2;
          "col.active_border" = "rgb(81a1c1) rgb(a3be8c) 45deg";
          "col.inactive_border" = "rgb(4c566a)";
          layout = "master";
        };
        master = {
          orientation = "center";
          new_status = "inherit";
        };
        workspace = [
          "10, layoutopt:orientation:bottom"
          "1, layoutopt:orientation:bottom"
        ];
        decoration = {
          rounding = 20;
        };
        animations = {
          enabled = true;
          animation = [
            # "windows, 1, 7, myBezier"
            "windowsOut, 1, 7, default, popin 80%"
            "border, 1, 10, default"
            "borderangle, 1, 8, default"
            "fade, 1, 7, default"
            "workspaces, 1, 6, default"
          ];
        };
        dwindle = {
          pseudotile = true;
          preserve_split = true;
        };
        exec-once =
          [
            "pactl load-module module-switch-on-connect"
            "${pkgs.mpc}/bin/mpc stop"
            "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
          ]
          ++ lib.lists.optional (! caelestiaEnabled) "${pkgs.networkmanagerapplet}/bin/nm-applet";
      };
      extraConfig = ''
        $left = c
        $right = r
        $up = s
        $down = t
        $menu = rofi -combi-modi drun,calc -show combi

        bind = SUPER, Return, exec, ${pkgs.kitty}/bin/kitty ${pkgs.tmux}/bin/tmux
        bind = SUPER, Space,  exec, ${pkgs.wlr-which-key}/bin/wlr-which-key
        bind =      , Print,  exec, ${pkgs.wlr-which-key}/bin/wlr-which-key -k s

        bindl = , XF86AudioPlay, exec, playerctl play-pause
        bindl = , XF86AudioPause, exec, playerctl pause
        bindl = , XF86AudioStop, exec, playerctl stop
        bindl = , XF86AudioPrev, exec, playerctl previous
        bindl = , XF86AudioNext, exec, playerctl next
        bindl = , XF86AudioForward, exec, playerctl position +1
        bindl = , XF86AudioRewind, exec, playerctl position -1
        bindl = , XF86AudioRaiseVolume, exec, pamixer -i 2
        bindl = , XF86AudioLowerVolume, exec, pamixer -d 2
        bindl = , XF86MonBrightnessUp, exec, xbacklight -perceived -inc 2
        bindl = , XF86MonBrightnessDown, exec, xbacklight -perceived -dec 2
        bindl = , XF86KbdBrightnessUp, exec, xbacklight -perceived -inc 2
        bindl = , XF86KbdBrightnessDown, exec, xbacklight -perceived -dec 2
        bind = SUPER, a, exec, hyprctl switchxkblayout glove80-keyboard next
        bind = SUPER, $left, movefocus, l
        bind = SUPER, $right, movefocus, r
        bind = SUPER, $up, movefocus, u
        bind = SUPER, $down, movefocus, d
        bind = SUPER_SHIFT, $left, movewindow, l
        bind = SUPER_SHIFT, $right, movewindow, r
        bind = SUPER_SHIFT, $up, movewindow, u
        bind = SUPER_SHIFT, $down, movewindow, d
        bind = SUPER_CTRL_SHIFT, $left, moveworkspacetomonitor, e+0 +1
        bind = SUPER_CTRL_SHIFT, $right, moveworkspacetomonitor, e+0 -1
        bind = SUPER, Tab, cyclenext,
        bind = SUPER_SHIFT, Tab, cyclenext, prev
        bindm = SUPER, mouse:272, movewindow
        bindm = SUPER, mouse:273, resizewindow
        bind = SUPER, quotedbl, workspace, 1
        bind = SUPER, guillemotleft, workspace, 2
        bind = SUPER, guillemotright, workspace, 3
        bind = SUPER, parenleft, workspace, 4
        bind = SUPER, parenright, workspace, 5
        bind = SUPER, at, workspace, 6
        bind = SUPER, plus, workspace, 7
        bind = SUPER, minus, workspace, 8
        bind = SUPER, slash, workspace, 9
        bind = SUPER, asterisk, workspace, 10
        bind = SUPER, mouse_down, workspace, e+1
        bind = SUPER, mouse_up, workspace, e-1
        bind = SUPER_SHIFT, quotedbl, movetoworkspace, 1
        bind = SUPER_SHIFT, guillemotleft, movetoworkspace, 2
        bind = SUPER_SHIFT, guillemotright, movetoworkspace, 3
        bind = SUPER_SHIFT, parenleft, movetoworkspace, 4
        bind = SUPER_SHIFT, parenright, movetoworkspace, 5
        bind = SUPER_SHIFT, at, movetoworkspace, 6
        bind = SUPER_SHIFT, plus, movetoworkspace, 7
        bind = SUPER_SHIFT, minus, movetoworkspace, 8
        bind = SUPER_SHIFT, slash, movetoworkspace, 9
        bind = SUPER_SHIFT, asterisk, movetoworkspace, 10

        env = XCURSOR_SIZE,12
      '';
    };
  };
}
