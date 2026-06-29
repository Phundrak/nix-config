{pkgs, ...}: {
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        mesa rocmPackages.clr rocmPackages.clr.icd rocmPackages.rocblas
        rocmPackages.hipblas rocmPackages.rpp nvtopPackages.amd
      ];
    };
    amdgpu = { initrd.enable = true; opencl.enable = true; };
  };
  environment.systemPackages = with pkgs; [ clinfo amdgpu_top nvtopPackages.amd ];
  systemd = {
    packages = with pkgs; [ lact ];
    services.lactd.wantedBy = [ "multi-user.target" ];
    tmpfiles.rules = let
      rocmEnv = pkgs.symlinkJoin {
        name = "rocm-combined";
        paths = with pkgs.rocmPackages; [ clr clr.icd rocblas hipblas rpp ];
      };
    in [ "L+    /opt/rocm   -    -    -     -    ${rocmEnv}" ];
  };
  environment.variables = {
    ROCM_PATH = "/opt/rocm";
    HIP_VISIBLE_DEVICES = "1";
    ROCM_VISIBLE_DEVICES = "1";
    HSA_OVERRIDE_GFX_VERSION = "10.3.0";
  };
}
