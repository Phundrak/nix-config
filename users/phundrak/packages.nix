{
  pkgs,
  inputs,
  lib,
  ...
}:
with lib; let
  inherit (pkgs.stdenv.hostPlatform) system;
in {
  programs.bun.enable = true;
  home.packages = with pkgs; [
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
    pavucontrol # Volume control

    # Social
    vesktop # Discord alternative that works well with wayland
    element-desktop
    signal-desktop-bin

    # Misc
    bitwarden-desktop
    gplates
    libnotify
    nextcloud-client
    onlyoffice-desktopeditors
    scrcpy
    syncthing
    watchmate
    inputs.zen-browser.packages.${system}.default
    inputs.pumo-system-info.packages.${system}.default

    # Games
    atlauncher
    heroic
    openmw
    openttd-jgrpp
    moonlight-qt

    # Gnome stuff
    gnomeExtensions.tray-icons-reloaded
    gthumb

    # Graphics
    inkscape
    gimp
    gimpPlugins.gmic

    # Dev
    dbeaver-bin
    devenv
    nodejs
    sqlite
    tectonic # better LaTeX engine
    wakatime-cli
    zeal

    ## LSP servers
    bash-language-server
    docker-language-server
    kdePackages.qtdeclarative # For QML LSP
    nixd
    nixfmt
    marksman
    python3 # for Emacs and LSP
    vscode-json-languageserver
    yaml-language-server # Yaml (Docker, GitHub Actions, ...)
  ];
}
