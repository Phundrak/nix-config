{
  imports = [./light-home.nix];
  home.phundrak.sshKey = {
    content = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHTv1lb6d99O84jeh6GdjPm8Gnt/HncSRhGhmoTq7BMK lucien@phundrak.com";
    file = "/home/phundrak/.ssh/id_ed25519.pub";
  };
  modules.nh.flake = "/home/phundrak/.dotfiles";
}
