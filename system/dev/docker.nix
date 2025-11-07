{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mySystem.dev.docker;
in {
  options.mySystem.dev.docker = {
    enable = mkEnableOption "Enable Docker";
    podman.enable = mkEnableOption "Enable Podman rather than Docker";
    nvidia.enable = mkEnableOption "Activate Nvidia support";
    autoprune.enable = mkEnableOption "Enable autoprune";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs;
      [
        dive # A tool for exploring each layer in a docker image
        grype # Vulnerability scanner for container images and filesystems
      ]
      ++ lists.optionals cfg.podman.enable [
        podman-compose
        podman-desktop
      ];
    virtualisation = mkIf cfg.enable {
      docker = mkIf (!cfg.podman.enable) {
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
