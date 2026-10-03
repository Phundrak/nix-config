let
  cacheSettings = rec {
    substituters = [
      "https://phundrak.cachix.org?priority=10"
      "https://nix-community.cachix.org?priority=20"
      "https://cache.nixos.org?priority=40"
    ];
    trustedPublicKeys = [
      "phundrak.cachix.org-1:osJAkYO0ioTOPqaQCIXMfIRz1/+YYlVFkup3R2KSexk="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
    commonConf = {
      extra-trusted-public-keys = trustedPublicKeys;
      extra-substituters = substituters;
      extra-experimental-features = ["nix-command" "flakes"];
      http-connections = 128;
    };
  };
in {
  flake-file.nixConfig = cacheSettings.commonConf;
  flake.nixConfig = cacheSettings.commonConf;
  flake.modules.nixos.nix-cache-settings = {
    nix.settings = {
      inherit (cacheSettings) substituters;
      trusted-public-keys = cacheSettings.trustedPublicKeys;
      experimental-features = ["nix-command" "flakes"];
      http-connections = 128;
    };
  };
}
