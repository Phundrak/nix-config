{
  flake.modules.nixos.opentablet = {
    hardware.opentabletdriver = {
      enable = true;
      daemon.enable = true;
    };
    boot.kernelModules = ["wacom"];
  };
}
