{
  flake.modules.nixos.zfs = {
    lib,
    config,
    ...
  }:
    with lib; let
      cfg = config.mySystem.boot;
    in {
      options.mySystem.boot.zfs = {
        pools = mkOption {
          type = types.listOf types.str;
          default = [];
        };
        forceImportRoot = mkEnableOption "Force-import the ZFS root pool at boot, even if it looks already imported elsewhere";
      };
      config.boot.supportedFilesystems = ["zfs"];
      config.boot.zfs.extraPools = cfg.zfs.pools;
      config.boot.zfs.forceImportRoot = cfg.zfs.forceImportRoot;
    };
}
