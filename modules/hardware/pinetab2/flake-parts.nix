{inputs, ...}:
{
  flake-file.inputs = {
    rockchip = {
      url = "github:raboof/nixos-rockchip/pinetab-linux-7.0";
      inputs.utils.follows = "flake-utils";
      inputs.nixpkgsStable.follows = "nixpkgsStable";
      inputs.nixpkgsUnstable.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
  };

  config.flake.factory.pinetab2 = buildPlatform: variantModules: {
    nixos.pinetab2 = {
      imports = [
        inputs.rockchip.nixosModules.sdImageRockchip
        inputs.rockchip.nixosModules.dtOverlayPCIeFix
        inputs.rockchip.nixosModules.noZFS
        inputs.self.modules.nixos.pinetab2-base
      ] ++ variantModules;
      rockchip.uBoot = inputs.rockchip.packages.${buildPlatform}.uBootPineTab2;
      boot.kernelPackages =
        inputs.rockchip.legacyPackages.${buildPlatform}.kernel_linux_7_0_pinetab_unstable;
      hardware.firmware = [ inputs.rockchip.packages.aarch64-linux.bes2600 ];
    };
  };
}
