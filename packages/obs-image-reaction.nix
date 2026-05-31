{
  lib,
  stdenv,
  obs-studio,
  fetchFromGitHub,
  cmake,
  ...
}:
stdenv.mkDerivation (finalAttrs: rec {
  pname = "obs-image-reaction";
  version = "0.1.0";
  # https://github.com/scaledteam/obs-image-reaction
  src = fetchFromGitHub {
    owner = "scaledteam";
    repo = pname;
    rev = "4cd345e78c714e80e894cfb51c72b94135a6014d";
    hash = "sha256-mC1B8tveHx35pfbAcOlosB8YKaBVg87MjXbr79sf7+k=";
  };
  nativeBuildInputs = [cmake];
  buildInputs = [obs-studio];
  postInstall = "rm -rf $out/obs-plugins $out/data";

  meta = {
    description = "OBS Plugin with image that reacts to sound source";
    homepage = "https://github.com/scaledteam/obs-image-reaction";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
  };
})
