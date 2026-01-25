{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.home.shell.bash;
in {
  options.home.shell.bash = {
    enable = mkEnableOption "Enables bash";
    aliases = mkOption {
      type = types.attrsOf types.str;
      default = {};
      example = {
        cp = "cp -i";
        lns = "ln -si";
      };
    };
    autocompletion = mkOption {
      type = types.bool;
      default = config.home.shell.autocompletion;
      example = true;
    };
    eatIntegration = mkEnableOption "Enable Emacs Eat integration";
    bashrcExtra = mkOption {
      type = types.lines;
      default = "";
    };
  };

  config = mkIf cfg.enable {
    programs.bash = {
      enable = true;
      # inherit (cfg) bashrcExtra;
      bashrcExtra =
        concatLines
        [
          (strings.optionalString cfg.eatIntegration ''[ -n "$EAT_SHELL_INTEGRATION_DIR" ] && source "$EAT_SHELL_INTEGRATION_DIR/bash"'')
          cfg.bashrcExtra
        ];
      enableCompletion = cfg.autocompletion;
      shellAliases = cfg.aliases;
      shellOptions = [
        "histappend"
        "cmdhist"
        "lithist"
        "checkwinsize"
        "extglob"
        "globstar"
        "checkjobs"
        "autocd"
        "cdspell"
        "dirspell"
      ];
    };
  };
}
