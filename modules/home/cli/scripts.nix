{
  flake.modules.homeManager.scripts = {
    pkgs,
    lib,
    config,
    ...
  }:
    with lib; let
      cfg = config.home.cli.scripts;
      scriptFiles = filesystem.listFilesRecursive ./_scripts;
      scripts = map (file: (import file {inherit pkgs config;})) scriptFiles;
    in {
      options.home.cli.scripts.enable = mkEnableOption "Add custom scripts to PATH";
      config.home.packages = mkIf cfg.enable scripts;
    };
}
