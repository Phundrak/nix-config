{
  home.shell.tmux = {
    enable = true;
    extraConfig = "set-option -sa terminal-overrides \",xterm*:Tc\"";
    unbind = [
      "C-b"
      {"copy-mode-vi" = ["H" "J" "K" "L" "h" "j" "k" "l"];}
    ];
    bind = {
      prefix = [
        {
          key = "«";
          action = "select-window -p";
        }
        {
          key = "»";
          action = "select-window -n";
        }
        {
          key = "Tab";
          action = "switch-client -T windows";
        }
        {
          key = "w";
          action = "switch-client -T pane";
        }
        {
          key = "y";
          action = "switch-client -T copy-mode";
        }
      ];
      pane = [
        {
          key = "/";
          action = "split-window -h -c \"#{pane-current_path}\"";
        }
        {
          key = "-";
          action = "split-window -v -c \"#{pane-current_path}\"";
        }
        {
          key = "c";
          action = "select-pane -L";
        }
        {
          key = "t";
          action = "select-pane -D";
        }
        {
          key = "s";
          action = "select-pane -U";
        }
        {
          key = "r";
          action = "select-pane -R";
        }
        {
          key = "f";
          action = "resize-pane -Z";
        }
        {
          key = ".";
          action = "switch-client -T pane-resize";
        }
      ];
      "pane-resize" = [
        {
          key = "c";
          action = "resize-pane -L 5\\; switch-client -T pane-resize";
        }
        {
          key = "t";
          action = "resize-pane -D 5\\; switch-client -T pane-resize";
        }
        {
          key = "s";
          action = "resize-pane -U 5\\; switch-client -T pane-resize";
        }
        {
          key = "r";
          action = "resize-pane -R 5\\; switch-client -T pane-resize";
        }
        {
          key = "C";
          action = "resize-pane -L\\; switch-client -T pane-resize";
        }
        {
          key = "T";
          action = "resize-pane -D\\; switch-client -T pane-resize";
        }
        {
          key = "S";
          action = "resize-pane -U\\; switch-client -T pane-resize";
        }
        {
          key = "R";
          action = "resize-pane -R\\; switch-client -T pane-resize";
        }
      ];
      windows = [
        {
          key = "c";
          action = "new-window";
        }
        {
          key = "n";
          action = "next-window";
        }
        {
          key = "p";
          action = "previous-window";
        }
        {
          key = "r";
          action = "command-prompt \"rename-window '%%'\"";
        }
        {
          key = "\\\"";
          action = "select-window -t :=1";
        }
        {
          key = "«";
          action = "select-window -t :=2";
        }
        {
          key = "»";
          action = "select-window -t :=3";
        }
        {
          key = "(";
          action = "select-window -t :=4";
        }
        {
          key = ")";
          action = "select-window -t :=5";
        }
        {
          key = "@";
          action = "select-window -t :=6";
        }
        {
          key = "+";
          action = "select-window -t :=7";
        }
        {
          key = "-";
          action = "select-window -t :=8";
        }
        {
          key = "/";
          action = "select-window -t :=9";
        }
        {
          key = "*";
          action = "select-window -t :=10";
        }
      ];
      "copy-mode-vi" = [
        {
          key = "v";
          action = "send-keys -X begin-selection";
        }
        {
          key = "C-v";
          action = "send-keys -X rectangle-toggle";
        }
        {
          key = "y";
          action = "send-keys -X copy-selection-and-cancel";
        }
        {
          key = "C";
          action = "send-keys -X top-line";
        }
        {
          key = "J";
          action = "send-keys -X jump-to-backward";
        }
        {
          key = "S";
          action = "send-keys -X scroll-up";
        }
        {
          key = "R";
          action = "send-keys -X bottom-line";
        }
        {
          key = "T";
          action = "send-keys -X scroll-down";
        }
        {
          key = "c";
          action = "send-keys -X cursor-left";
        }
        {
          key = "t";
          action = "send-keys -X cursor-down";
        }
        {
          key = "s";
          action = "send-keys -X cursor-up";
        }
        {
          key = "r";
          action = "send-keys -X cursor-right";
        }
      ];
    };
  };
}
