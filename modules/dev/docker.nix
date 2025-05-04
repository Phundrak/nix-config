{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.docker;
in {
  options.modules.docker = {
    enable = mkEnableOption "Enable Docker";
    podman.enable = mkEnableOption "Enable Podman rather than Docker";
    nvidia.enable = mkEnableOption "Activate Nvidia support";
    autoprune.enable = mkEnableOption "Enable autoprune";
  };

  config = {
    virtualisation = {
      docker = mkIf (cfg.enable && !cfg.podman.enable) {
        enable = true;
        enableNvidia = cfg.nvidia.enable;
        autoPrune.enable = cfg.autoprune.enable;
      };
      podman = mkIf cfg.podman.enable {
        enable = true;
        dockerCompat = cfg.enable;
        enableNvidia = cfg.nvidia.enable;
        dockerSocket.enable = cfg.enable;
        autoPrune.enable = cfg.autoprune.enable;
      };
    };
  };
}
