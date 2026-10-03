{
  flake.modules.nixos.kernel = {
    pkgs,
    config,
    lib,
    ...
  }:
    with lib; let
      cfg = config.mySystem.boot.kernel;
    in {
      options.mySystem.boot.kernel = {
        package = mkOption {
          type = types.raw;
          default = pkgs.linuxPackages_zen;
        };
        modules = mkOption {
          type = types.listOf types.str;
          default = [];
        };
        cpuVendor = mkOption {
          description = "Intel or AMD?";
          type = types.enum ["intel" "amd"];
          default = "amd";
        };
        v4l2loopback.enable = mkEnableOption "Enables v4l2loopback kernel module";
        extraModprobeConfig = mkOption {
          type = types.lines;
          default = "";
          example = ''
            options snd_usb_audio vid=0x1235 pid=0x8212 device_setup=1
          '';
        };
      };
      config.boot = {
        initrd.kernelModules = ["i915"];
        extraModprobeConfig =
          strings.concatLines
          ([cfg.extraModprobeConfig]
            ++ lists.optional cfg.v4l2loopback.enable ''options v4l2loopback exclusive_caps=1 devices=1 video_nr=0 card_label="OBS Studio"'');
        kernelPackages = cfg.package;
        kernelModules = cfg.modules ++ ["kvm-${cfg.cpuVendor}"];
      };
    };
}
