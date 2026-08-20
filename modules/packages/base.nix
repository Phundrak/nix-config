{
  flake.modules.nixos.base-packages = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      curl
      openssl
      wget
    ];
  };
}
