{
  flake-file = {
    inputs = {
      nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
      nixpkgsStable.url = "nixpkgs/nixos-25.11";
      flake-parts.url = "github:hercules-ci/flake-parts";
      flake-file.url = "github:vic/flake-file";
      import-tree.url = "github:vic/import-tree";
      home-manager = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      jj-cz = {
        url = "git+https://labs.phundrak.com/phundrak/jj-cz?ref=main";
        inputs.nixpkgs.follows = "nixpkgs";
      };
    };
    outputs = "flake-parts";
  };
}
