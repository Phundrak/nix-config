{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.home.dev.ai;
  jsonFormat = pkgs.formats.json {};
in {
  imports = [
    ./claude.nix
    ./ollama.nix
  ];

  options.home.dev.ai = {
    enable = mkEnableOption "Enables AI features";
    mcpServers = mkOption {
      inherit (jsonFormat) type;
      default = {};
    };
  };
  config = {
    home = mkIf cfg.enable {
      dev.ai = {
        claude = {
          enable = mkDefault cfg.enable;
          mcpServers = mkDefault cfg.mcpServers;
        };
        ollama.enable = mkDefault cfg.enable;
      };
      packages = [pkgs.lmstudio];
    };
    programs.mcp = mkIf (cfg.mcpServers != {}) {
      enable = true;
      servers = cfg.mcpServers;
    };
  };
}
