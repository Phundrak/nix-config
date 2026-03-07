# https://handy.computer/
{
  appimageTools,
  fetchurl,
  lib,
}: let
  name = "Handy";
  pname = lib.strings.toLower name;
  version = "0.7.7";
  src = fetchurl {
    url = "https://github.com/cjpais/${name}/releases/download/v${version}/${name}_${version}_amd64.AppImage";
    hash = "sha256-76Hno39I3+46blnVW6XWwg944vF5n7IdMYXGMlYMNb0=";
  };
  appimageContent = appimageTools.extractType2 {inherit pname version src;};
in
  appimageTools.wrapType2 {
    inherit pname version src;
    extraPkgs = pkgs: [pkgs.wtype];
    extraInstallCommands = ''
      install -m 444 -D ${appimageContent}/${name}.desktop $out/share/applications/${name}.desktop
      install -m 444 -D ${appimageContent}/${name}.png $out/share/icons/hicolor/256x256/apps/${name}.png
      install -m 444 -D ${appimageContent}/${pname}.png $out/share/icons/hicolor/256x256/apps/${pname}.png
    '';
  }
