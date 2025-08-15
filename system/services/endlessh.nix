{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.mySystem.services.endlessh;
in {
  options.mySystem.services.endlessh = {
    enable = mkEnableOption "Enables endlessh.";
    port = mkOption {
      type = types.port;
      default = 2222;
      example = 22;
    };
  };
  config.services.endlessh-go = mkIf cfg.enable {
    inherit (cfg) enable port;
    openFirewall = true;
  };
}
