{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.home.desktop.kitty;
in {
  options.home.desktop.kitty.enable = mkEnableOption "Enable kitty terminal";
  config.programs.kitty = mkIf cfg.enable {
    inherit (cfg) enable;
    themeFile = "Nord";
    font = {
      package = pkgs.cascadia-code;
      name = "Cascadia Code";
      size = 10;
    };
    settings = {
      enable_audio_bell = true;
      visual_bell_duration = 0.1;
      enabled_layouts = "fat,fat:mirrored=true,tall,tall:mirrored=true";
      kitty_mod = "ctrl+shift";
      disable_ligatures = "never";
      font_features = "Cascadia-Mono +onum +zero";
      cursor_shape = "block";
      scrollback_lines = "10000";
      mouse_hide_wait = 3.0;
      detect_urls = true;
      background_opacity = 0.7;
    };
    keybindings = let
      prefix = "kitty_mod+space";
    in {
      "alt+c" = "copy_to_clipboard";
      "kitty_mod+c" = "copy_to_clipboard";
      "alt+v" = "paste_from_clipboard";
      "kitty_mod+v" = "paste_from_clipboard";

      "${prefix}>s>c" = "show_scrollback";
      "${prefix}>s>down" = "scroll_line_down";
      "${prefix}>s>t" = "scroll_line_down";
      "${prefix}>s>up" = "scroll_line_up";
      "${prefix}>s>s" = "scroll_line_up";
      "${prefix}>s>end" = "scroll_end";
      "${prefix}>s>home" = "scroll_home";
      "${prefix}>s>page_down" = "scroll_page_down";
      "${prefix}>s>page_up" = "scroll_page_up";

      "${prefix}>enter" = "new_window";
      "${prefix}>w>q" = "close_window";
      "${prefix}>w>p" = "next_window";
      "${prefix}>w>n" = "previous_window";
      "${prefix}>w>f" = "move_window_forward";
      "${prefix}>w>b" = "move_window_backward";
      "${prefix}>w>t" = "move_window_to_top";
      "${prefix}>w>r" = "start_resizing_window";
      "${prefix}>w>1" = "first_window";
      "${prefix}>w>2" = "second_window";
      "${prefix}>w>3" = "third_window";
      "${prefix}>w>4" = "fourth_window";
      "${prefix}>w>5" = "fifth_window";
      "${prefix}>w>6" = "sixth_window";
      "${prefix}>w>7" = "seventh_window";
      "${prefix}>w>8" = "eighth_window";
      "${prefix}>w>9" = "ninth_window";
      "${prefix}>w>0" = "tenth_window";

      "${prefix}>tab>n" = "next_tab";
      "${prefix}>tab>p" = "previous_tab";
      "${prefix}>tab>c" = "new_tab";
      "${prefix}>tab>q" = "close_tab";
      "${prefix}>tab>shift+n" = "move_tab_backward";
      "${prefix}>tab>shift+p" = "move_tab_forward";
      "${prefix}>tab>t" = "set_tab_title";

      "${prefix}>l" = "next_layout";

      "${prefix}>f>equal" = "change_font_size all 0";
      "${prefix}>f>kp_add" = "change_font_size all +2.0";
      "${prefix}>f>plus" = "change_font_size all +2.0";
      "${prefix}>f>kp_subtract" = "change_font_size all -2.0";
      "${prefix}>f>minus" = "change_font_size all -2.0";

      "${prefix}>shift+h" = "kitten hints";
      "${prefix}>h>p" = "kitten hints --type path --program -";
      "${prefix}>h>shift+p" = "kitten hints --type path";
      "${prefix}>h>l" = "kitten hints --type line --program -";
      "${prefix}>h>w" = "kitten hints --type word --program -";
      "${prefix}>h>h" = "kitten hints --type hash --program -";
      "${prefix}>h>n" = "kitten hints --type linenum";
      "${prefix}>h>y" = "kitten hints --type hyperlink";

      "${prefix}>f10" = "toggle_maximized";
      "${prefix}>f11" = "toggle_fullscreen";

      "${prefix}>a>equal" = "set_background_opacity 1";
      "${prefix}>a>d" = "set_background_opacity default";
      "${prefix}>a>plus" = "set_background_opacity +0.1";
      "${prefix}>a>up" = "set_background_opacity +0.1";
      "${prefix}>a>kp_add" = "set_background_opacity +0.1";
      "${prefix}>a>minus" = "set_background_opacity -0.1";
      "${prefix}>a>down" = "set_background_opacity -0.1";
      "${prefix}>a>kp_substract" = "set_background_opacity -0.1";

      "${prefix}>delete" = "clear_terminal reset active";
      "${prefix}>escape" = "kitty_shell window";
      "${prefix}>f2" = "edit_config_file";
      "${prefix}>n" = "new_os_window";
      "${prefix}>o" = "pass_selection_to_program";
      "${prefix}>u" = "kitten unicode_input";
    };
  };
}
