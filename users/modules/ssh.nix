{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.ssh;
in {
  options.modules.ssh = {
    enable = mkEnableOption "enables SSH";
    hosts = mkOption {
      type = types.nullOr types.path;
      default = null;
    };
  };

  config = {
    programs.ssh = mkIf cfg.enable {
      enable = true;
      includes = mkIf (cfg.hosts != null) [cfg.hosts];
    };
  };
}
