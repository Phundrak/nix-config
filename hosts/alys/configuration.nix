{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./host.nix
    inputs.home-manager.nixosModules.default
    ../../modules/locale.nix
    ../../modules/system.nix
    ../../modules/ssh.nix
    ../../modules/endlessh.nix
    ../../programs/nano.nix
  ];

  zramSwap.enable = true;

  # networking.domain = "phundrak.com";
  system = {
    amdgpu.enable = false;
    boot = {
      kernel = {
        hardened = true;
        cpuVendor = "amd";
      };
      systemd-boot = false;
      zfs.enable = false;
    };
    networking = {
      hostname = "alys";
      domain = "phundrak.com";
      id = "41157110";
      firewall.openPorts = [
        22
      ];
    };
    sound.enable = false;
    users = {
      root.disablePassword = true;
      phundrak = true;
    };
  };

  modules = {
    ssh = {
      enable = true;
      allowedUsers = ["phundrak"];
      passwordAuthentication = false;
    };
    endlessh.enable = false;
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = [pkgs.openssl];

  # networking.hostName = "alys";
  # users.users.root.openssh.authorizedKeys.keys = [
  #   "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC+b7BE/gHrHVkqNVfHtp2r4OCUDdohst8hb3Bz5tYtx3gvXJQCB1rFc2hgQJf8FsVyQbidS64lnhU1rUIEbFhv7itT5FGGUnfJEYs64W30wKsnPSb5WXdFXzrNi8za48i2oNl9JA9Fj9k6isyvkTup89hB+ELbXIcfz3bM93WaAt2dIgKijXaAMAAA+tHhgWvlrHlvGlU9/KxY3ZOQSoEboPXd7TDyOf1672eAibYyb5h1HIewYZ+xv1X4dxx/c9Arh4K0s8scuB7XTQQkEbRUEYKD2YXKN83Z09jfMlMYuBAKKO8zU4CM2KTbL7kEVgNc/ArY+uCAakmC5+eS7LxMuOt86+Bi4gXTJ6o6dbfUbCGiq751ni8pg44YSfwYiI05vvZ08eIyNkowumD+X4GRW4tu0I3qK8TI7exeEeoQIwlSfLXlYHEdNB8Q3feLyhHMRkxXgUskbXwWIBexLzJyY40tyqQplZWbYGrUEmjxZ7FWmaV+o8ZjnU2GfJ8JoWyCnEYfRc6Z2ILdXNDRzZ9qYOwefMHtuaYaYYximL+zdVVrm4EZuOetmaJ6zblk4ebU3GZjYykB8DmCDFDZO9koKwzPazLKQl0OWzmQqgxVNg7Mg1NZbuRQgVAhKPelnqejaXbf2/IHAYBn5LDR1Jew5+srlstM9XuYG2whEOx84w== Lucien Cartier-Tilet <lucien@phundrak.com>"
  #   "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILw9oiK8tZ5Vpz82RaRLpITU8qeJrT2hjvudGEDQu2QW lucien@phundrak.com"
  # ];
  system.stateVersion = "23.11";
}
