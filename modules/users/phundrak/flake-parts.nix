{inputs, ...}: {
  flake.modules = {
    nixos.phundrak = {
      imports = [./nixos.nix];
      home-manager.users.phundrak = {
        imports = [inputs.self.modules.homeManager.phundrak];
      };
    };
    homeManager.phundrak = {
      imports = [./homeManager.nix];
    };
  };
}
