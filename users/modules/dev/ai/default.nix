{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.home.dev.ai;
in {
  imports = [
    ./ollama.nix
    ./claude.nix
  ];

  options.home.dev.ai.enable = mkEnableOption "Enables AI features";
  config.home = mkIf cfg.enable {
    dev.ai = {
      ollama.enable = mkDefault cfg.enable;
      claude.enable = mkDefault cfg.enable;
    };
    packages = [pkgs.opencode];
  };
}
