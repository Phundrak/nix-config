{
  flake-file.inputs = {
    nixpkgsStable.url = "nixpkgs/nixos-25.11";
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-file.url = "github:vic/flake-file";
    import-tree.url = "github:vic/import-tree";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  flake-file.outputs = "dendritic";
  flake-file.description = "NixOS and Home Manager configuration of P'undrak";
}
