{
  description = "Home Manager configuration of phundrak";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    copyparty = {
      url = "github:9001/copyparty";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    jj-cz = {
      url = "git+https://labs.phundrak.com/phundrak/jj-cz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    opencode = {
      url = "github:anomalyco/opencode/v1.3.15";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pumo-system-info = {
      url = "git+https://labs.phundrak.com/phundrak/pumo-system-info";
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
    extra-experimental-features = [
      "nix-command"
      "flakes"
    ];
    http-connections = 128;
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    home-manager,
    srvos,
    ...
  } @ inputs:
    flake-utils.lib.eachDefaultSystem (
      system: let
        inherit (self) outputs;
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        formatter = pkgs.alejandra;
        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs.nh
            pkgs.jujutsu
            pkgs.git
          ];
        };

        packages = {
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
              modules = withUserModules ./users/phundrak/host/gampo.nix;
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
              inputs.copyparty.nixosModules.default
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
              modules = withSystemModules ./hosts/marpa;
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
    );
}
