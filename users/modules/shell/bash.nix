{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.bash;
in {
  options.modules.bash = {
    enable = mkEnableOption "Enables bash";
    aliases = mkOption {
      type = types.attrsOf types.str;
      default = {};
      example = {
        cp = "cp -i";
        lns = "ln -si";
      };
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
