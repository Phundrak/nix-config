{
  pkgs,
  config,
  ...
}: {
  imports = [
    ./light-home.nix
    ./packages.nix
    ./email.nix
    ../modules
  ];

  config = let
    emacsPkg = with pkgs; ((emacsPackagesFor emacsNativeComp).emacsWithPackages (
      epkgs: [
        epkgs.mu4e
        epkgs.pdf-tools
      ]
    ));
    askpass = import ../modules/cli/scripts/askpass.nix {inherit pkgs;};
    launchWithEmacsclient = import ../modules/cli/scripts/launch-with-emacsclient.nix {
      inherit pkgs config;
    };
  in {
    sops.secrets = {
      emailPassword = {};
      "mopidy/bandcamp" = {};
      "mopidy/spotify" = {};
    };

    home = {
      sessionVariables = {
        EDITOR = "${emacsPkg}/bin/emacsclient -c -a ${emacsPkg}/bin/emacs";
        LAUNCH_EDITOR = "${launchWithEmacsclient}/bin/launch-with-emacsclient";
        SUDO_ASKPASS = "${askpass}/bin/askpass";
        LSP_USE_PLISTS = "true";
      };

      desktop.waybar.style = ./config/waybar/style.css;
      dev.ollama = {
        enable = true;
        gpu = "amd";
      };
      fullDesktop = true;
      shell.fish.enable = true;
    };

    manual.html.enable = true;
  };
}
