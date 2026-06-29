{
  inputs,
  lib,
  ...
}: let
  settingsToLines = with lib;
    settings:
      concatStringsSep "\n" (
        mapAttrsToList (name: value: "set ${name} ${toString value}") settings
      );
in {
  flake-file.inputs.zen-browser = {
    url = "github:youwen5/zen-browser-flake";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.modules.homeManager.firefox = {
    config,
    pkgs,
    ...
  }:
    with lib; let
      cfg = config.flake.options.firefox;
      inherit (pkgs.stdenv.hostPlatform) system;
      zen = inputs.zen-browser.packages.${system}.default;
    in {
      options.flake.options.firefox = {
        enable = mkEnableOption "enable Firefox";
        useZen = mkEnableOption "use Zen instead of Firefox";
        tridactyl = {
          enable = mkEnableOption "enable Tridactyl";
          preConfig = mkOption {
            description = "Lines to add to the beginning of tridactylrc";
            type = types.lines;
            default = "";
          };
          config = mkOption {
            type = with types;
              attrsOf (oneOf [int str bool]);
            description = "Tridactyl settings (converted to 'set key value' lines)";
            default = {};
            example = {
              smoothscroll = true;
              history = 1000;
            };
          };
          extraConfig = mkOption {
            description = "Extra lines to add to tridactylrc (for bindings, autocmds, etc)";
            type = types.lines;
            default = "";
          };
        };
      };

      config = mkIf cfg.enable {
        home.sessionVariables.MOZ_ENABLE_WAYLAND = "1";
        programs.firefox = {
          inherit (cfg) enable;
          package =
            if cfg.useZen
            then zen
            else pkgs.firefox;
          nativeMessagingHosts = lists.optional cfg.tridactyl.enable pkgs.tridactyl-native;
          configPath = ".mozilla/firefox";
        };
        xdg.configFile."tridactyl/tridactylrc" = mkIf cfg.tridactyl.enable {
          text = concatStringsSep "\n" (filter (s: s != "") [
            cfg.tridactyl.preConfig
            (settingsToLines (cfg.tridactyl.config
              // {
                browser =
                  if cfg.useZen
                  then "zen"
                  else "firefox";
              }))
            cfg.tridactyl.extraConfig
          ]);
        };
      };
    };
}
