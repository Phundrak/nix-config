{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.home.shell.zellij;
  isEmpty = list: list == [];
  keybind = {
    options = {
      bind = mkOption {
        type = types.either types.str (types.listOf types.str);
        example = "Alt j";
        description = "Value used as a string after `bind` in zellij config";
      };
      actions = mkOption {
        type = with types; let
          allowed = oneOf [int str];
        in
          attrsOf (either (listOf allowed) allowed);
        default = {};
        example = {
          SwitchToMode = ["normal"];
          SwitchFocus = [];
          PaneNameInput = [0];
        };
      };
      useUnlockFirst = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Go back to locked mode after the actions are done.

          Only works when `config.home.shell.zellij.useUnlockFirst` is true.
        '';
      };
    };
  };
  convertBind = item: {
    bind = let
      useUnlockFirst = cfg.useUnlockFirst && item.useUnlockFirst;
      children =
        mapAttrsToList (action: args: let
          actualArgs =
            if isEmpty args
            then {}
            else {_args = lists.toList args;};
        in {"${action}" = actualArgs;})
        (item.actions
          // (
            if useUnlockFirst
            then {SwitchToMode = ["locked"];}
            else {}
          ));
    in {
      _args = lists.toList item.bind;
      _children = children;
    };
  };
  keybindsModule = {
    options = mergeAttrsList (forEach [
        "normal"
        "locked"
        "resize"
        "pane"
        "move"
        "tab"
        "scroll"
        "search"
        "entersearch"
        "renametab"
        "renamepane"
        "session"
        "tmux"
      ]
      (x: {
        "${x}" = mkOption {
          type = types.listOf (types.submodule keybind);
          default = [];
        };
      }));
  };
  makeKeybinds = keybinds: let
    values =
      attrsets.concatMapAttrs (
        mode: binds:
          if (isEmpty binds)
          then {}
          else {
            "${mode}"._children = lists.forEach binds convertBind;
          }
      )
      keybinds;
  in
    if values == {}
    then {}
    else {
      keybinds = values;
    };
in {
  options.home.shell.zellij = let
    jsonFormat = pkgs.formats.yaml {};
  in {
    enable = mkEnableOption "Enable Zellij";
    clearDefaultKeybinds = mkEnableOption "Clear default keybinds";
    settings = mkOption {
      inherit (jsonFormat) type;
      default = {};
    };
    layouts = mkOption {
      inherit (jsonFormat) type;
      default = {};
    };
    extraSettings = mkOption {
      type = types.lines;
      default = "";
      description = ''
        Extra configuration lines to add to `$XDG_CONFIG_HOME/zellij/config.kdl`
      '';
    };
    useUnlockFirst = mkEnableOption "Use Unlock-First (non-colliding) behaviour by default";
    plugins = mkOption {
      type = types.listOf (types.submodule plugin);
      default = {};
      example = [
        {name = "about";}
        {
          name = "filepicker";
          location = "zellij:strider";
          options = {
            cwd = "/";
          };
        }
      ];
    };
    keybinds = mkOption {
      type = types.submodule keybindsModule;
      default = {};
      example = {
        pane = [
          {
            bind = "c";
            actions = [
              {
                action = "SwitchToMode";
                args = ["renamepane"];
              }
              {
                action = "PaneNameInput";
                args = [0];
              }
            ];
          }
        ];
      };
    };
  };
  config.programs.zellij = mkIf cfg.enable {
    inherit (cfg) enable layouts;
    extraConfig = cfg.extraSettings;
    settings = let
      resetKeybinds =
        if cfg.clearDefaultKeybinds
        then {
          keybinds._props.clear-defaults = true;
        }
        else {};
      keybinds = makeKeybinds cfg.keybinds;
    in
      cfg.settings // resetKeybinds // keybinds;
  };
}
