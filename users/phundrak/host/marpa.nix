{config, ...}: {
  imports = [../home.nix];
  home = {
    cli.nh.flake = "${config.home.homeDirectory}/.dotfiles";
    dev.ai = {
      enable = true;
      ollama.gpu = "rocm";
    };
    desktop.hyprland.host = "marpa";
    phundrak.sshKey = {
      content = builtins.readFile ../../../keys/id_marpa.pub;
    };
  };
}
