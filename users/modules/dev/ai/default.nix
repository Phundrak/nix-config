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
    ./opencode.nix
  ];

  options.home.dev.ai = {
    enable = mkEnableOption "Enables AI features";
    lmStudio = mkOption {
      default = cfg.enable;
      example = true;
      description = "Enables LM Studio. Enabled by default when AI is enabled.";
    };
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
        opencode.enable = mkDefault cfg.enable;
      };
      packages = lists.optional cfg.lmStudio pkgs.lmstudio;
    };
    programs.mcp = mkIf (cfg.mcpServers != {}) {
      enable = true;
      servers = cfg.mcpServers;
    };
  };
}
