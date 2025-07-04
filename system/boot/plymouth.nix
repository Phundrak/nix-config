{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.system.boot.plymouth;
in {
  options.system.boot.plymouth.enable = mkEnableOption "Enables Plymouth at system boot";
  config.boot = mkIf cfg.enable {
    plymouth = {
      inherit (cfg) enable;
      theme = "circle_hud";
      themePackages = with pkgs; [
        (adi1090x-plymouth-themes.override {
          selected_themes = ["circle_hud"];
        })
      ];
    };
    consoleLogLevel = 3;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"
    ];
    # Loader appears only if a key is pressed
    loader.timeout = 0;
  };
}
