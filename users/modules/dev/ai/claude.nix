{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
with lib; let
  cfg = config.home.dev.ai.claude;
  system = pkgs.stdenv.hostPlatform.system;
in {
  options.home.dev.ai.claude.enable = mkEnableOption "Enables Claude-related packages";
  config = mkIf cfg.enable {
    home.packages = let
      claude-jj = pkgs.writeShellScriptBin "claude-jj" ''
        ${pkgs.claude-code}/bin/claude --append-system-prompt 'CRITICAL: This repository uses Jujutsu (jj), NOT git. Never use git commands. Use jj equivalents. See CLAUDE.md.' "$@"
      '';
    in [claude-jj];
    programs.claude-code = {
      inherit (cfg) enable;
    };
  };
}
