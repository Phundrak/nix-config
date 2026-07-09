# Baseline variant of Bun for x86_64-linux CPUs without AVX2 support.
# The regular `bun` from nixpkgs requires AVX2 and crashes with SIGILL on older hardware.
#
# Version is typically kept in sync with nixpkgs's `bun` (passed via `callPackage`).
{
  lib,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
  unzip,
  makeBinaryWrapper,
  glibc,
  stdenv,
  version ? "1.3.13",
}: let
  # When updating `version`, compute the new hash with:
  #   nix store prefetch-file  "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-linux-x64-baseline.zip"
  hash = {
    "1.3.13" = "sha256-nYokKSpwaAkCBdqsCloiP19pc29Sh+N7+I07QDHtx1A=";
  };
in
  stdenvNoCC.mkDerivation {
    pname = "bun-baseline";
    inherit version;

    src = fetchurl {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-linux-x64-baseline.zip";
      hash = hash.${version};
    };

    nativeBuildInputs =
      [unzip]
      ++ lib.optionals stdenvNoCC.hostPlatform.isLinux [
        autoPatchelfHook
        makeBinaryWrapper
      ];

    buildInputs = lib.optionals stdenvNoCC.hostPlatform.isLinux [
      glibc
      (lib.getLib stdenv.cc.cc)
    ];

    dontConfigure = true;
    dontBuild = true;

    unpackPhase = ''
      runHook preUnpack
      mkdir -p source
      cd source
      ${lib.getExe unzip} -q $src
      runHook postUnpack
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin
      find . -type f -name "bun" -not -path "./__MACOSX/*" -exec cp {} $out/bin/bun \;
      chmod +x $out/bin/bun
      ln -s $out/bin/bun $out/bin/bunx
      runHook postInstall
    '';

    meta = {
      description = "Bun JavaScript runtime (baseline variant, works without AVX2)";
      homepage = "https://bun.sh";
      license = lib.licenses.mit;
      platforms = ["x86_64-linux"];
      mainProgram = "bun";
    };
  }
