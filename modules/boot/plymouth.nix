{
  flake.modules.nixos.plymouth = {pkgs, ...}: {
    boot = {
      plymouth = {
        enable = true;
        theme = "circle_hud";
        themePackages = with pkgs; [
          (adi1090x-plymouth-themes.override {
            selected_themes = ["circle_hud"];
          })
        ];
      };
      kernelParams = [
        "quiet"
        "splash"
        "boot.shell_on_fail"
        "udev.log_level=3"
        "rd.systemd.show_status=auto"
      ];
      consoleLogLevel = 3;
      initrd.verbose = false;
      loader.timeout = 0;
    };
  };
}
