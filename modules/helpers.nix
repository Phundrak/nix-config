{
  inputs,
  lib,
  ...
}: {
  config.flake.lib = {
    mkNixos = system: name: {
      ${name} = inputs.nixpkgs.lib.nixosSystem {
        modules = [
          inputs.self.modules.nixos.${name}
          {nixpkgs.hostPlatform = lib.mkDefault system;}
        ];
      };
    };

    mkHome = system: username: hostname: {
      "${username}@${hostname}" = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = inputs.nixpkgs.legacyPackages.${system};
        extraSpecialArgs = {inherit inputs;};
        modules = [inputs.self.modules.homeManager.${username}.${hostname}];
      };
    };

    mkPinetab = buildPlatform: variantModules: {
      pinetab2 = inputs.nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules =
          [
            inputs.rockchip.nixosModules.sdImageRockchip
            inputs.rockchip.nixosModules.dtOverlayPCIeFix
            inputs.rockchip.nixosModules.noZFS
            inputs.self.modules.nixos.pinetab2-base
          ]
          ++ variantModules
          ++ [
            {
              rockchip.uBoot = inputs.rockchip.packages.${buildPlatform}.uBootPineTab2;
              boot.kernelPackages =
                inputs.rockchip.legacyPackages.${buildPlatform}.kernel_linux_7_0_pinetab_unstable;
              hardware.firmware = [inputs.rockchip.packages.aarch64-linux.bes2600];
              nixpkgs.config.allowUnfreePredicate = pkg:
                builtins.elem (inputs.nixpkgs.lib.getName pkg) ["bes2600-firmware"];
            }
          ];
      };
    };
  };
}
