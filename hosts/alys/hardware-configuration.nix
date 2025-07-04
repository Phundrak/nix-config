{
  modulesPath,
  lib,
  ...
}: {
  imports = [(modulesPath + "/profiles/qemu-guest.nix")];
  boot = {
    loader.grub = {
      efiSupport = true;
      efiInstallAsRemovable = true;
      device = "nodev";
    };
    initrd.availableKernelModules = ["ata_piix" "uhci_hcd" "xen_blkfront" "vmw_pvscsi"];
    initrd.kernelModules = ["nvme"];
  };
  fileSystems = {
    "/" = {
      device = "/dev/vda1";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/F137-8D01";
      fsType = "vfat";
    };
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
