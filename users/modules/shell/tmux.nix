{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.home.shell.tmux;
  keyType = types.submodule {
    options = {
      key = mkOption {
        type = types.str;
        example = "C-b";
      };
      action = mkOption {
        type = types.str;
        example = "resize-pane -Z";
      };
    };
  };
in {
  options.home.shell.tmux = with types; {
    enable = mkEnableOption "Enable tmux";
    bind = mkOption {
      type = attrsOf (listOf keyType);
      default = {};
      example = {
        "prefix" = [
          {
            key = "C-r";
            action = "resize-pane -R";
          }
        ];
      };
    };
    unbind = mkOption {
      type = listOf (either str (attrsOf (listOf str)));
      default = [];
    };
    extraConfig = mkOption {
      type = types.lines;
      default = "";
    };
  };
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
    extraConfig = let
      generateBinds = concatLines (
        mapAttrsToList (table: keys: concatMapStrings (key: "bind -T ${table} ${key.key} ${key.action}\n") keys) cfg.bind
      );
      generateUnbind =
        concatMapStrings (
          entry:
            if builtins.isString entry
            then "unbind ${entry}\n"
            else concatStrings (mapAttrsToList (table: keys: concatMapStrings (key: "unbind -T ${table} ${key}\n") keys) entry)
        )
        cfg.unbind;
    in ''
      ${cfg.extraConfig}

      ${generateUnbind}
      ${generateBinds}
    '';
  };
}
