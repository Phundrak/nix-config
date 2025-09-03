{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.home.dev.ai.ollama;
in {
  options.home.dev.ai.ollama = {
    enable = mkEnableOption "Enables Ollama";
    gpu = mkOption {
      type = types.nullOr (types.enum [false "rocm" "cuda"]);
      example = "rocm";
      default = null;
      description = "Which type of GPU should be used for hardware acceleration";
    };
  };

  config.services.ollama = mkIf cfg.enable {
    inherit (cfg) enable;
    acceleration = cfg.gpu;
    environmentVariables = {
      OLLAMA_CONTEXT_LENGTH = "8192";
    };
  };
}
