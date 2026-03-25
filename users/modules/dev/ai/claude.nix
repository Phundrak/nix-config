{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.home.dev.ai.claude;
  jsonFormat = pkgs.formats.json {};
in {
  options.home.dev.ai.claude = {
    enable = mkEnableOption "Enables Claude-related packages";
    mcpServers = mkOption {
      inherit (jsonFormat) type;
      default = {};
    };
  };
  config = mkIf cfg.enable {
    home.packages = let
      claude-jj = pkgs.writeShellScriptBin "claude-jj" ''
        ${pkgs.claude-code}/bin/claude --append-system-prompt 'CRITICAL: This repository uses Jujutsu (jj), NOT git. Never use git commands. Use jj equivalents.' "$@"
      '';
    in [claude-jj pkgs.sox];
    programs.claude-code = {
      inherit (cfg) enable mcpServers;
    };
  };
}
