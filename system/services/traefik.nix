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
    dataDir = mkOption {
      type = types.path;
      default = "/tank/traefik";
    };
    email = mkOption {
      type = types.str;
      default = "";
    };
  };
  config.services.traefik = {
    inherit (cfg) enable;
    dynamicConfigFile = "${cfg.dataDir}/dynamic_config.toml";
    staticConfigOptions = {
      api.dashboard = true;
      log = {
        level = "INFO";
        filePath = "${cfg.dataDir}/traefik.log";
        format = "json";
      };
      accessLog.filePath = "${cfg.dataDir}/access.log";
      entryPoints = {
        http = {
          address = ":80";
          asDefault = true;
          http.redirections.entrypoint = {
            to = "https";
            scheme = "https";
          };
        };
        https = {
          address = ":443";
          asDefault = true;
          httpChallenge.entryPoint = "https";
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
        };
      };
    };
  };
}
