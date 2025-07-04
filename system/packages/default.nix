{pkgs, ...}: {
  imports = [
    ./appimage.nix
    ./flatpak.nix
    ./nano.nix
    ./nix.nix
    ./steam.nix
  ];

  environment.systemPackages = with pkgs; [
    curl
    openssl
    wget
  ];
}
