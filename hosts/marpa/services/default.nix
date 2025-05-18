{
  imports = [
    ../../../modules/ssh.nix
    ../../../modules/sunshine.nix
    ../../../modules/xserver.nix
  ];

  modules = {
    sunshine = {
      enable = true;
      autostart = true;
    };
    xserver = {
      amdgpu.enable = true;
      de = "gnome";
    };
  };
  services = {
    blueman.enable = true;
    fwupd.enable = true;
    printing.enable = true;
    openssh.enable = true;
  };
}
