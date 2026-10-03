{
  flake.modules.nixos.i18n-input = {pkgs, ...}: {
    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5.addons = with pkgs; [
        fcitx5-gtk
        fcitx5-mozc-ut
        fcitx5-nord
        fcitx5-table-other
        qt6Packages.fcitx5-chinese-addons
        qt6Packages.fcitx5-configtool
        qt6Packages.fcitx5-with-addons
      ];
    };
  };
}
