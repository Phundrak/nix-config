{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.home.cli;
in {
  imports = [
    ./bat.nix
    ./btop.nix
    ./direnv.nix
    ./eza.nix
    ./mu.nix
    ./nh.nix
    ./nix-index.nix
    ./scripts
    ./tealdeer.nix
    ./yt-dlp.nix
  ];

  options.home.cli.fullDesktop = mkEnableOption "Enable all optional modules and options";
  config.home.cli = {
    bat.extras = mkDefault cfg.fullDesktop;
    mu.enable = mkDefault cfg.fullDesktop;
    scripts.enable = mkDefault cfg.fullDesktop;
    yt-dlp.enable = mkDefault cfg.fullDesktop;
  };
}
