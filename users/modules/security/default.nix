{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.home.security;
in {
  imports = [
    ./gpg.nix
    ./ssh.nix
  ];
  options.home.security.fullDesktop = mkEnableOption "Enable all modules";
  config.home.security = {
    gpg.enable = mkDefault cfg.fullDesktop;
    ssh.enable = mkDefault cfg.fullDesktop;
  };
}
