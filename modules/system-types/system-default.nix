{config, ...}: let
  m = config.flake.modules.nixos;
in {
  flake.modules.nixos.system-default = {
    imports = [
      m.nix-cache-settings
      m.locale
      m.misc
      m.base-packages
      m.nano
      m.nix-settings
      m.networking
      m.tailscale
      m.rtkit
      m.firmware
      m.trackball
      m.system-account-phundrak
      m.system-account-creug
      m.system-account-root
    ];

    # from system/users/default.nix, unconditional
    programs.zsh.enable = true;
  };
}
