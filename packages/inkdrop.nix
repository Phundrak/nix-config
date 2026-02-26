# https://www.inkdrop.app/
{
  lib,
  fetchurl,
  stdenv,
  autoPatchelfHook,
  makeWrapper,
  wrapGAppsHook3,
  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  cairo,
  cups,
  dbus,
  expat,
  gdk-pixbuf,
  glib,
  gtk3,
  libdrm,
  libnotify,
  libpulseaudio,
  libsecret,
  libuuid,
  libxkbcommon,
  mesa,
  nspr,
  nss,
  pango,
  systemd,
  libx11,
  libxscrnsaver,
  libxcomposite,
  libxcursor,
  libxdamage,
  libxext,
  libxfixes,
  libxi,
  libxrandr,
  libxrender,
  libxtst,
  libxcb,
  libxkbfile,
  libxshmfence,
}:
stdenv.mkDerivation rec {
  pname = "inkdrop";
  version = "5.11.8";

  src = fetchurl {
    url = "https://dist.inkdrop.app/v${version}/${pname}_${version}_amd64.deb";
    hash = "sha256-8aJSeUi5K9PgNJvfYAtnRnI2t+vM10jiqVAZmX+zni0=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
    wrapGAppsHook3
  ];

  buildInputs = [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    cairo
    cups
    dbus
    expat
    gdk-pixbuf
    glib
    gtk3
    libdrm
    libnotify
    libpulseaudio
    libsecret
    libuuid
    libxkbcommon
    mesa
    nspr
    nss
    pango
    systemd
    libx11
    libxscrnsaver
    libxcomposite
    libxcursor
    libxdamage
    libxext
    libxfixes
    libxi
    libxrandr
    libxrender
    libxtst
    libxcb
    libxkbfile
    libxshmfence
  ];

  dontBuild = true;
  dontConfigure = true;

  # Ignore musl dependency since we're using glibc
  autoPatchelfIgnoreMissingDeps = [ "libc.musl-x86_64.so.1" ];

  unpackPhase = ''
    runHook preUnpack

    # Extract deb file manually to avoid setuid issues
    ar x $src
    tar xf data.tar.xz --no-same-permissions --no-same-owner

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    # Create output directories
    mkdir -p $out/bin $out/share

    # Copy the main application
    cp -r usr/lib/inkdrop $out/share/inkdrop

    # Copy desktop file and icon
    cp -r usr/share/applications $out/share/
    cp -r usr/share/pixmaps $out/share/

    # Fix desktop file to use absolute paths
    substituteInPlace $out/share/applications/inkdrop.desktop \
      --replace-quiet "Exec=inkdrop" "Exec=$out/bin/inkdrop" \
      --replace-quiet "Icon=inkdrop" "Icon=$out/share/pixmaps/inkdrop.png"

    # Create wrapper script in bin
    makeWrapper $out/share/inkdrop/inkdrop $out/bin/inkdrop \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
      --set-default ELECTRON_IS_DEV 0 \
      --inherit-argv0

    runHook postInstall
  '';

  meta = with lib; {
    description = "Notebook app for Markdown lovers";
    homepage = "https://www.inkdrop.app/";
    license = licenses.unfree;
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "inkdrop";
  };
}
