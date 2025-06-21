{
  pkgs,
  config,
  inputs,
  ...
}: {
  imports = [
    ./light-home.nix
    ./packages.nix
    ./email.nix
    ../modules/emacs.nix
    ../modules/emoji.nix
    ../modules/hyprland.nix
    ../modules/kdeconnect.nix
    ../modules/kitty.nix
    ../modules/mbsync.nix
    ../modules/mpd.nix
    ../modules/mpv.nix
    ../modules/ollama.nix
    ../modules/qt.nix
    ../modules/wofi.nix
    ../modules/yt-dlp.nix
  ];

  config = let
    emacsPkg = with pkgs; ((emacsPackagesFor emacsNativeComp).emacsWithPackages (
      epkgs: [
        epkgs.mu4e
        epkgs.pdf-tools
      ]
    ));
    askpass = import ../scripts/askpass.nix {inherit pkgs;};
    launchWithEmacsclient = import ../scripts/launch-with-emacsclient.nix {
      inherit pkgs;
      emacsPackage = emacsPkg;
    };
  in {
    sops.secrets = {
      emailPassword = {};
      "mopidy/bandcamp" = {};
      "mopidy/spotify" = {};
    };

    home.sessionVariables = {
      EDITOR = "${emacsPkg}/bin/emacsclient -c -a ${emacsPkg}/bin/emacs";
      LAUNCH_EDITOR = "${launchWithEmacsclient}/bin/launch-with-emacsclient";
      SUDO_ASKPASS = "${askpass}/bin/askpass";
      LSP_USE_PLISTS = "true";
    };

    modules = {
      shell = {
        eatIntegration = true;
        starship.jjIntegration = true;
      };
      bat.extras = true;
      packages.emacsPackage = emacsPkg;
      mopidy.enable = true;
      ollama.enable = true;

      emacs = {
        enable = true;
        service = true;
        package = emacsPkg;
        mu4eMime = true;
        org-protocol = true;
      };
      hyprland = {
        inherit emacsPkg;
        enable = true;
        swaync = true;
        waybar = {
          enable = true;
          battery = true;
          style = ./config/waybar/style.css;
        };
      };
      mbsync = {
        enable = true;
        passwordFile = config.sops.secrets.emailPassword.path;
      };
      ssh = {
        enable = true;
        hosts = config.sops.secrets."ssh/hosts".path;
      };
      vcs.git = {
        browser = "${inputs.zen-browser.packages.${pkgs.system}.default}/bin/zen";
        emacs = {
          integration = true;
          pkg = emacsPkg;
        };
        cliff = true;
        sendmail = {
          enable = true;
          passwordFile = config.sops.secrets.emailPassword.path;
        };
      };
    };

    programs = {
      zsh.enableVteIntegration = true;
      mu.enable = true;
      obs-studio = {
        enable = true;
        plugins = with pkgs; [
          obs-studio-plugins.input-overlay
          obs-studio-plugins.obs-backgroundremoval
          obs-studio-plugins.obs-mute-filter
          obs-studio-plugins.obs-pipewire-audio-capture
          obs-studio-plugins.obs-source-clone
          obs-studio-plugins.obs-source-record
          obs-studio-plugins.obs-tuna
        ];
      };
    };

    services = {
      blanket.enable = true;
      mpris-proxy.enable = true;
      playerctld.enable = true;
    };

    manual.html.enable = true;
  };
}
