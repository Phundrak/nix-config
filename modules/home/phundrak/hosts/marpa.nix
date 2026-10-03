{config, ...}: let
  m = config.flake.modules.homeManager;
in {
  flake.modules.homeManager."phundrak-marpa" = {config, pkgs, ...}: {
    imports = [m.phundrak];

    home = {
      fullDesktop = true;
      gpuType = "amd";
      cli.nh.flake = "${config.home.homeDirectory}/.dotfiles";
      dev.ai = {
        enable = true;
        ollama.gpu = "rocm";
        mcpServers = {
          nix.command = "${pkgs.mcp-nixos}/bin/mcp-nixos";
        };
      };
      desktop = {
        hyprland.host = "marpa";
        caelestia.idleTimeout = 60 * 60 * 24; # a day
      };
      phundrak.sshKey.content = builtins.readFile ../keys/id_marpa.pub;
    };
    programs.caelestia.settings.bar.status = {
      showBattery = false;
      showWifi = false;
    };
  };
}
