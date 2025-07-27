{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.home.shell.fish;
in {
  options.home.shell.fish = {
    enable = lib.mkEnableOption "enables fish";
    abbrs = lib.mkOption {
      type = types.attrsOf types.str;
      default = {};
      example = {
        cp = "cp -i";
        lns = "ln -si";
      };
    };
    extraShellInit = mkOption {
      type = types.lines;
      default = "";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.fish = {
      enable = true;
      shellAbbrs = cfg.abbrs;
      preferAbbrs = true;
      shellInit = with lib;
        concatLines [
          ''
            function fish_command_not_found
              __fish_default_command_not_found_handler $argv
            end
          ''
          cfg.extraShellInit
        ];
      plugins = [
        {
          name = "bass";
          inherit (pkgs.fishPlugins.bass) src;
          # src = pkgs.fishPlugins.bass.src;
        }
        {
          name = "colored-man-pages";
          inherit (pkgs.fishPlugins.colored-man-pages) src;
        }
        {
          name = "done";
          inherit (pkgs.fishPlugins.done) src;
        }
        {
          name = "fzf";
          inherit (pkgs.fishPlugins.fzf) src;
        }
        {
          name = "pisces";
          inherit (pkgs.fishPlugins.pisces) src;
        }
        {
          name = "getopts.fish";
          src = pkgs.fetchFromGitHub {
            owner = "jorgebucaran";
            repo = "getopts.fish";
            rev = "4b74206725c3e11d739675dc2bb84c77d893e901";
            sha256 = "9hRFBmjrCgIUNHuOJZvOufyLsfreJfkeS6XDcCPesvw=";
          };
        }
        {
          name = "replay.fish";
          src = pkgs.fetchFromGitHub {
            owner = "jorgebucaran";
            repo = "replay.fish";
            rev = "d2ecacd3fe7126e822ce8918389f3ad93b14c86c";
            sha256 = "TzQ97h9tBRUg+A7DSKeTBWLQuThicbu19DHMwkmUXdg=";
          };
        }
      ];
    };
  };
}
