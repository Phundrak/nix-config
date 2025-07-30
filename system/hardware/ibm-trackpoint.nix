{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.system.hardware.ibmTrackpoint;
in {
  options.system.hardware.ibmTrackpoint.disable = mkEnableOption "Disable IBM’s trackpoint on ThinkPad";
  config.services.udev = mkIf cfg.disable {
    extraRules = ''
      ATTRS{name}=="*TPPS/2 IBM TrackPoint", ENV{ID_INPUT}="", ENV{ID_INPUT_MOUSE}="", ENV{ID_INPUT_POINTINGSTICK}=""
    '';
  };
}
