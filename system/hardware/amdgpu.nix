{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.mySystem.hardware.amdgpu;
in {
  options.mySystem.hardware.amdgpu.enable = mkEnableOption "Enables an AMD GPU configuration";
  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
    ];
    hardware.graphics.extraPackages = with pkgs; [rocmPackages.clr.icd];
    environment.systemPackages = with pkgs; [
      clinfo
      amdgpu_top
      nvtopPackages.amd
    ];
  };
}
