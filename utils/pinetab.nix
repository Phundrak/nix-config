{
  nixpkgs,
  rockchip,
  additionalModules,
  specialArgs,
  ...
}: buildPlatform: variant:
nixpkgs.lib.nixosSystem {
  system = "aarch64-linux";
  inherit specialArgs;
  modules = [
    rockchip.nixosModules.sdImageRockchip
    rockchip.nixosModules.dtOverlayPCIeFix
    rockchip.nixosModules.noZFS
    ../hosts/pinetab2
    variant
    {
      rockchip.uBoot = rockchip.packages.${buildPlatform}.uBootPineTab2;
      boot.kernelPackages = rockchip.legacyPackages.${buildPlatform}.kernel_linux_7_0_pinetab_unstable;
      hardware.firmware = [rockchip.packages.aarch64-linux.bes2600];
      nixpkgs.config.allowUnfreePredicate = pkg:
        builtins.elem (nixpkgs.lib.getName pkg) [
          "bes2600-firmware"
        ];
    }
  ] ++ additionalModules;
}
