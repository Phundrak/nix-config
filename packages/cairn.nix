# https://cairns.gg/
{
  stdenv,
  fetchzip,
  makeWrapper,
  lib,
  fontconfig,
  freetype,
  libx11,
  libxext,
  libxrandr,
  libxinerama,
  libxi,
  libxcursor,
  libxrender,
  libxfixes,
  libxtst,
  libxcb,
  libxkbcommon,
  libglvnd,
  libICE,
  libSM,
  dbus,
  libxshmfence,
}:
stdenv.mkDerivation rec {
  pname = "cairn";
  version = "0.9.11";
  src = fetchzip {
    url = "https://download.cairns.gg/releases/${version}/${pname}-${version}-linux-x64.tar.gz";
    hash = "sha256-UbjeEbP4o6y+0j1oeF3RwqTuunGB5wD0CSpdFDk97/U=";
  };

  nativeBuildInputs = [makeWrapper];

  dontBuild = true;
  dontPatchELF = true;
  dontStrip = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 $src/cairn $out/bin/cairn
    wrapProgram $out/bin/cairn \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [
      stdenv.cc.cc.lib
      fontconfig
      freetype
      libx11
      libxext
      libxrandr
      libxinerama
      libxi
      libxcursor
      libxrender
      libxfixes
      libxtst
      libxcb
      libxkbcommon
      libglvnd
      libICE
      libSM
      dbus
      libxshmfence
    ]}

    mkdir -p $out/share/applications
    cat > $out/share/applications/cairn.desktop <<EOF
[Desktop Entry]
Version=0.9.11
Name=Cairns
Comment=Modpacks for Vintage Story
Exec=$out/bin/cairn
Icon=cairn
Terminal=false
Type=Application
Categories=Games
EOF

    install -Dm644 ${./cairn.svg} $out/share/icons/hicolor/scalable/apps/${pname}.svg
    runHook postInstall
  '';

  meta = {
    description = "Modpacks for Vintage Story";
    homepage = "https://cairns.gg/";
    platforms = ["x86_64-linux"];
  };
}
