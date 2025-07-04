{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.system.hardware.corne;
in {
  options.system.hardware.corne.allowHidAccess = mkEnableOption "Enable HID access to the corne keyboard";
  config.services.udev = mkIf cfg.allowHidAccess {
    extraRules = ''
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{serial}=="*vial:f64c2b3c*", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
    '';
  };
}
