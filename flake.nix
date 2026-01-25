{
  description = "Home Manager configuration of phundrak";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

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

    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    srvos = {
      url = "github:nix-community/srvos";
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
    srvos,
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
      defaultUserModules = [
        inputs.sops-nix.homeManagerModules.sops
        inputs.spicetify.homeManagerModules.default
        inputs.caelestia-shell.homeManagerModules.default
      ];
      withUserModules = modules: nixpkgs.lib.lists.flatten (defaultUserModules ++ [modules]);
    in {
      "phundrak@alys" = home-manager.lib.homeManagerConfiguration {
        inherit extraSpecialArgs pkgs;
        modules = withUserModules ./users/phundrak/host/alys.nix;
      };
      "creug@elcafe" = home-manager.lib.homeManagerConfiguration {
        inherit extraSpecialArgs pkgs;
        modules = withUserModules ./users/creug/host/elcafe.nix;
      };
      "phundrak@elcafe" = home-manager.lib.homeManagerConfiguration {
        inherit extraSpecialArgs pkgs;
        modules = withUserModules ./users/phundrak/host/elcafe.nix;
      };
      "phundrak@gampo" = home-manager.lib.homeManagerConfiguration {
        inherit extraSpecialArgs pkgs;
        modules = withUserModules ./users/phundrak/host/marpa.nix;
      };
      "phundrak@marpa" = home-manager.lib.homeManagerConfiguration {
        inherit extraSpecialArgs pkgs;
        modules = withUserModules ./users/phundrak/host/marpa.nix;
      };
      "phundrak@NaroMk3" = home-manager.lib.homeManagerConfiguration {
        inherit extraSpecialArgs pkgs;
        modules = withUserModules ./users/phundrak/host/naromk3.nix;
      };
      "phundrak@tilo" = home-manager.lib.homeManagerConfiguration {
        inherit extraSpecialArgs pkgs;
        modules = withUserModules ./users/phundrak/host/tilo.nix;
      };
    };

    nixosConfigurations = let
      specialArgs = {inherit inputs outputs;};
      defaultSystemModules = [
        inputs.sops-nix.nixosModules.sops
      ];
      withSystemModules = modules: nixpkgs.lib.lists.flatten (defaultSystemModules ++ [modules]);
    in {
      alys = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = withSystemModules ./hosts/alys/configuration.nix;
      };
      elcafe = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = withSystemModules ./hosts/elcafe/configuration.nix;
      };
      gampo = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = withSystemModules ./hosts/gampo/configuration.nix;
      };
      marpa = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = withSystemModules ./hosts/marpa/configuration.nix;
      };
      NaroMk3 = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = withSystemModules [
          srvos.nixosModules.server
          srvos.nixosModules.hardware-hetzner-cloud
          srvos.nixosModules.mixins-terminfo
          ./hosts/naromk3/configuration.nix
        ];
      };
      tilo = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = withSystemModules ./hosts/tilo/configuration.nix;
      };
    };
  };
}
