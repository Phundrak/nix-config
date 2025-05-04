{
  programs.kitty = {
    enable = true;
    settings = {
      enable_audio_bell = true;
      enabled_layouts = "fat,fat:mirrored=true,tall,tall:mirrored=true";
      kitty_mod = "ctrl+shift";
    };
    keybindings = {
      "alt+c" = "copy_to_clipboard";
      "kitty_mod+c" = "copy_to_clipboard";
      "alt+v" = "paste_from_clipboard";
      "kitty_mod+v" = "paste_from_clipboard";

      "kitty_mod+s>c" = "show_scrollback";
      "kitty_mod+s>down" = "scroll_line_down";
      "kitty_mod+s>t" = "scroll_line_down";
      "kitty_mod+s>up" = "scroll_line_up";
      "kitty_mod+s>s" = "scroll_line_up";
      "kitty_mod+s>end" = "scroll_end";
      "kitty_mod+s>home" = "scroll_home";
      "kitty_mod+s>page_down" = "scroll_page_down";
      "kitty_mod+s>page_up" = "scroll_page_up";

      "kitty_mod+enter" = "new_window";
      "kitty_mod+w>q" = "close_window";
      "kitty_mod+w>p" = "next_window";
      "kitty_mod+w>n" = "previous_window";
      "kitty_mod+w>f" = "move_window_forward";
      "kitty_mod+w>b" = "move_window_backward";
      "kitty_mod+w>t" = "move_window_to_top";
      "kitty_mod+w>r" = "start_resizing_window";
      "kitty_mod+w>1" = "first_window";
      "kitty_mod+w>2" = "second_window";
      "kitty_mod+w>3" = "third_window";
      "kitty_mod+w>4" = "fourth_window";
      "kitty_mod+w>5" = "fifth_window";
      "kitty_mod+w>6" = "sixth_window";
      "kitty_mod+w>7" = "seventh_window";
      "kitty_mod+w>8" = "eighth_window";
      "kitty_mod+w>9" = "ninth_window";
      "kitty_mod+w>0" = "tenth_window";

      "kitty_mod+tab>n" = "next_tab";
      "kitty_mod+tab>p" = "previous_tab";
      "kitty_mod+tab>c" = "new_tab";
      "kitty_mod+tab>q" = "close_tab";
      "kitty_mod+tab>shift+n" = "move_tab_backward";
      "kitty_mod+tab>shift+p" = "move_tab_forward";
      "kitty_mod+tab>t" = "set_tab_title";

      "kitty_mod+l" = "next_layout";

      "kitty_mod+f>equal" = "change_font_size all 0";
      "kitty_mod+f>kp_add" = "change_font_size all +2.0";
      "kitty_mod+f>plus" = "change_font_size all +2.0";
      "kitty_mod+f>kp_subtract" = "change_font_size all -2.0";
      "kitty_mod+f>minus" = "change_font_size all -2.0";

      "kitty_mod+shift+h" = "kitten hints";
      "kitty_mod+h>p" = "kitten hints --type path --program -";
      "kitty_mod+h>shift+p" = "kitten hints --type path";
      "kitty_mod+h>l" = "kitten hints --type line --program -";
      "kitty_mod+h>w" = "kitten hints --type word --program -";
      "kitty_mod+h>h" = "kitten hints --type hash --program -";
      "kitty_mod+h>n" = "kitten hints --type linenum";
      "kitty_mod+h>y" = "kitten hints --type hyperlink";

      "kitty_mod+f10" = "toggle_maximized";
      "kitty_mod+f11" = "toggle_fullscreen";

      "kitty_mod+a>equal" = "set_background_opacity 1";
      "kitty_mod+a>d" = "set_background_opacity default";
      "kitty_mod+a>plus" = "set_background_opacity +0.1";
      "kitty_mod+a>up" = "set_background_opacity +0.1";
      "kitty_mod+a>kp_add" = "set_background_opacity +0.1";
      "kitty_mod+a>minus" = "set_background_opacity -0.1";
      "kitty_mod+a>down" = "set_background_opacity -0.1";
      "kitty_mod+a>kp_substract" = "set_background_opacity -0.1";

      "kitty_mod+delete" = "clear_terminal reset active";
      "kitty_mod+escape" = "kitty_shell window";
      "kitty_mod+f2" = "edit_config_file";
      "kitty_mod+n" = "new_os_window";
      "kitty_mod+o" = "pass_selection_to_program";
      "kitty_mod+u" = "kitten unicode_input";
    };
  };
}
