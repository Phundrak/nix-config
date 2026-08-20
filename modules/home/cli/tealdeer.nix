{
  flake.modules.homeManager.tealdeer = {
    programs.tealdeer = {
      enable = true;
      enableAutoUpdates = true;
    };
  };
}
