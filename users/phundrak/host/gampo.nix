{config, ...}: {
  imports = [../home.nix];
  home = {
    cli.nh.flake = "${config.home.homeDirectory}/.dotfiles";
    desktop.hyprland.host = "gampo";
    phundrak.sshKey.content = builtins.readFile ../keys/id_gampo.pub;
  };
}
