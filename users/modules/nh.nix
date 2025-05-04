{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.nh;
in {
  options.modules.nh.flake = mkOption {
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
