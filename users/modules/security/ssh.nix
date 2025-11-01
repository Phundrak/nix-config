{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.home.security.ssh;
in {
  options.home.security.ssh = {
    enable = mkEnableOption "enables SSH";
    hosts = mkOption {
      type = types.nullOr types.path;
      default = null;
    };
  };

  config = {
    programs.ssh = mkIf cfg.enable {
      enable = true;
      enableDefaultConfig = false;
      includes = lists.optional (cfg.hosts != null) cfg.hosts;
    };
  };
}
