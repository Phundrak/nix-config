{lib, ...}: {
  imports = [
    ./amdgpu.nix
    ./bluetooth.nix
    ./fingerprint.nix
    ./sound.nix
    ./input
  ];

  hardware.enableAllFirmware = lib.mkDefault true;
}
