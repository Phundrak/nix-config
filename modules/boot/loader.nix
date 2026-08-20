{
  flake.modules.nixos.loader = {
    lib,
    config,
    ...
  }:
    with lib; let
      cfg = config.mySystem.boot;
    in {
      options.mySystem.boot = {
        systemd-boot = mkOption {
          type = types.bool;
          default = !cfg.grub.enable;
          description = "Does the system use systemd-boot?";
        };
        grub = {
          enable = mkEnableOption "Does the system use GRUB? (Disables systemd-boot)";
          device = mkOption {
            type = types.path;
            description = "The GRUB device";
            default = "";
          };
        };
        zfs = {
          enable = mkEnableOption "Enables ZFS";
          pools = mkOption {
            type = types.listOf types.str;
            default = [];
          };
        };
      };

      config.boot = {
        loader = {
          systemd-boot.enable = cfg.systemd-boot;
          efi.canTouchEfiVariables = cfg.systemd-boot;
          grub = mkIf cfg.grub.enable {
            inherit (cfg.grub) enable device;
          };
        };
        supportedFilesystems = mkIf cfg.zfs.enable ["zfs"];
        zfs.extraPools = mkIf cfg.zfs.enable cfg.zfs.pools;
      };
    };
}
