{config, ...}: let
  m = config.flake.modules.homeManager;
in {
  flake.modules.homeManager."phundrak-NaroMk3" = {...}: {
    imports = [m.phundrak];

    home = {
      cli.nh.flake = "/home/phundrak/.dotfiles";
      phundrak.sshKey.content = builtins.readFile ../keys/id_naromk3.pub;
    };
  };
}
