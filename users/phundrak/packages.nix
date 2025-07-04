{
  pkgs,
  inputs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.packages;
in {
  options.modules.packages.emacsPackage = mkOption {
    type = types.package;
    default = pkgs.emacs;
  };
  config.home.packages = with pkgs; let
    scripts = import ../scripts {
      inherit pkgs;
      config.emacsPkg = cfg.emacsPackage;
    };
  in
    [
      flatpak

      # LSP servers
      bash-language-server
      docker-language-server
      kdePackages.qtdeclarative # For QML LSP
      nil # Nix
      python3 # for Emacs and LSP
      yaml-language-server # Yaml (Docker, GitHub Actions, ...)

      # Terminal stuff
      duf
      ffmpeg
      ripgrep-all
      unzip

      # Fonts
      #nerdfonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      tibetan-machine

      # Browsers
      amfora

      # Media
      ani-cli
      audacity
      plexamp
      plex-desktop
      spicetify-cli
      spotify
      pavucontrol # Volume control

      # Social
      vesktop # Discord alternative that works well with wayland
      element-desktop
      signal-desktop-bin

      # Misc
      bitwarden
      gplates
      libnotify
      nextcloud-client
      onlyoffice-bin
      scrcpy
      syncthing
      watchmate
      inputs.zen-browser.packages.${system}.default
      inputs.pumo-system-info.packages.${system}.default
      inputs.quickshell.packages.${system}.default

      # Games
      atlauncher
      heroic
      modrinth-app
      openmw
      openttd-jgrpp
      moonlight-qt

      # Emacs stuff
      emacs-all-the-icons-fonts

      # Gnome stuff
      gnome-tweaks
      gnomeExtensions.docker
      gnomeExtensions.syncthing-indicator
      gnomeExtensions.tray-icons-reloaded
      gthumb

      # Graphics
      inkscape
      gimp
      gimpPlugins.fourier
      gimpPlugins.farbfeld

      # Dev
      devenv
      dive # A tool for exploring each layer in a docker image
      grype # Vulnerability scanner for container images and filesystems
      kicad # Working on my custom keyboard
      podman-desktop
      podman-compose
      tectonic # better LaTeX engine
      virt-manager
      zeal
    ]
    ++ scripts;
}
