{
  perSystem = {pkgs, ...}: {
    packages.bun-baseline = pkgs.callPackage ../../packages/bun-baseline.nix {};
  };
}
