{
  imports = [./light-home.nix];
  home.phundrak.sshKey = {
    content = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILw9oiK8tZ5Vpz82RaRLpITU8qeJrT2hjvudGEDQu2QW lucien@phundrak.com";
    file = "/home/phundrak/.ssh/id_ed25519.pub";
  };
  modules.nh.flake = "/tank/phundrak/nixos";
}
