{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.mySystem.services.traefik;
in {
  options.mySystem.services.traefik = {
    enable = mkEnableOption "Enable Traefikse";
    email = mkOption {
      type = types.str;
      default = "lucien@phundrak.com";
      example = "admin@example.com";
    };
    envFiles = mkOption {
      type = types.listOf types.path;
      example = ["/run/secrets/traefik.env"];
      default = [];
    };
    dynConf = mkOption {
      type = types.path;
      example = "/var/traefik/dynamic.yaml";
    };
  };
  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [80 443];
    services.traefik = {
      inherit (cfg) enable;
      environmentFiles = cfg.envFiles;
      dynamicConfigFile = cfg.dynConf;
      staticConfigOptions = {
        log = {
          level = "WARN";
          filePath = "/var/log/traefik/traefik.log";
        };
        accessLog.filePath = "/var/log/traefik/access.log";
        api.dashboard = true;
        entryPoints = {
          web = {
            address = ":80";
            http.redirections.entryPoint = {
              to = "websecure";
              scheme = "https";
            };
          };
          websecure.address = ":443";
        };
        certificatesResolvers.cloudflare.acme = {
          inherit (cfg) email;
          storage = "/var/lib/traefik/acme.json";
          dnsChallenge = {
            provider = "cloudflare";
            resolvers = ["1.1.1.1:53" "1.0.0.1:53"];
            propagation.delayBeforeChecks = 60;
          };
        };
        providers.docker = {
          endpoint = "unix:///var/run/docker.sock";
          exposedByDefault = false;
        };
      };
    };
  };
}
