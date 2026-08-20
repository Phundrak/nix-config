{config, ...}: let
  m = config.flake.modules.homeManager;
in {
  flake.modules.homeManager."phundrak-gampo" = {config, ...}: {
    imports = [m.phundrak];

    home = {
      fullDesktop = true;
      cli.nh.flake = "${config.home.homeDirectory}/.dotfiles";
      dev.ai.lmStudio = false;
      desktop.hyprland.host = "gampo";
      phundrak.sshKey.content = builtins.readFile ../keys/id_gampo.pub;
    };
    programs.caelestia.settings.bar.persistent = false;
  };
}
