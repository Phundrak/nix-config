{
  imports = [./home.nix];
  home.phundrak.sshKey = {
    content = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBPhP4p9KGk6jSOxJzBu+RzJPHI6baT0o+xrgPeNRwfq lucien@phundrak.com";
    file = "/home/phundrak/.ssh/id_ed25519.pub";
  };
}
