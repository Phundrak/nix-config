{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mySystem.i18n.input;
in {
  options.mySystem.i18n.input.enable = mkEnableOption "Enable i18n input with fcitx5";

  config.i18n.inputMethod = mkIf cfg.enable {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-gtk
      fcitx5-mozc-ut # Japanese input support
      fcitx5-nord
      fcitx5-table-other # X-SAMPA to IPA support
      qt6Packages.fcitx5-chinese-addons # allow to load table addons
      qt6Packages.fcitx5-configtool
      qt6Packages.fcitx5-with-addons
    ];
  };
}
