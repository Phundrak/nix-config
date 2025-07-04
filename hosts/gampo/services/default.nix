{
  # imports = [
  #   ./gnome.nix
  # ];

  services = {
    # Enable CUPS to print documents.
    printing.enable = true;
    openssh.enable = true;
    fwupd.enable = true;
    udev.extraRules = ''
      ATTRS{name}=="*TPPS/2 IBM TrackPoint", ENV{ID_INPUT}="", ENV{ID_INPUT_MOUSE}="", ENV{ID_INPUT_POINTINGSTICK}=""
    '';
  };
}
