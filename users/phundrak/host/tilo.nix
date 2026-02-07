{
  imports = [../light-home.nix];
  home = {
    cli.nh.flake = "/tank/phundrak/.dotfiles";
    phundrak.sshKey.content = builtins.readFile ../keys/id_tilo.pub;
  };
}
