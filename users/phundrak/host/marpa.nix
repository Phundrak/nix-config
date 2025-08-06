{config, ...}: {
  imports = [../home.nix];
  home = {
    cli.nh.flake = "${config.home.homeDirectory}/.dotfiles";
    desktop.hyprland.host = "marpa";
    phundrak.sshKey = {
      content = builtins.readFile ../../../keys/id_marpa.pub;
    };
  };
}
