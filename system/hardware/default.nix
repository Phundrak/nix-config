{lib, ...}: {
  imports = [
    ./amdgpu.nix
    ./bluetooth.nix
    ./fingerprint.nix
    ./input
    ./pinetab2.nix
    ./sound.nix
  ];

  hardware.enableAllFirmware = lib.mkDefault true;
}
