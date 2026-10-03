{
  flake.modules.nixos.disable-ibm-trackpoint = {
    services.udev.extraRules = ''
      ATTRS{name}=="*TPPS/2 IBM TrackPoint", ENV{ID_INPUT}="", ENV{ID_INPUT_MOUSE}="", ENV{ID_INPUT_POINTINGSTICK}=""
    '';
  };
}
