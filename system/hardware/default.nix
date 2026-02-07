{lib, ...}: {
  imports = [
    ./amdgpu.nix
    ./bluetooth.nix
    ./sound.nix
    ./input
  ];

  hardware.enableAllFirmware = lib.mkDefault true;
}
