{
  flake.modules.nixos.trackball = {
    services.libinput.mouse.middleEmulation = true;
  };
}
