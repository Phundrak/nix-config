{
  imports = [../home.nix];
  home = {
    cli.nh.flake = "/home/creug/.dotfiles";
    dev.editors.emacs.enable = false;
    creug.sshKey.content = builtins.readFile ../keys/id_elcafe.pub;
  };
}
