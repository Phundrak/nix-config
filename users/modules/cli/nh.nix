{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.home.cli.nh;
in {
  options.home.cli.nh.flake = mkOption {
    type = types.path;
    default = "/home/phundrak/.dotfiles";
    example = "/etc/nixos";
  };
  config.programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 15d --keep 5";
    inherit (cfg) flake;
  };
}
