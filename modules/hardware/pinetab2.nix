{
  flake.modules.nixos.pinetab2 = {
    boot.kernelParams = ["console=tty0" "console=ttyS2,1500000n8" "rootwait" "root=LABEL=NIXOS_SD" "rw"];
    hardware.sensor.iio.enable = true;
    services.avahi = {
      enable = true;
      openFirewall = true;
    };
  };
}
