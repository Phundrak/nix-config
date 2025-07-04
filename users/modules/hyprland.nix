{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.hyprland;
  rofi-emoji = import ../scripts/rofi-emoji.nix {inherit pkgs;};
in {
  imports = [
    ./swaync.nix
    ./waybar.nix
    ./wlsunset.nix
  ];

  options.modules.hyprland = {
    enable = mkEnableOption "Enables Hyprland";
    swaync = mkEnableOption "Enables swaync";
    emacsPkg = mkOption {
      type = types.package;
      default = pkgs.emacs;
    };
    host = mkOption {
      type = types.enum ["tilo" "gampo"];
      default = "tilo";
      description = ''
        Which host is Hyprland running on.

        This helps determine the monitors layout.
      '';
    };
    waybar = {
      enable = mkEnableOption "Enables waybar.";
      battery = mkEnableOption "Enables battery support.";
      style = mkOption {
        type = types.path;
        example = ./style.css;
      };
    };
  };

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      systemd.enable = false;
      importantPrefixes = ["$left" "$right" "$up" "$down" "$menu"];
      settings = {
        input = {
          kb_layout = "fr";
          kb_variant = "bepo_afnor";
          # kb_options = "caps:ctrl_modifier";
          numlock_by_default = true;
          follow_mouse = 1;
          touchpad.natural_scroll = false;
          sensitivity = "0";
        };
        monitor =
          {
            "tilo" = [
              "DP-1, 3440x1440@144, 1080x550, 1"
              "DP-2, 2560x1080@60, 0x0, 1, transform, 1"
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
          "4, layoutopt:orientation:bottom"
          "1, layoutopt:orientation:bottom"
        ];
        decoration = {
          rounding = 5;
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
        exec-once = [
          "pactl load-module module-switch-on-connect"
          "${pkgs.mpc}/bin/mpc stop"
          "${pkgs.networkmanagerapplet}/bin/nm-applet"
        ];
      };
      extraConfig = ''
        $left = c
        $right = r
        $up = s
        $down = t
        $menu = ${pkgs.wofi}/bin/wofi --show drun

        bind = SUPER, Return, exec, ${pkgs.kitty}/bin/kitty ${pkgs.tmux}/bin/tmux
        bind = SUPER, Space, submap, leader
        bind = , Print, submap, screenshot

        submap = leader
        bind = , l, exec, plock
        bind = , l, submap, reset
        bind = , a, submap, apps
        bind = , b, submap, buffers
        bind = , w, submap, windows
        bind = , escape, submap, reset
        bind = CTRL, g, submap, reset

        submap = apps
        bind = , b, exec, zen
        bind = , b, submap, reset
        bind = SHIFT, b, exec, qutebrowser
        bind = SHIFT, b, submap, reset
        bind = , d, exec, vesktop
        bind = , d, submap, reset
        bind = , e, exec, ${cfg.emacsPkg}/bin/emacsclient -c -n
        bind = , e, submap, reset
        bind = , g, exec, ${pkgs.gimp}/bin/gimp
        bind = , g, submap, reset
        bind = , n, exec, ${pkgs.nemo}/bin/nemo
        bind = , n, submap, reset
        bind = , r, submap, rofi
        bind = , u, exec, $menu
        bind = , u, submap, reset
        bind = , escape, submap, reset
        bind = CTRL, g, submap, reset
        submap = buffers
        bind = , d, killactive,
        bind = , d, submap, reset
        bind = , escape, submap, reset
        bind = CTRL, g, submap, reset
        submap = resize
        binde = , $left, resizeactive, -10 0
        binde = , $right, resizeactive, 10 0
        binde = , $up, resizeactive, 0 -10
        binde = , $down, resizeactive, 0 10
        bind = , q, submap, reset
        bind = , escape, submap, reset
        bind = CTRL, g, submap, reset
        submap = rofi
        bind = , e, exec, ${rofi-emoji}/bin/rofi-emoji
        bind = , e, submap, reset
        bind = , r, exec, $menu
        bind = , r, submap, reset
        bind = , y, exec, ytplay
        bind = , y, submap, reset
        bind = , escape, submap, reset
        bind = CTRL, g, submap, reset
        submap = screenshot
        bind = , Print, exec, screenshot
        bind = , Print, submap, reset
        bind = , d, exec, screenshot -d 3
        bind = , d, submap, reset
        bind = Shift, d, exec, screenshot -sced 3
        bind = Shift, d, submap, reset
        bind = , e, exec, screenshot -sec
        bind = , e, submap, reset
        bind = , s, exec, screenshot -s
        bind = , s, submap, reset
        bind = Shift, s, exec, screenshot -sc
        bind = Shift, s, submap, reset
        bind = , escape, submap, reset
        bind = CTRL, g, submap, reset
        submap = windows
        bind = , period, submap, resize
        bind = , $left, movefocus, l
        bind = , $left, submap, reset
        bind = , $right, movefocus, r
        bind = , $right, submap, reset
        bind = , $up, movefocus, u
        bind = , $up, submap, reset
        bind = , $down, movefocus, d
        bind = , $down, submap, reset
        bind = SHIFT, $left, movewindow, l
        bind = SHIFT, $left, submap, reset
        bind = SHIFT, $right, movewindow, r
        bind = SHIFT, $right, submap, reset
        bind = SHIFT, $up, movewindow, u
        bind = SHIFT, $up, submap, reset
        bind = SHIFT, $down, movewindow, d
        bind = SHIFT, $down, submap, reset
        bind = CTRL_SHIFT, $left, moveworkspacetomonitor, e+0 +1
        bind = CTRL_SHIFT, $left, submap, reset
        bind = CTRL_SHIFT, $right, moveworkspacetomonitor, e+0 -1
        bind = CTRL_SHIFT, $right, submap, reset
        bind = , d, killactive,
        bind = , d, submap, reset
        bind = , f, fullscreen,
        bind = , f, submap, reset
        bind = SHIFT, f, togglefloating,
        bind = SHIFT, f, submap, reset
        bind = , escape, submap, reset
        bind = CTRL, g, submap, reset

        submap = reset
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
        bind = SUPER, $left, movefocus, l
        bind = SUPER, $right, movefocus, r
        bind = SUPER, $up, movefocus, u
        bind = SUPER, $down, movefocus, d
        bind = SUPER_SHIFT, $left, movewindow, l
        bind = SUPER_SHIFT, $left, submap, reset
        bind = SUPER_SHIFT, $right, movewindow, r
        bind = SUPER_SHIFT, $right, submap, reset
        bind = SUPER_SHIFT, $up, movewindow, u
        bind = SUPER_SHIFT, $up, submap, reset
        bind = SUPER_SHIFT, $down, movewindow, d
        bind = SUPER_SHIFT, $down, submap, reset
        bind = SUPER_CTRL_SHIFT, $left, moveworkspacetomonitor, e+0 +1
        bind = SUPER_CTRL_SHIFT, $left, submap, reset
        bind = SUPER_CTRL_SHIFT, $right, moveworkspacetomonitor, e+0 -1
        bind = SUPER_CTRL_SHIFT, $right, submap, reset
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
      '';
    };
    services = {
      blueman-applet.enable = true;
      wpaperd = {
        enable = true;
        settings = {
          default = {
            path = "/home/phundrak/Pictures/Wallpapers/nord";
            duration = "5m";
            sorting = "random";
            mode = "center";
            recursive = true;
          };
          DP-3 = {
            mode = "fit-border-color";
          };
        };
      };
    };
    modules = {
      swaync.enable = cfg.swaync;
      waybar = mkIf cfg.waybar.enable {
        inherit (cfg.waybar) enable battery style;
      };
      wlsunset.enable = true;
    };
  };
}
