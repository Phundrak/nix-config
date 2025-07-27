{config, ...}: {
  imports = [../home.nix];
  home = {
    cli.nh.flake = "${config.home.homeDirectory}/nixos";
    desktop.hyprland.host = "gampo";
    phundrak.sshKey = {
      content = builtins.readFile ../../../keys/id_gampo.pub;
      # file = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
    };
  };
}
