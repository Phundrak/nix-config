{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.bash;
in {
  options.modules.bash = {
    enable = lib.mkEnableOption "enables bash";
    aliases = lib.mkOption {
      type = types.attrsOf types.str;
      default = {};
      example = {
        cp = "cp -i";
        lns = "ln -si";
      };
    };
    bashrcExtra = lib.mkOption {
      type = types.lines;
      default = "";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.bash = {
      enable = true;
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
