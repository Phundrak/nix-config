{
  flake.modules.nixos.rtkit = {
    security.rtkit.enable = true;
  };
}
