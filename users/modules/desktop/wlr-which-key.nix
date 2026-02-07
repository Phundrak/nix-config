{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit
    (lib)
    literalExpression
    mkIf
    mkOption
    mkEnableOption
    types
    ;
  cfg = config.home.desktop.wlr-which-key;
  yamlFormat = pkgs.formats.yaml {};

  # Convert kebab-case to snake_case
  toSnakeCase = str: builtins.replaceStrings ["-"] ["_"] str;

  # Recursively filter out null values and convert kebab-case keys to snake_case
  filterNulls = value:
    if lib.isAttrs value
    then lib.mapAttrs' (n: v: lib.nameValuePair (toSnakeCase n) (filterNulls v)) (lib.filterAttrs (_: v: v != null) value)
    else if lib.isList value
    then map filterNulls value
    else value;
  menuEntryType = types.submodule {
    freeformType = yamlFormat.type;
    options = with types; {
      key = mkOption {
        type = str;
        example = "p";
      };
      desc = mkOption {
        type = str;
        example = "Power";
      };
      cmd = mkOption {
        type = nullOr str;
        default = null;
        example = "echo example";
      };
      keep-open = mkOption {
        type = nullOr bool;
        default = null;
        example = true;
      };
      submenu = mkOption {
        type = nullOr (listOf menuEntryType);
        default = null;
        example = literalExpression ''
          [
            { key = "s"; desc = "Suspend"; cmd = "systemctl suspend"; }
            { key = "r"; desc = "Reboot"; cmd = "systemctl reboot"; }
            { key = "o"; desc = "Poweroff"; cmd = "systemctl poweroff"; }
          ]
        '';
      };
    };
  };
  settingsType = types.submodule {
    freeformType = yamlFormat.type;
    options = with types; {
      background = mkOption {
        type = nullOr str;
        default = null;
        example = "#282828FF";
      };
      color = mkOption {
        type = nullOr str;
        default = null;
        example = "#FBF1C7FF";
      };
      border = mkOption {
        type = nullOr str;
        default = null;
        example = "#8EC07CFF";
      };
      anchor = mkOption {
        type = nullOr (enum ["center" "top" "bottom" "left" "right" "top-left" "top-right" "bottom-left" "bottom-right"]);
        default = null;
        example = "top-left";
      };
      margin-top = mkOption {
        type = nullOr int;
        default = null;
        example = "0";
      };
      margin-right = mkOption {
        type = nullOr int;
        default = null;
        example = "0";
      };
      margin-bottom = mkOption {
        type = nullOr int;
        default = null;
        example = "0";
      };
      margin-left = mkOption {
        type = nullOr int;
        default = null;
        example = "0";
      };
      font = mkOption {
        type = nullOr str;
        default = null;
        example = "monospace 10";
      };
      separator = mkOption {
        type = nullOr str;
        default = null;
        example = " ➜ ";
      };
      border-width = mkOption {
        type = nullOr (either float int);
        default = null;
        example = 4.0;
      };
      corder-r = mkOption {
        type = nullOr (either float int);
        default = null;
        example = 20.0;
      };
      padding = mkOption {
        type = nullOr (either float int);
        default = null;
        example = 15.0;
      };
      rows-per-column = mkOption {
        type = nullOr int;
        default = null;
        example = 5;
      };
      column-padding = mkOption {
        type = nullOr (either float int);
        default = null;
        example = 25.0;
      };
      inhibit-compositor-keyboard-shortcuts = mkOption {
        type = bool;
        default = true;
        example = false;
      };
      auto_kbd_layout = mkOption {
        type = bool;
        default = true;
        example = false;
      };
      namespace = mkOption {
        type = nullOr str;
        default = null;
        example = "wlr_which_key";
      };
      menu = mkOption {
        type = listOf menuEntryType;
        default = [];
        example = literalExpression ''
          [
            {
              key = "p";
              desc = "Power";
              submenu = [
                { key = "s"; desc = "Suspend"; cmd = "systemctl suspend"; }
                { key = "r"; desc = "Reboot"; cmd = "systemctl reboot"; }
                { key = "o"; desc = "Poweroff"; cmd = "systemctl poweroff"; }
              ];
            }
          ]
        '';
      };
    };
  };
in {
  options.home.desktop.wlr-which-key = {
    enable = mkEnableOption "Enables wlr-which-key";
    package = lib.mkPackageOption pkgs "wlr-which-key" {};
    settings = mkOption {
      type = settingsType;
      default = {};
      description = "Configuration written to {file}`$XDG_CONFIG_HOME/wlr-which-key/config.yaml`.";
    };
  };
  config = mkIf cfg.enable {
    xdg.configFile = {
      "wlr-which-key/config.yaml".source = yamlFormat.generate "wlr-which-key-config.yml" (filterNulls cfg.settings);
    };
  };
}
