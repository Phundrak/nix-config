{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.home.shell.starship;
in {
  options.home.shell.starship = {
    enable = mkEnableOption "Enables the starship prompt.";
    jjIntegration = mkOption {
      description = "Enable Jujutsu integration in starship";
      default = config.programs.jujutsu.enable;
      type = types.bool;
    };
  };

  config.programs.starship = mkIf cfg.enable {
    inherit (cfg) enable;
    enableTransience = true;
    settings = mkIf cfg.jjIntegration {
      custom.jj = {
        description = "The current jj status";
        detect_folders = [".jj"];
        symbol = "🥋 ";
        command = ''
          jj log --revisions @ --no-graph --ignore-working-copy --color always --limit 1 --template '
            separate(" ",
              change_id.shortest(4),
              bookmarks,
              "|",
              concat(
                if(conflict, "💥"),
                if(divergent, "🚧"),
                if(hidden, "👻"),
                if(immutable, "🔒"),
              ),
              raw_escape_sequence("\x1b[1;32m") ++ if(empty, "(empty)"),
              raw_escape_sequence("\x1b[1;32m") ++ coalesce(
                truncate_end(29, description.first_line(), "…"),
                "(no description set)",
              ) ++ raw_escape_sequence("\x1b[0m"),
              )
          '
        '';
      };
    };
  };
}
