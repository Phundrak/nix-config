{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.mySystem.services.traefik;
in {
  options.mySystem.services.traefik = {
    enable = mkEnableOption "Enable Traefik";
    email = mkOption {
      type = types.str;
      default = "";
    };
    dataDir = mkOption {
      type = types.path;
      default = "/tank/traefik";
      example = "/path/to/traefik/data";
    };
    environmentFiles = mkOption {
      type = types.listOf types.path;
      example = ["/var/traefik/traefik.env"];
      default = [];
    };
    dynamicConfigFile = mkOption {
      type = types.path;
      default = "${cfg.dataDir}/traefik.yaml";
      example = "/var/traefik/dynamic.yaml";
    };
  };
  config.services.traefik = {
    inherit (cfg) enable dynamicConfigFile environmentFiles;
    staticConfigOptions = {
      api.dashboard = true;
      log = {
        level = "INFO";
        filePath = "${cfg.dataDir}/traefik.log";
        format = "json";
      };
      accessLog.filePath = "${cfg.dataDir}/access.log";
      entryPoints = {
        web = {
          address = ":80";
          asDefault = true;
          http.redirections.entrypoint = {
            to = "websecure";
            scheme = "https";
          };
        };
        websecure = {
          address = ":443";
          asDefault = true;
          httpChallenge.entryPoint = "websecure";
        };
      };
      providers.docker = {
        endpoint = "unix:///var/run/docker.sock";
        exposedByDefault = false;
      };
      certificatesResolvers.cloudflare.acme = {
        inherit (cfg) email;
        storage = "${cfg.dataDir}/acme.json";
        dnsChallenge = {
          provider = "cloudflare";
          resolvers = ["1.1.1.1:53" "1.0.0.1:53"];
          propagation.delayBeforeChecks = 60;
        };
      };
    };
  };
}
