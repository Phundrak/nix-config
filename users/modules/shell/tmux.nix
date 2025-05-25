{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.tmux;
in {
  options.modules.tmux.enable = mkEnableOption "Enable tmux";
  config.programs.tmux = mkIf cfg.enable {
    inherit (cfg) enable;
    baseIndex = 1;
    clock24 = true;
    customPaneNavigationAndResize = true;
    keyMode = "vi";
    mouse = true;
    newSession = true;
    prefix = "M-space";
    plugins = with pkgs.tmuxPlugins; [
      cpu
      nord
      prefix-highlight
      resurrect
      sensible
      yank
    ];
    extraConfig = ''
      set-option -sa terminal-overrides ",xterm*:Tc"

      unbind C-b

      bind-key -T prefix « select-window -p
      bind-key -T prefix » select-window -n
      bind-key -T prefix Tab switch-client -T windows
      bind-key -T prefix w switch-client -T pane
      bind-key -T prefix y switch-client -T copy-mode

      bind-key -T pane / split-window -h -c "#{pane-current_path}"
      bind-key -T pane - split-window -v -c "#{pane-current_path}"
      bind-key -T pane c select-pane -L
      bind-key -T pane t select-pane -D
      bind-key -T pane s select-pane -U
      bind-key -T pane r select-pane -R
      bind-key -T pane f resize-pane -Z
      bind-key -T pane . switch-client -T pane-resize

      bind-key -T pane-resize c resize-pane -L 5\; switch-client -T pane-resize
      bind-key -T pane-resize t resize-pane -D 5\; switch-client -T pane-resize
      bind-key -T pane-resize s resize-pane -U 5\; switch-client -T pane-resize
      bind-key -T pane-resize r resize-pane -R 5\; switch-client -T pane-resize
      bind-key -T pane-resize C resize-pane -L\; switch-client -T pane-resize
      bind-key -T pane-resize T resize-pane -D\; switch-client -T pane-resize
      bind-key -T pane-resize S resize-pane -U\; switch-client -T pane-resize
      bind-key -T pane-resize R resize-pane -R\; switch-client -T pane-resize

      bind-key -T windows c new-window
      bind-key -T windows n next-window
      bind-key -T windows p previous-window

      bind-key -T windows \" select-window -t :=1
      bind-key -T windows « select-window -t :=2
      bind-key -T windows » select-window -t :=3
      bind-key -T windows ( select-window -t :=4
      bind-key -T windows ) select-window -t :=5
      bind-key -T windows @ select-window -t :=6
      bind-key -T windows + select-window -t :=7
      bind-key -T windows - select-window -t :=8
      bind-key -T windows / select-window -t :=9
      bind-key -T windows * select-window -t :=10

      unbind -T copy-mode-vi H
      unbind -T copy-mode-vi J
      unbind -T copy-mode-vi K
      unbind -T copy-mode-vi L
      unbind -T copy-mode-vi h
      unbind -T copy-mode-vi j
      unbind -T copy-mode-vi k
      unbind -T copy-mode-vi l

      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
      bind-key -T copy-mode-vi C send-keys -X top-line
      bind-key -T copy-mode-vi J send-keys -X jump-to-backward
      bind-key -T copy-mode-vi S send-keys -X scroll-up
      bind-key -T copy-mode-vi R send-keys -X bottom-line
      bind-key -T copy-mode-vi T send-keys -X scroll-down
      bind-key -T copy-mode-vi c send-keys -X cursor-left
      bind-key -T copy-mode-vi t send-keys -X cursor-down
      bind-key -T copy-mode-vi s send-keys -X cursor-up
      bind-key -T copy-mode-vi r send-keys -X cursor-right
    '';
  };
}
