{
  inputs,
  lib,
  config,
  ...
}: {
  imports = [
    inputs.flake-parts.flakeModules.modules
    inputs.flake-file.flakeModules.default
  ];

  options.flake.homeConfigurations = lib.mkOption {
    type = lib.types.lazyAttrsOf lib.types.raw;
    default = {};
  };

  config = {
    flake-file.inputs = {
      flake-utils.url = "github:numtide/flake-utils";
      nixpkgsPinetab2Kernel.url = "github:nixos/nixpkgs/e73de5be04e0eff4190a1432b946d469c794e7b4";
      rockchip = {
        url = "github:raboof/nixos-rockchip/pinetab-linux-7.0";
        inputs.utils.follows = "flake-utils";
        inputs.nixpkgsStable.follows = "nixpkgsStable";
        inputs.nixpkgsUnstable.follows = "nixpkgsPinetab2Kernel";
      };
    };
    systems = ["x86_64-linux" "aarch64-linux"];

    flake.lib = {
      mkNixos = system: name: {
        ${name} = inputs.nixpkgs.lib.nixosSystem {
          modules = [
            config.flake.modules.nixos.${name}
            {nixpkgs.hostPlatform = lib.mkDefault system;}
          ];
        };
      };
      mkHome = system: userName: hostName: {
        "${userName}@${hostName}" = inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = inputs.nixpkgs.legacyPackages.${system};
          extraSpecialArgs = {
            inherit inputs;
            bunBaseline = config.flake.packages.${system}.bun-baseline;
          };
          modules = [config.flake.modules.homeManager."${userName}-${hostName}"];
        };
      };
      mkPinetab = buildPlatform: variantModule: {
        pinetab2 = inputs.nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = [
            inputs.rockchip.nixosModules.sdImageRockchip
            inputs.rockchip.nixosModules.dtOverlayPCIeFix
            inputs.rockchip.nixosModules.noZFS
            config.flake.modules.nixos.pinetab2-base
            variantModule
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

    flake.nixosConfigurations = lib.mkMerge [
      (config.flake.lib.mkNixos "x86_64-linux" "marpa")
      (config.flake.lib.mkNixos "x86_64-linux" "gampo")
      (config.flake.lib.mkNixos "x86_64-linux" "tilo")
      (config.flake.lib.mkNixos "x86_64-linux" "elcafe")
      (config.flake.lib.mkNixos "x86_64-linux" "NaroMk3")
      (config.flake.lib.mkPinetab "x86_64-linux" config.flake.modules.nixos.pinetab2-gnome)
    ];
    flake.homeConfigurations = lib.mkMerge [
      (config.flake.lib.mkHome "x86_64-linux" "phundrak" "marpa")
      (config.flake.lib.mkHome "x86_64-linux" "phundrak" "gampo")
      (config.flake.lib.mkHome "x86_64-linux" "phundrak" "tilo")
      (config.flake.lib.mkHome "x86_64-linux" "phundrak" "elcafe")
      (config.flake.lib.mkHome "x86_64-linux" "creug" "elcafe")
      (config.flake.lib.mkHome "x86_64-linux" "phundrak" "NaroMk3")
      (config.flake.lib.mkHome "aarch64-linux" "phundrak" "pinetab2")
    ];
    perSystem = {
      pkgs,
      system,
      ...
    }: {
      formatter = pkgs.alejandra;
      devShells.default = pkgs.mkShell {
        buildInputs = [
          pkgs.nh
          pkgs.jujutsu
          pkgs.git
          inputs.jj-cz.packages.${system}.default
        ];
      };
    };
  };
}
