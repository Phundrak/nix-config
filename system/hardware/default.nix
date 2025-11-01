{lib, ...}:
{
  imports = [
    ./amdgpu.nix
    ./bluetooth.nix
    ./corne.nix
    ./ibm-trackpoint.nix
    ./opentablet.nix
    ./sound.nix
  ];
  hardware.enableRedistributableFirmware = lib.mkDefault true;
}
