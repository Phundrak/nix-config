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
    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [
          mesa # Mesa drivers for AMD GPUs
          rocmPackages.clr # common language runtime for ROCm
          rocmPackages.clr.icd # ROCm ICD for OpenCL
          rocmPackages.rocblas # ROCm BLAS library
          rocmPackages.hipblas #
          rocmPackages.rpp # High-performance computer vision library
          nvtopPackages.amd # GPU utilization monitoring
        ];
      };
      amdgpu = {
        initrd.enable = true;
        opencl.enable = true;
      };
    };
    environment.systemPackages = with pkgs; [
      clinfo
      amdgpu_top
      nvtopPackages.amd
    ];
    systemd = {
      packages = with pkgs; [lact];
      services.lactd.wantedBy = ["multi-user.target"];
      tmpfiles.rules = let
        rocmEnv = pkgs.symlinkJoin {
          name = "rocm-combined";
          paths = with pkgs.rocmPackages; [
            clr
            clr.icd
            rocblas
            hipblas
            rpp
          ];
        };
      in [
        "L+    /opt/rocm   -    -    -     -    ${rocmEnv}"
      ];
    };
    environment.variables = {
      ROCM_PATH = "/opt/rocm"; # Set ROCm path
      HIP_VISIBLE_DEVICES = "1"; # Use only the eGPU (ID 1)
      ROCM_VISIBLE_DEVICES = "1"; # Optional: ROCm equivalent for visibility
      # LD_LIBRARY_PATH = "/opt/rocm/lib";         # Add ROCm libraries
      HSA_OVERRIDE_GFX_VERSION = "10.3.0"; # Set GFX version override
    };
  };
}
