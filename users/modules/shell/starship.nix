{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.starship;
in {
  options.modules.starship = {
    enable = mkEnableOption "Enables the starship prompt.";
    jjIntegration = mkEnableOption "Enables Jujutsu integration in starship.";
  };

  config.programs.starship = mkIf cfg.enable {
    inherit (cfg) enable;
    enableTransience = true;
    settings.custom = {
      jj = {
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
