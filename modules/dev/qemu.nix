{
  flake.modules.nixos.qemu = {
    config,
    lib,
    pkgs,
    ...
  }:
    with lib; let
      cfg = config.mySystem.dev.qemu;
    in {
      options.mySystem.dev.qemu.users = mkOption {
        type = types.listOf types.str;
        default = ["phundrak"];
        example = ["user1" "user2"];
      };
      config = {
        programs.virt-manager.enable = true;
        users.groups.libvirtd.members = cfg.users;
        virtualisation = {
          libvirtd.enable = true;
          spiceUSBRedirection.enable = true;
        };
        environment.systemPackages = with pkgs; [
          qemu
          quickemu
          swtpm
        ];
        systemd.tmpfiles.rules = ["L+ /var/lib/qemu/firmware - - - - ${pkgs.qemu}/share/qemu/firmware"];
        boot.binfmt.emulatedSystems = ["aarch64-linux"];
      };
    };
}
