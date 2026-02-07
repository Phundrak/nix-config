{config, ...}: {
  imports = [../light-home.nix];
  home = {
    cli.nh.flake = "${config.home.homeDirectory}/nixos";
    phundrak.sshKey.content = builtins.readFile ../keys/id_alys.pub;
  };
}
