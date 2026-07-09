{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.home.dev.ai.opencode;

  # On x86_64-linux CPUs without AVX2, use the baseline bun variant
  # when building opencode - the regular `bun` from nixpkgs requires
  # AVX2 and crashes on older hardware, such as my Thinkpad x220’s
  # Intel Core i5 2640M.
  needsBaselineBun =
    pkgs.stdenv.hostPlatform.isx86_64 && !pkgs.stdenv.hostPlatform.avx2Support;
  bunBaseline = pkgs.callPackage ../../../../packages/bun-baseline.nix {};

  defaultPackageCli =
    if needsBaselineBun
    then pkgs.opencode.override {bun = bunBaseline;}
    else pkgs.opencode;

  defaultPackageDesktop =
    if needsBaselineBun
    then pkgs.opencode-desktop.override {bun = bunBaseline;}
    else pkgs.opencode-desktop;

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
    inherit (cfg) enable tui package;
    enableMcpIntegration = true;
    extraPackages = with pkgs; [uv] ++ lists.optional cfg.desktop.enable cfg.desktop.package;
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
