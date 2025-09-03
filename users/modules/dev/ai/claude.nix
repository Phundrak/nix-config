{
  config,
  lib,
  inputs,
  system,
  ...
}:
with lib; let
  cfg = config.home.dev.ai.claude;
in {
  options.home.dev.ai.claude.enable = mkEnableOption "Enables Claude-related packages";
  config = mkIf cfg.enable {
    home.packages = [inputs.claude-desktop.packages.${system}.claude-desktop-with-fhs];
    programs.claude-code = {
      inherit (cfg) enable;
    };
  };
}
