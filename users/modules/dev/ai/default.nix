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
    ./claude.nix
    ./ollama.nix
  ];

  options.home.dev.ai.enable = mkEnableOption "Enables AI features";
  config.home = mkIf cfg.enable {
    dev.ai = {
      claude.enable = mkDefault cfg.enable;
      ollama.enable = mkDefault cfg.enable;
    };
    packages = [pkgs.lmstudio];
  };
}
