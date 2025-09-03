{
  config,
  lib,
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
  config.home.dev.ai = mkIf cfg.enable {
    ollama.enable = mkDefault cfg.enable;
    claude.enable = mkDefault cfg.enable;
  };
}
