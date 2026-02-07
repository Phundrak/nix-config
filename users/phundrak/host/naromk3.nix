{
  imports = [../light-home.nix];
  home = {
    cli.nh.flake = "/home/phundrak/.dotfiles";
    phundrak.sshKey.content = builtins.readFile ../keys/id_naromk3.pub;
  };
}
