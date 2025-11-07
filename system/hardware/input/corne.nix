{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.mySystem.hardware.input.corne;
in {
  options.mySystem.hardware.input.corne.allowHidAccess = mkEnableOption "Enable HID access to the corne keyboard";
  config.services.udev = mkIf cfg.allowHidAccess {
    extraRules = ''
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{serial}=="*vial:f64c2b3c*", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
    '';
  };
}
