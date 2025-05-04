{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.amdgpu;
in {
  options.modules.amdgpu.enable = mkEnableOption "Enables an AMD GPU configuration";
  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
    ];
    hardware.graphics.extraPackages = with pkgs; [rocmPackages.clr.icd];
  };
}
