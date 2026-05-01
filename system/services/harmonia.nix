{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.mySystem.services.harmonia;
in {
  options.mySystem.services.harmonia = {
    enable = mkEnableOption "Harmonia Nix binary cache server";
    port = mkOption {
      type = types.port;
      default = 5000;
      description = "Port to listen on";
    };
    priority = mkOption {
      type = types.ints.between 0 100;
      default = 50;
      description = "Cache priority (lower = higher priority, 0-100)";
    };
    signKeyPaths = mkOption {
      type = types.listOf types.path;
      description = "Paths to the signing keys to use for signing the cache.";
    };
  };
  config = mkIf cfg.enable {
    services.harmonia.cache = {
      enable = true;
      inherit (cfg) signKeyPaths;
      settings = {
        inherit (cfg) priority;
        bind = "[::]:${toString cfg.port}";
      };
    };
  };
}
