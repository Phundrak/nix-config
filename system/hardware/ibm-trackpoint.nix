{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.mySystem.hardware.ibmTrackpoint;
in {
  options.mySystem.hardware.ibmTrackpoint.disable = mkEnableOption "Disable IBM’s trackpoint on ThinkPad";
  config.services.udev = mkIf cfg.disable {
    extraRules = ''
      ATTRS{name}=="*TPPS/2 IBM TrackPoint", ENV{ID_INPUT}="", ENV{ID_INPUT_MOUSE}="", ENV{ID_INPUT_POINTINGSTICK}=""
    '';
  };
}
