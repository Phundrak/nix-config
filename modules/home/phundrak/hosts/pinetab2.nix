{config, ...}: let
  m = config.flake.modules.homeManager;
in {
  flake.modules.homeManager."phundrak-pinetab2" = {config, ...}: {
    imports = [m.phundrak];

    home = {
      fullDesktop = true;
      cli.nh.flake = "${config.home.homeDirectory}/.dotfiles";
      desktop.hyprland.host = "gampo";
      phundrak.sshKey.content = builtins.readFile ../keys/id_pinetab2.pub;
    };
    programs.caelestia.settings.bar.persistent = false;
  };
}
