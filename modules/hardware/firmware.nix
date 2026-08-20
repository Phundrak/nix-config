{
  flake.modules.nixos.firmware = {lib, ...}: {
    hardware.enableAllFirmware = lib.mkDefault true;
  };
}
