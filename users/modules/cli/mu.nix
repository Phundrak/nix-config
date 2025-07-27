{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.home.cli.mu;
in {
  options.home.cli.mu.enable = mkEnableOption "Enable mu";
  config.programs.mu.enable = cfg.enable;
}
