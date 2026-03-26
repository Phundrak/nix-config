{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
with lib; let
  inherit (pkgs.stdenv.hostPlatform) system;
  cfg = config.home.dev.ai.opencode;
  defaultPackageCli = inputs.opencode.packages.${system}.opencode;
  defaultPackageDesktop = inputs.opencode.packages.${system}.desktop;
  corsList = domains: lists.remove "" (lists.forEach (strings.splitString "," domains) trim);
in {
  options.home.dev.ai.opencode = {
    enable = mkEnableOption "Enables OpenCode";
    package = mkOption {
      type = types.package;
      default = defaultPackageCli;
      description = "The CLI package for OpenCode";
    };
    settings = mkOption {
      type = types.json;
      default = {};
    };
    tui = mkOption {
      type = types.json;
      default = {};
    };
    desktop = {
      enable = mkEnableOption "Enables the desktop app";
      package = mkOption {
        type = types.package;
        default = defaultPackageDesktop;
        description = "The desktop package for OpenCode";
      };
    };
    web = {
      enable = mkEnableOption "Enables OpenCode web";
      extraArgs = mkOption {
        type = types.listOf types.str;
        default = [];
        example = [
          "--hostname"
          "0.0.0.0"
        ];
      };
      cors = mkOption {
        type = types.nullOr (types.either types.str types.path);
        default = null;
        example = "opencode.example.com,code.example.com";
        description = ''
          Either a string containing the domain allowed to connect to OpenCode’s web instance, or a file containing the target value. The latter is useful when using secret management if you don’t want to publicize the hostname of your OpenCode instance.

          If you want to use multiple domains, you can separate them with a comma.
        '';
      };
      mdns = {
        enable = mkEnableOption "Enables mDNS with OpenCode";
        hostname = mkOption {
          type = types.nullOr types.str;
          default = null;
          example = "opencode.local";
        };
      };
    };
  };
  config.programs.opencode = mkIf cfg.enable {
    inherit (cfg) enable tui;
    enableMcpIntegration = true;
    extraPackages = with pkgs; [uv];
    settings =
      {
        server = mkIf cfg.web.mdns.enable {
          mdns = true;
          mdnsDomain = mkIf (cfg.web.mdns.hostname != null) cfg.web.mdns.hostname;
          cors = corsList cfg.web.cors;
        };
      }
      // cfg.settings;
    web = {
      inherit (cfg.web) enable extraArgs;
    };
  };
}
