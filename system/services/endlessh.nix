{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.system.services.endlessh;
in {
  options.system.services.endlessh = {
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
