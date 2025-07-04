{pkgs, ...}: {
  environment.systemPackages = with pkgs; [neofetch vim emacs];
}
