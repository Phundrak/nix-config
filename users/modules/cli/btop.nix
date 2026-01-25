{
  pkgs,
  config,
  ...
}: let
  inherit (config.home) gpuType;
in {
  programs.btop = {
    enable = true;
    package =
      if gpuType != null
      then
        pkgs.btop.override {
          rocmSupport = gpuType == "amd";
          cudaSupport = gpuType == "nvidia";
        }
      else pkgs.btop;
    settings = {
      color_theme = "${pkgs.btop}/share/btop/themes/nord.theme";
      cpu_bottom = false;
      cpu_sensor = "auto";
      io_graph_combined = false;
      io_mode = true;
      only_physical = true;
      proc_tree = true;
      rounded_corners = true;
      show_disks = true;
      show_gpu_info = "on";
      show_uptime = true;
      theme_background = true;
      vim_keys = false;
    };
  };
}
