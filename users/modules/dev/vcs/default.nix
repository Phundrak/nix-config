{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.home.dev.vcs;
in {
  imports = [./git.nix ./jujutsu.nix];

  options.home.dev.vcs = {
    fullDesktop = mkEnableOption "Enable all optional values";
    name = mkOption {
      type = types.str;
      default = "Lucien Cartier-Tilet";
    };
    email = mkOption {
      type = types.str;
      default = "lucien@phundrak.com";
    };
    editor = mkOption {
      type = types.str;
      default = "${pkgs.emacs}/bin/emacsclient -c -a ${pkgs.emacs}/bin/emacs";
    };
    publicKey = {
      content = mkOption {
        type = types.nullOr types.str;
        example = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGj+J6N6SO+4P8dOZqfR1oiay2yxhhHnagH52avUqw5h";
        default = null;
      };
      file = mkOption {
        type = with types; nullOr path;
        default = "/home/phundrak/.ssh/id_ed25519.pub";
      };
    };
  };

  config.home.dev.vcs = {
    git = {
      enable = mkDefault true;
      inherit (cfg) name email editor;
      publicKeyFile = cfg.publicKey.file;
      cliff = mkDefault cfg.fullDesktop;
      completeConfig = mkDefault cfg.fullDesktop;
    };
    jj = {
      enable = mkDefault true;
      inherit (cfg) name email editor;
      signing.sshKey = mkDefault (cfg.publicKey.file or cfg.publicKey.content);
    };
  };
}
