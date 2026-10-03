{
  flake.modules.nixos.loader = {
    lib,
    config,
    ...
  }:
    with lib; let
      cfg = config.mySystem.boot;
    in {
      options.mySystem.boot.systemd-boot = mkOption {
        type = types.bool;
        default = !cfg.grub.enable;
        description = "Does the system use systemd-boot?";
      };
      options.mySystem.boot.grub = {
        enable = mkEnableOption "Does the system use GRUB? (Disables systemd-boot)";
        device = mkOption {
          type = types.path;
          description = "The GRUB device";
        };
      };

      config.boot.loader = {
        systemd-boot.enable = cfg.systemd-boot;
        efi.canTouchEfiVariables = cfg.systemd-boot;
      };
      config.boot.loader.grub = mkIf cfg.grub.enable {
        inherit (cfg.grub) enable device;
      };
    };
}
