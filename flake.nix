{
  description = "Home Manager configuration of phundrak";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    devenv = {
      url = "github:cachix/devenv";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pumo-system-info = {
      url = "git+https://labs.phundrak.com/phundrak/pumo-system-info";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    quickshell = {
      url = "git+https://git.outfoxxed.me/quickshell/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    claude-desktop = {
      url = "github:k3d3/claude-desktop-linux-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    devenv,
    ...
  } @ inputs: let
    inherit (self) outputs;
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    formatter.${system} = pkgs.alejandra;

    packages.${system} = {
      devenv-up = self.devShells.${system}.default.config.procfileScript;
      devenv-test = self.devShells.${system}.default.config.test;
    };

    devShells.${system}.default = devenv.lib.mkShell {
      inherit inputs pkgs;
      modules = [
        (
          {pkgs, ...}: {
            packages = [pkgs.nh];
            git-hooks.hooks = {
              alejandra.enable = true;
              commitizen.enable = true;
              detect-private-keys.enable = true;
              end-of-file-fixer.enable = true;
              deadnix.enable = true;
              ripsecrets.enable = true;
              statix.enable = true;
            };
          }
        )
      ];
    };

    homeConfigurations = let
      extraSpecialArgs = {inherit inputs outputs system;};
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in {
      "phundrak@alys" = home-manager.lib.homeManagerConfiguration {
        inherit extraSpecialArgs pkgs;
        modules = [
          ./users/phundrak/host/alys.nix
          inputs.sops-nix.homeManagerModules.sops
        ];
      };
      "phundrak@marpa" = home-manager.lib.homeManagerConfiguration {
        inherit extraSpecialArgs pkgs;
        modules = [
          ./users/phundrak/host/marpa.nix
          inputs.sops-nix.homeManagerModules.sops
        ];
      };
      "phundrak@gampo" = home-manager.lib.homeManagerConfiguration {
        inherit extraSpecialArgs pkgs;
        modules = [
          ./users/phundrak/host/gampo.nix
          inputs.sops-nix.homeManagerModules.sops
        ];
      };
      "phundrak@tilo" = home-manager.lib.homeManagerConfiguration {
        inherit extraSpecialArgs pkgs;
        modules = [
          ./users/phundrak/host/tilo.nix
          inputs.sops-nix.homeManagerModules.sops
        ];
      };
    };

    nixosConfigurations = let
      specialArgs = {inherit inputs outputs;};
    in {
      alys = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = [
          ./hosts/alys/configuration.nix
          inputs.sops-nix.nixosModules.sops
        ];
      };
      gampo = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = [
          ./hosts/gampo/configuration.nix
          inputs.sops-nix.nixosModules.sops
        ];
      };
      marpa = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = [
          ./hosts/marpa/configuration.nix
          inputs.sops-nix.nixosModules.sops
        ];
      };
      tilo = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = [
          ./hosts/tilo/configuration.nix
          inputs.sops-nix.nixosModules.sops
        ];
      };
    };
  };
}
