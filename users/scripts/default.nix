{
  config,
  pkgs,
  ...
}: let
  askpass = import ./askpass.nix {inherit pkgs;};
in [
  askpass
  (import ./backup.nix {inherit pkgs;})
  (import ./keygen.nix {inherit pkgs;})
  (import ./launch-with-emacsclient.nix {
    inherit pkgs;
    emacsPackage = config.emacsPkg;
  })
  (import ./mp42webm.nix {inherit pkgs;})
  (import ./plock.nix {inherit pkgs;})
  (import ./screenshot.nix {inherit pkgs;})
  (import ./sshbind.nix {inherit pkgs;})
]
