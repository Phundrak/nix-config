{config, ...}: let
  m = config.flake.modules.homeManager;
in {
  flake.modules.homeManager."phundrak-tilo" = {...}: {
    imports = [m.phundrak];

    home = {
      cli.nh.flake = "/tank/phundrak/.dotfiles";
      phundrak.sshKey.content = builtins.readFile ../keys/id_tilo.pub;
    };
  };
}
