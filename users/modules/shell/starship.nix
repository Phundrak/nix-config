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
      # Disabling these so they can be enabled conditionally
      # See https://github.com/jj-vcs/jj/wiki/Starship
      git_status.disabled = true;
      git_commit.disabled = true;
      git_metrics.disabled = true;
      git_branch.disabled = true;
      custom = let
        when = "! jj --ignore-working-copy-root";
        description = "Only show if we’re not in a jj repository";
        style = "";
      in {
        git_status = {
          inherit when description style;
          command = "starship module git_status";
        };
        git_commit = {
          inherit when description style;
          command = "starship module git_commit";
        };
        git_metrics = {
          inherit when description style;
          command = "starship module git_metrics";
        };
        git_branch = {
          inherit when description style;
          command = "starship module git_branch";
        };
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
  };
}
