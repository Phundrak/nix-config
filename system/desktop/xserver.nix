{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.mySystem.desktop.xserver;
in {
  options.mySystem.desktop.xserver = {
    enable = mkEnableOption "Enables xserver";
    de = mkOption {
      type = types.enum ["gnome" "kde"];
      default = "gnome";
      example = "kde";
      description = "Which DE to enable";
    };
  };
  config.services = mkIf cfg.enable {
    displayManager = {
      sddm.enable = mkIf (cfg.de == "kde") true;
      gdm.enable = mkIf (cfg.de == "gnome") true;
    };
    desktopManager = {
      plasma6.enable = mkIf (cfg.de == "kde") true;
      gnome.enable = mkIf (cfg.de == "gnome") true;
    };

    gnome = mkIf (cfg.de == "gnome") {
      gnome-browser-connector.enable = true;
      games.enable = false;
      gnome-remote-desktop.enable = true;
      gnome-online-accounts.enable = true;
      sushi.enable = true;
    };

    xserver = {
      inherit (cfg) enable;
      videoDrivers = lists.optional config.mySystem.hardware.amdgpu.enable "amdgpu";
      xkb = {
        layout = "fr";
        variant = "bepo_afnor";
      };
    };
  };
}
