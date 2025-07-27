{config, ...}: {
  imports = [../home.nix];
  home = {
    cli.nh.flake = "${config.home.homeDirectory}/nixos";
    desktop.hyprland.host = "marpa";
    phundrak.sshKey = {
      content = builtins.readFile ../../../keys/id_marpa.pub;
      # file = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
    };
  };
}
