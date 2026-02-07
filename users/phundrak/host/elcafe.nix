{
  imports = [../light-home.nix];
  home = {
    cli.nh.flake = "/tank/phundrak/.dotfiles";
    dev.editors.emacs.enable = false;
    phundrak.sshKey.content = builtins.readFile ../keys/id_elcafe.pub;
  };
}
