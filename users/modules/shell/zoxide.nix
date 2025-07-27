{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.home.shell.zoxide;
in {
  options.home.shell.zoxide = {
    enable = mkEnableOption "Enable zoxide";
    replaceCd = mkEnableOption "Replace cd with zoxide";
  };
  config.programs.zoxide = mkIf cfg.enable {
    inherit (cfg) enable;
    options = mkIf cfg.replaceCd [
      "--cmd cd"
    ];
  };
}
