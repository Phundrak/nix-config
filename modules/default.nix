{
  inputs,
  lib,
  config,
  ...
}: {
  imports = [./helpers.nix];

  config = {
    flake = {
      nixosConfigurations = lib.mkMerge [
        (config.flake.lib.mkNixos "x86_64-linux" "alys")
        (config.flake.lib.mkNixos "x86_64-linux" "elcafe")
        (config.flake.lib.mkNixos "x86_64-linux" "gampo")
        (config.flake.lib.mkNixos "x86_64-linux" "marpa")
        (config.flake.lib.mkNixos "x86_64-linux" "NaroMk3")
        (config.flake.lib.mkNixos "x86_64-linux" "tilo")
        (config.flake.lib.mkPinetab "x86_64-linux" [
          inputs.self.modules.nixos.pinetab2-gnome
        ])
      ];

      homeConfigurations = lib.mkMerge [
        (config.flake.lib.mkHome "aarch64-linux" "phundrak" "pinetab2")
        (config.flake.lib.mkHome "x86_64-linux" "creug" "elcafe")
        (config.flake.lib.mkHome "x86_64-linux" "phundrak" "NaroMk3")
        (config.flake.lib.mkHome "x86_64-linux" "phundrak" "alys")
        (config.flake.lib.mkHome "x86_64-linux" "phundrak" "elcafe")
        (config.flake.lib.mkHome "x86_64-linux" "phundrak" "gampo")
        (config.flake.lib.mkHome "x86_64-linux" "phundrak" "marpa")
        (config.flake.lib.mkHome "x86_64-linux" "phundrak" "tilo")
      ];
    };
    perSystem = {
      config',
      pkgs,
      ...
    }: {
      formatter = pkgs.alejandra;
      devShells.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          nh
          jujutsu
          git
          inputs.jj-cz.packages.${config'.system}.default
        ];
      };
    };
  };
}
