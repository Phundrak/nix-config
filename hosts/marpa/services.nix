{
  imports = [
    ../../modules/ssh.nix
    ../../modules/sunshine.nix
    ../../modules/xserver.nix
  ];

  modules = {
    xserver = {
      amdgpu.enable = true;
      de = "gnome";
    };
    sunshine = {
      enable = true;
      autostart = true;
    };
  };
  services = {
    printing.enable = true;
    openssh.enable = true;
    fwupd.enable = true;
  };
}
