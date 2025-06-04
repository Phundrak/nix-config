{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.ollama;
in {
  options.modules.ollama = {
    enable = mkEnableOption "Enables Ollama";
    gpu = mkOption {
      type = types.nullOr types.enum ["none" "amd" "nvidia"];
      example = "amd";
      default = "none";
      description = "Which type of GPU should be used for hardware acceleration";
    };
  };

  config.services.ollama = mkIf cfg.enable {
    inherit (cfg) enable;
    environmentVariables = {
      OLLAMA_CONTEXT_LENGTH = "8192";
    };
  };
}
