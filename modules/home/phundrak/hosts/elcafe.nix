{config, ...}: let
  m = config.flake.modules.homeManager;
in {
  flake.modules.homeManager."phundrak-elcafe" = {...}: {
    imports = [m.phundrak];

    home = {
      cli.nh.flake = "/home/phundrak/.dotfiles";
      dev.editors.emacs.enable = false;
      phundrak.sshKey.content = builtins.readFile ../keys/id_elcafe.pub;
    };
  };
}
