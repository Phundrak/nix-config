{config, ...}: let
  m = config.flake.modules.homeManager;
in {
  flake.modules.homeManager."creug-elcafe" = {...}: {
    imports = [m.creug];

    home = {
      cli.nh.flake = "/home/creug/.dotfiles";
      dev.editors.emacs.enable = false;
      creug.sshKey.content = builtins.readFile ../keys/id_elcafe.pub;
    };
  };
}
