{
  pkgs,
  config,
  ...
}: {
  gtk = {
    enable = true;
    colorScheme = "dark";
    iconTheme = {
      name = "Nordzy-icons";
      package = pkgs.nordzy-icon-theme;
    };
    theme = {
      package = pkgs.nordic;
      name = "Nordic";
    };
  };
  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    hyprcursor.enable = config.home.desktop.hyprland.enable;
    name = "Nordzy-cursors";
    package = pkgs.nordzy-cursor-theme;
  };
  qt.enable = true;
}
