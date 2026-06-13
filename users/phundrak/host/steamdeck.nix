{config, ...}: {
  import = [../home.nix];
  home = {
    # cli.nh.flake = "${config.home.homeDirectory}/.dotfiles";
    desktop.hyprland.enable = false;
    phundrak.sshKey.content = builtins.readFile ../keys/id_steamdeck.pub;
    dev.ai = {
      enable = true;
      ollama.enable = false;
    };
    stateVersion = "25.11";
  };
  programs.caelestia.enable = false;
}
