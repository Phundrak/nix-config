{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.xserver;
in {
  options.modules.xserver = {
    amdgpu.enable = mkEnableOption "Enables AMD GPU support";
    de = mkOption {
      type = types.enum ["gnome" "kde"];
      default = "gnome";
      example = "kde";
      description = "Which DE to enable";
    };
  };
  config.services = {
    displayManager.sddm.enable = mkIf (cfg.de == "kde") true;
    desktopManager.plasma6.enable = mkIf (cfg.de == "kde") true;

    gnome = mkIf (cfg.de == "gnome") {
      gnome-browser-connector.enable = true;
      games.enable = false;
      gnome-remote-desktop.enable = true;
      gnome-online-accounts.enable = true;
      sushi.enable = true;
    };

    xserver = {
      enable = true;
      displayManager.gdm.enable = mkIf (cfg.de == "gnome") true;
      desktopManager.gnome.enable = mkIf (cfg.de == "gnome") true;
      videoDrivers = lists.optional cfg.amdgpu.enable "amdgpu";
      xkb = {
        layout = "fr";
        variant = "bepo_afnor";
      };
    };
  };
}
