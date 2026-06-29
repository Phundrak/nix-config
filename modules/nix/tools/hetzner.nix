{inputs, ...}:
{
  flake-file.inputs.srvos = {
    url = "github:nix-community/srvos";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  flake.modules.nixos.hetzner-server = {
    imports = [
      inputs.srvos.nixosModules.server
      inputs.srvos.nixosModules.hardware-hetzner-cloud
      inputs.srvos.nixosModules.mixins-terminfo
    ];
  };
}
