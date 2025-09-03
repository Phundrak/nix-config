{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mySystem.dev.qemu;
in {
  options.mySystem.dev.qemu.enable = mkEnableOption "Enable QEMU";
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      qemu
      virt-manager
    ];
    systemd.tmpfiles.rules = ["L+ /var/lib/qemu/firmware - - - - ${pkgs.qemu}/share/qemu/firmware"];
    boot.binfmt.emulatedSystems = ["aarch64-linux"];
  };
}
