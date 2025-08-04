{config, ...}: {
  imports = [../light-home.nix];
  home = {
    cli.nh.flake = "/tank/phundrak/nixos";
    phundrak.sshKey = {
      content = builtins.readFile ../../../keys/id_tilo.pub;
      # file = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
    };
  };
}
