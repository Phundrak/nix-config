{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.mySystem.boot.zram;
in {
  options.mySystem.boot.zram = {
    enable = mkEnableOption "Enable ZRAM";
    memoryMax = mkOption {
      type = types.int;
      example = "512";
      description = "Maximum size allocated to ZRAM in MiB";
    };
  };
  config.zramSwap = mkIf cfg.enable {
    inherit (cfg) enable;
    memoryMax = cfg.memoryMax * 1024 * 1024;
  };
}
