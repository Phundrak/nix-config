# DO-NOT-EDIT. This file was auto-generated using github:denful/flake-file.
# Use `nix run .#write-flake` to regenerate it.
{
  description = "NixOS and Home Manager configuration of phundrak";

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);

  nixConfig = {
    extra-experimental-features = [
      "nix-command"
      "flakes"
    ];
    extra-substituters = [
      "https://phundrak.cachix.org?priority=10"
      "https://nix-community.cachix.org?priority=20"
      "https://cache.nixos.org?priority=40"
    ];
    extra-trusted-public-keys = [
      "phundrak.cachix.org-1:osJAkYO0ioTOPqaQCIXMfIRz1/+YYlVFkup3R2KSexk="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
    http-connections = 128;
  };

  inputs = {
    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-file.url = "github:vic/flake-file";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    import-tree.url = "github:vic/import-tree";
    jj-cz = {
      url = "git+https://labs.phundrak.com/phundrak/jj-cz?ref=develop";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgsPinetab2Kernel.url = "github:nixos/nixpkgs/e73de5be04e0eff4190a1432b946d469c794e7b4";
    nixpkgsStable.url = "nixpkgs/nixos-25.11";
    pumo-system-info = {
      url = "git+https://labs.phundrak.com/phundrak/pumo-system-info";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rockchip = {
      url = "github:raboof/nixos-rockchip/pinetab-linux-7.0";
      inputs = {
        nixpkgsStable.follows = "nixpkgsStable";
        nixpkgsUnstable.follows = "nixpkgsPinetab2Kernel";
        utils.follows = "flake-utils";
      };
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
}
