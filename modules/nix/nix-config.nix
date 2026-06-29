{
  flake.nixConfig = {
    extra-trusted-public-keys = [
      "marpa-local:XoO+dFN4PeauF52pYuy3Vh4Sdtl2qIdxu5aUasWKv6Q="
      "phundrak.cachix.org-1:osJAkYO0ioTOPqaQCIXMfIRz1/+YYlVFkup3R2KSexk="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
    extra-substituters = [
      "http://marpa:5000?priority=5"
      "https://phundrak.cachix.org?priority=10"
      "https://nix-community.cachix.org?priority=20"
      "https://cache.nixos.org?priority=40"
    ];
    extra-experimental-features = [ "nix-command" "flakes" ];
    http-connections = 128;
  };
}
