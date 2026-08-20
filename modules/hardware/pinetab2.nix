{
  flake.modules.nixos.pinetab2 = {lib, ...}:
    with lib; {
      options.mySystem.hardware.pinetab2.enable = mkEnableOption "Activate support for the PineTab2";
      config = {
        boot.kernelParams = ["console=tty0" "console=ttyS2,1500000n8" "rootwait" "root=LABEL=NIXOS_SD" "rw"];
        hardware.sensor.iio.enable = true;
        services.avahi = {
          enable = true;
          openFirewall = true;
        };
      };
    };
}
