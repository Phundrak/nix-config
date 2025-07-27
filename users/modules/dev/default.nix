{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.home.dev;
in {
  imports = [
    ./editors
    ./ollama.nix
    ./vcs
  ];

  options.home.dev.fullDesktop = mkEnableOption "Enables everything except AI";
  config.home.dev = {
    vcs.fullDesktop = mkDefault cfg.fullDesktop;
    editors.fullDesktop = mkDefault cfg.fullDesktop;
  };
}
